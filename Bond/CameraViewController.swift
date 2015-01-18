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
	@IBOutlet var capture: UIView!
	@IBOutlet var cancel: UIImageView!
	@IBOutlet var next: UIButton!
	let captureSession:AVCaptureSession! = AVCaptureSession()
	var captureDevice:AVCaptureDevice?
	var cameraInput:AVCaptureDeviceInput!
	var photoOutput:AVCaptureStillImageOutput!
	var capturedPhoto:UIImage!
	var image:UIImage!
	var viewHeight:CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()

		// Set up view controller properties
		self.navigationController?.title = "Smile!"
		self.view.backgroundColor = AppData.util.UIColorFromRGB(0x4A4A4A)

		// Set up flash button
		flash.image = AppData.util.scaleImage(UIImage(named: "Flash On.png")!, size: CGSizeMake(12.5, 25), inset: 0.0)
		flash.frame.size = CGSizeMake(12.5, 25)
		flash.center = CGPointMake(30, 40)

		// Set up flip button
		flip.image = AppData.util.scaleImage(UIImage(named: "Flip.png")!, size: CGSizeMake(18.5, 25), inset: 0.0)
		flip.frame.size = CGSizeMake(18.5, 25)
		flip.center = CGPointMake(self.view.frame.width - 30, 40)

		//Set up capture button
		capture.frame.size = CGSizeMake(62.5, 62.5)
		var navBarHeight = self.navigationController?.navigationBar.frame.height
		var statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
		viewHeight = self.view.frame.height - navBarHeight! - statusBarSize.height
		capture.center = CGPointMake(self.view.frame.width / 2, viewHeight - 100)
		var captureImage = UIImageView(image: AppData.util.scaleImage(UIImage(named: "Camera.png")!, size: CGSizeMake(31.2, 28.2), inset: 0))
		captureImage.sizeToFit()
		captureImage.center = CGPointMake(capture.frame.width / 2, capture.frame.height / 2)
		capture.addSubview(captureImage)
		capture.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
		capture.layer.cornerRadius = capture.frame.width / 2
		capture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "takePhoto:"))

		// Set up cancel button
		cancel.image = AppData.util.scaleImage(UIImage(named: "Cancel.png")!, size: CGSizeMake(25, 25), inset: 0.0)
		cancel.frame.size = CGSizeMake(25, 25)
		cancel.center = CGPointMake(self.view.frame.width - 30, viewHeight - 100)

		// Set up next button
		next.frame.size = CGSizeMake(self.view.frame.width, 50)
		next.frame.origin = CGPointMake(0, AppData.data.heights.navViewHeight - next.frame.size.height)
		next.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
		next.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		next.setTitle("Next 〉", forState: UIControlState.Normal)
		next.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18.0)

		// Set up capture session
		captureSession.sessionPreset = AVCaptureSessionPresetPhoto

		var devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as [AVCaptureDevice]!
		for device in devices {
			if device.position == AVCaptureDevicePosition.Front {
				self.captureDevice = device
			}
		}
		if captureDevice != nil {
			beginSession()
		}
    }

	func beginSession() {
		// Start the capture session
		var err : NSError? = nil
		self.cameraInput = AVCaptureDeviceInput(device: captureDevice, error: &err)
		captureSession.addInput(cameraInput)
		if err != nil {
			println("error: \(err?.localizedDescription)")
		}

		// Add the preview image to the view
		var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		self.view.layer.insertSublayer(previewLayer, atIndex: 0)
		previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
		previewLayer.frame.size = CGSizeMake(self.view.frame.width, viewHeight)
		previewLayer.frame.origin = CGPointZero
		captureSession.startRunning()

		// Add camera output to session
		self.photoOutput = AVCaptureStillImageOutput()
		self.photoOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
		self.captureSession.addOutput(self.photoOutput)

		// Set up mask
		var mask:MaskView = MaskView()
		mask.backgroundColor = UIColor.clearColor()
		mask.frame = previewLayer.frame
		mask.cropCircle(CGRectMake(0, 30, self.view.frame.width, self.view.frame.width))
		self.view.insertSubview(mask, atIndex: 1)
	}

	func takePhoto(sender: UIButton) {
		var videoConnection:AVCaptureConnection!
		for connection in self.photoOutput.connections as [AVCaptureConnection] {
			var inputPorts = connection.inputPorts as [AVCaptureInputPort]
			for port in inputPorts {
				if port.mediaType == AVMediaTypeVideo {
					videoConnection = connection
					break
				}
			}
			if let check = videoConnection {
				break
			}
		}

		self.photoOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(imageSampleBuffer:CMSampleBuffer!, error: NSError!) in
			var imageData:NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
			self.image = UIImage(data: imageData)

			UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil)
		})
	}

	override func viewWillDisappear(animated: Bool) {
		var count = self.navigationController?.viewControllers.count
		if (self.navigationController?.viewControllers[count! - 1] is BondsBarController) {
			var lastVC:BondsBarController = self.navigationController?.viewControllers[count! - 1] as BondsBarController
			self.navigationController?.setViewControllers([lastVC], animated: true)
		}
	}
}
