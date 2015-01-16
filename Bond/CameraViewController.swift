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
	let captureSession = AVCaptureSession()
	var captureDevice:AVCaptureDevice?
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

		// Set up cancel button
		cancel.image = AppData.util.scaleImage(UIImage(named: "Cancel.png")!, size: CGSizeMake(25, 25), inset: 0.0)
		cancel.frame.size = CGSizeMake(25, 25)
		cancel.center = CGPointMake(self.view.frame.width - 30, viewHeight - 100)

		// Set up next button
		next.frame.size = CGSizeMake(self.view.frame.width, 50)
		next.frame.origin = CGPointMake(0, AppData.data.navViewHeight - next.frame.size.height)
		next.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
		next.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		next.setTitle("Next 〉", forState: UIControlState.Normal)
		next.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18.0)

		// Set up capture session
		captureSession.sessionPreset = AVCaptureSessionPresetPhoto

		let devices = AVCaptureDevice.devices()
		for device in devices {
			if device.hasMediaType(AVMediaTypeVideo) && device.position == AVCaptureDevicePosition.Front {
				captureDevice = device as? AVCaptureDevice
			}
		}

		if captureDevice != nil {
			beginSession()
		}
    }

	func beginSession() {
		// Start the capture session
		var err : NSError? = nil
		captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
		if err != nil {
			println("error: \(err?.localizedDescription)")
		}

		// Add the preview image to the view
		var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		self.view.layer.insertSublayer(previewLayer, atIndex: 0)
		previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
		previewLayer.frame.size = CGSizeMake(self.view.frame.width, viewHeight - self.next.frame.height)
		previewLayer.frame.origin = CGPointZero
		captureSession.startRunning()

		// Set up mask
		var mask:MaskView = MaskView()
		mask.backgroundColor = UIColor.clearColor()
		mask.frame = previewLayer.frame
		mask.cropCircle(CGRectMake(0, 30, self.view.frame.width, self.view.frame.width))
		self.view.insertSubview(mask, atIndex: 1)
	}

	override func viewWillDisappear(animated: Bool) {
		var count = self.navigationController?.viewControllers.count
		if (self.navigationController?.viewControllers[count! - 1] is BondsBarController) {
			var lastVC:BondsBarController = self.navigationController?.viewControllers[count! - 1] as BondsBarController
			self.navigationController?.setViewControllers([lastVC], animated: true)
		}
	}
}
