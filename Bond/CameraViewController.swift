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

	@IBOutlet var next: UIButton!
	let captureSession = AVCaptureSession()
	var captureDevice:AVCaptureDevice?

    override func viewDidLoad() {
        super.viewDidLoad()

		// Set up view controller properties
		self.navigationController?.title = "Smile!"
		self.view.backgroundColor = AppData.util.UIColorFromRGB(0x5A5A5A)

		// Set up next button
		next.frame.size = CGSizeMake(self.view.frame.width, 50)
		next.frame.origin = CGPointMake(0, self.view.frame.height - 50)
		next.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
		next.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		next.setTitle("Next", forState: UIControlState.Normal)

		// Set up capture session
		captureSession.sessionPreset = AVCaptureSessionPresetPhoto

		let devices = AVCaptureDevice.devices()
		for device in devices {
			if device.hasMediaType(AVMediaTypeVideo) && device.position == AVCaptureDevicePosition.Back {
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
		previewLayer?.frame = self.view.layer.frame
		captureSession.startRunning()
	}

	override func viewWillDisappear(animated: Bool) {
		var count = self.navigationController?.viewControllers.count
		if (self.navigationController?.viewControllers[count! - 1] is BondsBarController) {
			var lastVC:BondsBarController = self.navigationController?.viewControllers[count! - 1] as BondsBarController
			self.navigationController?.setViewControllers([lastVC], animated: true)
		}
	}
}
