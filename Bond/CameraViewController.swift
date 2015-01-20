//
//  CameraViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 1/9/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

	@IBOutlet var flash: UIImageView!
	@IBOutlet var flip: UIImageView!
	@IBOutlet var capture: CircleImageView!
	@IBOutlet var cancel: UIImageView!
	@IBOutlet var next: UIButton!

	let captureSession:AVCaptureSession! = AVCaptureSession()
	var captureDevice:AVCaptureDevice!
	var currentPosition:AVCaptureDevicePosition!
	var cameraInput:AVCaptureDeviceInput!
	var cameraOutput:AVCaptureStillImageOutput!
	var videoConnection:AVCaptureConnection!
	var capturedPhoto:UIImage!
	var image:UIImage!
	var imagePreview:UIImageView!
	var previewLayer:AVCaptureVideoPreviewLayer!
	var mask:MaskView!
	var takingPhoto:Bool! = false
	var whiteScreen:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.edgesForExtendedLayout = UIRectEdge.None

		// Set up view controller properties
		self.navigationController?.title = "Smile!"
		self.view.backgroundColor = AppData.util.UIColorFromRGB(0x4A4A4A)

		// Set up flash button
		flash.userInteractionEnabled = true
		flash.image = AppData.util.scaleImage(UIImage(named: "Flash On.png")!, size: CGSizeMake(12.5, 25), scale: 1.0)
		flash.frame.size = CGSizeMake(12.5, 25)
		flash.center = CGPointMake(30, 40)
		flash.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "switchFlash"))

		// Set up flip button
		flip.userInteractionEnabled = true
		flip.image = AppData.util.scaleImage(UIImage(named: "Flip.png")!, size: CGSizeMake(18.5, 25), scale: 1.0)
		flip.frame.size = CGSizeMake(18.5, 25)
		flip.center = CGPointMake(self.view.frame.width - 30, 40)
		flip.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "flipCamera"))

		// Set up capture button
		capture.userInteractionEnabled = true
		capture.frame.size = CGSizeMake(62.5, 62.5)
		capture.center = CGPointMake(self.view.frame.width / 2, AppData.data.heights.navViewHeight - 100)
		capture.addBorder(0xFFFFFF)
		capture.untappedBackground = UIColor.clearColor()
		capture.tappedBackground = UIColor.clearColor()
		capture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "takePhoto"))

		// Programmatically create white circles
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(52.5, 52.5), false, 0)
		var imageContext = UIGraphicsGetCurrentContext()
		CGContextAddEllipseInRect(imageContext, CGRectMake(0, 0, 52.5, 52.5))
		CGContextClip(imageContext)
		CGContextClearRect(imageContext, CGRectMake(0, 0, 52.5, 52.5))
		UIColor.whiteColor().setFill()
		CGContextFillRect(imageContext, CGRect(origin: CGPointZero, size: CGSizeMake(52.5, 52.5)))
		var solidCircle = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		UIGraphicsBeginImageContextWithOptions(CGSizeMake(52.5, 52.5), false, 0)
		imageContext = UIGraphicsGetCurrentContext()
		CGContextAddEllipseInRect(imageContext, CGRectMake(0, 0, 52.5, 52.5))
		CGContextClip(imageContext)
		CGContextClearRect(imageContext, CGRectMake(0, 0, 52.5, 52.5))
		UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).setFill()
		CGContextFillRect(imageContext, CGRect(origin: CGPointZero, size: CGSizeMake(52.5, 52.5)))
		var transCircle = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		capture.setDefaultImage(solidCircle)
		capture.setTappedImage(transCircle)
		capture.performSetup(1.0)

		// Set up cancel button
		cancel.userInteractionEnabled = true
		cancel.image = AppData.util.scaleImage(UIImage(named: "Cancel.png")!, size: CGSizeMake(25, 25), scale:1.0)
		cancel.frame.size = CGSizeMake(25, 25)
		cancel.center = CGPointMake(self.view.frame.width - 30, AppData.data.heights.navViewHeight - 100)
		cancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cancelCapture"))

		// Finish setting up buttons
		flash.hidden = false
		flip.hidden = false
		capture.hidden = false
		cancel.hidden = true

		// Bring buttons to front
		self.view.bringSubviewToFront(flash)
		self.view.bringSubviewToFront(flip)
		self.view.bringSubviewToFront(capture)
		self.view.bringSubviewToFront(cancel)

		// Set up next button
		next.frame.size = CGSizeMake(self.view.frame.width, 50)
		next.frame.origin = CGPointMake(0, AppData.data.heights.navViewHeight - next.frame.size.height)
		next.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
		next.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		next.setTitle("Next 〉", forState: UIControlState.Normal)
		next.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18.0)

		// Set up capture session
		self.startSession(AVCaptureDevicePosition.Front)
		self.startOutput()
		self.startPreview()
		self.setupMask(CGRectMake(0, 30, self.view.frame.width, self.view.frame.width))
    }

	// Set up camera mask
	func setupMask(circleFrame: CGRect) {
		mask = MaskView()
		mask.backgroundColor = UIColor.clearColor()
		mask.frame = previewLayer.frame
		mask.setCircleBounds(circleFrame)
		mask.crop(UIColor(red: 0, green: 164/255.0, blue: 1.0, alpha: 0.5).CGColor)
		self.view.insertSubview(mask, atIndex: 1)
	}

	// Reset and start new capture session
	func startSession(position: AVCaptureDevicePosition) {
		// Start atomic configuration
		captureSession.beginConfiguration()

		// Set session preset
		captureSession.sessionPreset = AVCaptureSessionPresetPhoto

		// Find correct device for new camera position
		self.findCameraForPosition(position)

		// Reset inputs for capture session
		self.resetInputs()

		// Create output if needed
		if cameraOutput == nil {
			cameraOutput = AVCaptureStillImageOutput()
			captureSession.addOutput(cameraOutput)
		}

		// Set up video connection for taking photos
		self.findVideo()

		// Commit changes
		captureSession.commitConfiguration()

		// Start session
		captureSession.startRunning()
	}

	// Find camera for a given position
	func findCameraForPosition(position: AVCaptureDevicePosition) {
		for device in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as [AVCaptureDevice]! {
			if device.position == position {
				captureDevice = device
				captureDevice.lockForConfiguration(nil)
			}
		}
		println("Unable to find capture device for position \(position.rawValue)")
	}

	// Reset inputs
	func resetInputs() {
		// Remove existing input
		if (captureSession.inputs.count > 0) {
			captureSession.removeInput((captureSession.inputs as [AVCaptureInput])[0])
		}
		// Add new input
		cameraInput = AVCaptureDeviceInput(device: captureDevice, error: nil)
		captureSession.addInput(cameraInput)
	}

	// Set up video connection for capture session
	func findVideo() {
		videoConnection = nil
		if cameraOutput == nil {
			println("Cannot start video connection: no camera output found")
			return
		}
		for connection in self.cameraOutput.connections as [AVCaptureConnection] {
			if videoConnection != nil {
				break
			}
			for port in connection.inputPorts as [AVCaptureInputPort] {
				if port.mediaType == AVMediaTypeVideo {
					videoConnection = connection
					break
				}
			}
		}
	}

	// Add output if needed
	func startOutput() {
		if captureSession.outputs.count > 0 {
			captureSession.removeOutput((captureSession.outputs as [AVCaptureOutput])[0])
		}
		cameraOutput = AVCaptureStillImageOutput()
		captureSession.addOutput(cameraOutput)
	}

	// Set up preview layer
	func startPreview() {
		if captureSession == nil {
			println("Cannot set up capture preview: no capture session found")
			return
		}
		previewLayer = AVCaptureVideoPreviewLayer()
		previewLayer.removeFromSuperlayer()
		previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
		previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
		previewLayer.frame.size = CGSizeMake(self.view.frame.width, self.view.frame.height - 64 - next.frame.height)
		previewLayer.frame.origin = CGPointZero
		self.view.layer.insertSublayer(previewLayer, atIndex: 0)
	}

	// Switch flash
	func switchFlash() {
		if captureDevice?.flashAvailable == true {
			var currMode = captureDevice?.flashMode as AVCaptureFlashMode?
			if (currMode == .Auto) {
				println("Flash On")
				captureDevice?.flashMode = .On
			} else if currMode == .On {
				captureDevice?.flashMode = .Off
				println("Flash Off")
			} else {
				captureDevice?.flashMode = .Auto
				println("Flash Auto")
			}
		} else {
			println("Capture device's flash is unavailable")
		}
	}

	// Flip the camera
	func flipCamera() {
		var nextPosition = AVCaptureDevicePosition.Front
		if (currentPosition == AVCaptureDevicePosition.Front) {
			nextPosition = AVCaptureDevicePosition.Back
		}
		self.startSession(nextPosition)
	}

	func takePhoto() {
		if (takingPhoto == true) {
			return
		} else {
			takingPhoto = true
		}

		self.cameraOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(imageSampleBuffer:CMSampleBuffer!, error: NSError!) in
			self.flashScreen()
			var imageData:NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
			self.captureSession.stopRunning()
			var unscaledImage = UIImage(data: imageData)!
			var scaledImageSize:CGSize
			if (self.previewLayer.frame.height / self.previewLayer.frame.width > 4/3) {
				scaledImageSize = CGSizeMake(3/4 * self.previewLayer.frame.height, self.previewLayer.frame.height)
			} else {
				scaledImageSize = CGSizeMake(self.previewLayer.frame.width, 4/3 * self.previewLayer.frame.width)
			}
			self.image = AppData.util.scaleImage(unscaledImage, size: scaledImageSize, scale:1.0)
			self.imagePreview = UIImageView()
			self.imagePreview.image = self.image
			self.imagePreview.sizeToFit()
			self.imagePreview.center = CGPointMake(self.previewLayer.frame.width / 2, self.previewLayer.frame.height / 2)
			self.view.insertSubview(self.imagePreview, belowSubview: self.mask)

			if self.image != nil {
				// self.mask.crop(UIColor.blackColor().CGColor)
				self.capture.toggleColors()
				self.flash.hidden = true
				self.flip.hidden = true
				self.cancel.hidden = false
			}
		})
	}

	func cancelCapture() {
		// Reset view
		self.image = nil
		self.imagePreview.removeFromSuperview()
		self.captureSession.startRunning()
		self.capture.toggleColors()
		self.flash.hidden = false
		self.flip.hidden = false
		self.cancel.hidden = true
		self.takingPhoto = false
	}

	func flashScreen() {
		if (whiteScreen == nil) {
			whiteScreen = UIView(frame: UIScreen.mainScreen().bounds)
			whiteScreen.layer.opacity = 0
			whiteScreen.layer.backgroundColor = UIColor.whiteColor().CGColor
			self.view.addSubview(whiteScreen)
		}

		var opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
		var animationValues = [0.8, 0.0]
		var animationTimes = [0.3, 1.0]
		var timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		var animationTimingFunctions = [timingFunction, timingFunction]
		opacityAnimation.values = animationValues
		opacityAnimation.keyTimes = animationTimes
		opacityAnimation.timingFunctions = animationTimingFunctions
		opacityAnimation.fillMode = kCAFillModeForwards
		opacityAnimation.removedOnCompletion = true
		opacityAnimation.duration = 0.4

		whiteScreen.layer.addAnimation(opacityAnimation, forKey: "animation")
	}

	override func viewWillDisappear(animated: Bool) {
		var count = self.navigationController?.viewControllers.count
		if (self.navigationController?.viewControllers[count! - 1] is BondsBarController) {
			var lastVC:BondsBarController = self.navigationController?.viewControllers[count! - 1] as BondsBarController
			self.navigationController?.setViewControllers([lastVC], animated: true)
		}
	}
}
