//
//  CameraViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 1/9/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

	@IBOutlet var flash: UIImageView!
	@IBOutlet var flip: UIImageView!
	@IBOutlet var capture: CircleImageView!
	@IBOutlet var cancel: UIImageView!
	@IBOutlet var next: UIButton!
	@IBOutlet var chooser: UIImageView!

	let captureSession:AVCaptureSession! = AVCaptureSession()
	var captureDevice:AVCaptureDevice!
	var cameraInput:AVCaptureDeviceInput!
	var cameraOutput:AVCaptureStillImageOutput!
	var videoConnection:AVCaptureConnection!
	var image:UIImage!
	var imagePreview:UIImageView!
	var previewLayer:AVCaptureVideoPreviewLayer!
	var mask:MaskView!
	var takingPhoto:Bool! = false
	var canceling:Bool! = false
	var whiteScreen:UIView!
	var picker:UIImagePickerController!

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

		// Set up chooser button
		chooser.userInteractionEnabled = true
		chooser.frame.size = CGSizeMake(50, 50)
		chooser.center = CGPointMake(45, AppData.data.heights.navViewHeight - 100)
		chooser.layer.cornerRadius = 5
		chooser.clipsToBounds = true
		chooser.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "showPicker"))
		updatePicker()

		// Finish setting up buttons
		flash.hidden = false
		flip.hidden = false
		capture.hidden = false
		cancel.hidden = true
		chooser.hidden = false

		// Bring buttons to front
		self.view.bringSubviewToFront(flash)
		self.view.bringSubviewToFront(flip)
		self.view.bringSubviewToFront(capture)
		self.view.bringSubviewToFront(cancel)
		self.view.bringSubviewToFront(chooser)

		// Set up next button
		next.frame.size = CGSizeMake(self.view.frame.width, 50)
		next.frame.origin = CGPointMake(0, AppData.data.heights.navViewHeight - next.frame.size.height)
		next.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
		next.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		next.setTitle("Next 〉", forState: UIControlState.Normal)
		next.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18.0)

		// Set up capture session
		startOutput()
		startSession(AVCaptureDevicePosition.Front)
		startPreview()
		setupMask(CGRectMake(0, 30, self.view.frame.width, self.view.frame.width))
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

		// Start session
		captureSession.startRunning()
	}

	// Find camera for a given position
	func findCameraForPosition(position: AVCaptureDevicePosition) {
		for device in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as [AVCaptureDevice]! {
			if device.position == position {
				captureDevice = device
				captureDevice.lockForConfiguration(nil)
				return
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
			for port in connection.inputPorts as [AVCaptureInputPort] {
				if port.mediaType == AVMediaTypeVideo {
					videoConnection = connection
					break
				}
			}
			if videoConnection != nil {
				break
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
				captureDevice?.flashMode = .On
			} else if currMode == .On {
				captureDevice?.flashMode = .Off
			} else {
				captureDevice?.flashMode = .Auto
			}
		} else {
			println("Capture device's flash is unavailable")
		}
	}

	// Flip the camera
	func flipCamera() {
		var nextPosition = AVCaptureDevicePosition.Front
		if (captureDevice.position == AVCaptureDevicePosition.Front) {
			nextPosition = AVCaptureDevicePosition.Back
		}
		self.startSession(nextPosition)
	}

	// Self explanatory...
	func takePhoto() {
		// If currently taking a photo, stop
		// Otherwise, mark: currently taking a photo
		if (takingPhoto == true) {
			return
		} else {
			capture.toggleColors()
		}

		if videoConnection == nil {
			println("Unable to find a video connection")
			return
		}

		// Capture photo
		cameraOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
			(imageSampleBuffer:CMSampleBuffer!, error: NSError!) in
				self.previewLayer.connection.enabled = false
				self.flashScreen()
				self.image = UIImage(data: AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer))!
				if self.captureDevice.position == AVCaptureDevicePosition.Front {
					self.image = UIImage(CGImage: self.image.CGImage, scale: 1.0, orientation: UIImageOrientation.LeftMirrored)
				}

				self.scaleImage()
				self.setupImagePreview()
				self.stopCapture()
			})
	}

	// Scale stored image to fill previewLayer
	func scaleImage() {
		// Make new image size
		var scaled:CGSize
		var layerWidth = self.previewLayer.frame.width
		var layerHeight = self.previewLayer.frame.height
		var imageRatio = self.image.size.height / self.image.size.width
		if (layerHeight / layerWidth >= imageRatio) {
			scaled = CGSizeMake(layerHeight / imageRatio, layerHeight)
		} else {
			scaled = CGSizeMake(layerWidth, layerWidth * imageRatio)
		}
		image = AppData.util.scaleImage(image, size: scaled, scale: 1.0)
	}

	// Set up image preview
	func setupImagePreview() {
		if imagePreview != nil {
			imagePreview.removeFromSuperview()
			imagePreview = nil
		}
		imagePreview = UIImageView()
		imagePreview.image = self.image
		imagePreview.sizeToFit()
		imagePreview.center = CGPointMake(self.previewLayer.frame.width / 2, self.previewLayer.frame.height / 2)
		self.view.insertSubview(self.imagePreview, belowSubview: self.mask)
	}

	// Self explanatory
	func stopCapture() {
		captureSession.stopRunning()
		flash.hidden = true
		flip.hidden = true
		cancel.hidden = false
	}

	// Pretty self explanatory...
	func cancelCapture() {
		if canceling == true {
			return
		}
		// Reset view
		image = nil
		imagePreview.removeFromSuperview()
		imagePreview = nil
		captureSession.startRunning()
		previewLayer.connection.enabled = true
		capture.toggleColors()
		flash.hidden = false
		flip.hidden = false
		cancel.hidden = true
		takingPhoto = false
		canceling = false
		takingPhoto = false
	}

	// Camera flash screen animation
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

	// Set up image picker preview
	func updatePicker() {
		var fetchOptions = PHFetchOptions()
		fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
		var fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
		if (fetchResult.lastObject != nil) {
			var lastAsset = fetchResult.lastObject as PHAsset
			PHImageManager.defaultManager().requestImageForAsset(lastAsset, targetSize: CGSizeMake(50, 50), contentMode: PHImageContentMode.AspectFill, options: PHImageRequestOptions(), resultHandler: { (result, info) -> Void in
				self.chooser.image = result
			})
		}
	}

	// Show image picker screen
	func showPicker() {
		image = nil
		takingPhoto = true
		picker = UIImagePickerController()
		picker.delegate = self
		picker.modalPresentationStyle = UIModalPresentationStyle.Popover
		picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
		self.presentViewController(picker, animated: true, completion: nil)
	}

	// Canceled image selection
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		// Handle cancel
		picker.dismissViewControllerAnimated(true, completion: nil)
	}

	@IBAction func hitNextButton(sender: UIButton) {
	}
	// Selected an image
	func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
		// Handle new image
		self.image = image
		self.scaleImage()
		self.setupImagePreview()
		self.stopCapture()
		picker.dismissViewControllerAnimated(true, completion: nil)
	}

	// Check for segue and override navigation stack
	override func viewWillDisappear(animated: Bool) {
		var count = self.navigationController?.viewControllers.count
		if (self.navigationController?.viewControllers[count! - 1] is BondsBarController) {
			var lastVC:BondsBarController = self.navigationController?.viewControllers[count! - 1] as BondsBarController
			self.navigationController?.setViewControllers([lastVC], animated: true)
		}
	}
}
