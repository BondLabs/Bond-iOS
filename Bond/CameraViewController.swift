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

    override func viewDidLoad() {
        super.viewDidLoad()

		// Set up view controller properties
		self.navigationController?.title = "Smile!"
		self.view.backgroundColor = AppData.util.UIColorFromRGB(0x5A5A5A)

		// Set up flash button
		flash.image = AppData.util.scaleImage(UIImage(named: "Flash On.png")!, size: CGSizeMake(12.5, 25), inset: 0.0)
		flash.frame.size = CGSizeMake(12.5, 25)
		flash.frame.origin = CGPointMake(20, 40)

		//Set up capture button
		capture.frame.size = CGSizeMake(62.5, 62.5)
		var barHeight = self.navigationController?.navigationBar.frame.height
		var viewHeight:CGFloat = self.view.frame.height - barHeight! - 20
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
		cancel.center = CGPointMake(self.view.frame.width - 50, viewHeight - 100)

		// Set up next button
		next.frame.size = CGSizeMake(self.view.frame.width, 50)
		next.frame.origin = CGPointMake(0, viewHeight - 50)
		next.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
		next.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		next.setTitle("Next 〉", forState: UIControlState.Normal)
		next.titleLabel?.font = UIFont(name: "Helvetica-Neue", size: 18.0)

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
		previewLayer.frame.size = CGSizeMake(self.view.frame.width, self.view.frame.width * 4 / 3)
		previewLayer.frame.origin = CGPointMake(0, 19)
		captureSession.startRunning()

		// Set up mask
		var mask:MaskView = MaskView()
		mask.backgroundColor = UIColor.clearColor()
		mask.frame = previewLayer.frame
		mask.cropCircle(CGRectMake(0, 25, self.view.frame.width, self.view.frame.width))
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
