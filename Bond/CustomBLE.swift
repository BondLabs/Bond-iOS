//
//  CustomBLE.swift
//  Bond
//
//  Created by Bond on 2/2/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import Foundation
import CoreBluetooth

class CustomBLE: NSObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate {
	var advertisingData: NSMutableDictionary!
	var peripheralManager: CBPeripheralManager!
	var centralManager: CBCentralManager!
	var discovered: CBPeripheral!
	var scanOptions: NSDictionary!
	var services: NSArray!
	var uuid:CBUUID!
	var timer: NSTimer!
	var beaconList: [String]!

	class var sharedInstance: CustomBLE {
		struct Static {
			static var instance: CustomBLE? = nil
			static var token: dispatch_once_t = 0
		}

		dispatch_once(&Static.token) {
			Static.instance = CustomBLE()
		}

		return Static.instance!
	}

	func setup() {
		self.beaconList = []
		self.uuid = CBUUID(NSUUID: NSUUID(UUIDString: "\(UserAccountController.sharedInstance.currentUser.userID)"))
		self.advertisingData = [CBAdvertisementDataLocalNameKey:"bond-peripheral",
			CBAdvertisementDataServiceUUIDsKey: [self.uuid]]
		self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
		self.activateTimer()
	}

	func activateTimer() {
		self.timer = NSTimer(timeInterval: 60.0, target: self, selector: "getListOfBeacons", userInfo: nil, repeats: true)
		UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({})
		var loop = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: "getListOfBeacons", userInfo: nil, repeats: true)
		NSRunLoop.currentRunLoop().addTimer(loop, forMode: NSRunLoopCommonModes)
	}

	func disableTimer() {
		self.timer = nil
	}

	func scan() {
		self.scanOptions = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
		self.services = [self.uuid]
		self.centralManager = CBCentralManager(delegate: self, queue: nil)
		self.getListOfBeacons()
	}

	func stopScanning() {
		self.centralManager.stopScan()
	}

	func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [NSObject : AnyObject], RSSI: NSNumber) {
		println("FOUND PERIPHERAL")
		println(peripheral)
		self.discovered = peripheral
		println("Attempting to connect to peripheral")
		self.centralManager.connectPeripheral(peripheral, options: nil)
		println("Attempted to connect to peripheral")
		self.centralManager.cancelPeripheralConnection(peripheral)
		self.beaconList.append(peripheral.identifier.UUIDString);
	}

	func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
		println("Able to connect to peripheral")
	}

	func getListOfBeacons() {
		self.findPeripherals()
		println("Finding beacons")
		var dispatchTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC)))
		dispatch_after(dispatchTime, dispatch_get_main_queue(), {
			self.stopScanning()
			println("Stopped scanning")
			self.filterDetected()
			println(self.beaconList)

			if UserAccountController.sharedInstance.currentUser != nil {

			bondLog(UserAccountController.sharedInstance.currentUser.authKey)
				bondLog(UserAccountController.sharedInstance.currentUser.userID)

				UserAccountController.sharedInstance.sendCustomRequestWithBlocks(NSString(format: "id=%d&list=%@", UserAccountController.sharedInstance.currentUser.userID, self.beaconListToString()), header: [UserAccountController.sharedInstance.currentUser.authKey : "X-AUTH-KEY"], URL: "http://api.bond.sh/api/list", HTTProtocol: "POST",
					success: { (data, response) -> Void in
						var writeError: NSError?
						var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
						if (dataDictionary?.objectForKey("error") == nil) {
							bondLog(dataDictionary!)
						}
					},
					failure: { (data, error) -> Void in
						AppData.bondLog("connection failed with error: \(error.description)")
						RemoteAPIController.sharedInstance.isNetworkBusy = false
				})
			}
		})
	}

	func beaconListToString() -> String {
		self.filterDetected()
		if self.beaconList.count == 0 {
			return ""
		}
		var list:String = self.beaconList[0] as String
		for var i = 1; i < self.beaconList.count; i++ {
			list += "," + self.beaconList[i]
		}
		println(list)
		return list
	}

	func filterDetected() {
		var filter = Dictionary<String,Int>()
		var len = self.beaconList.count
		for var index = 0; index < len  ;++index {
			var value = beaconList[index]
			if filter[value] != nil {
				self.beaconList.removeAtIndex(index--)
				len--
			} else{
				filter[value] = 1
			}
		}
	}

	func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError) {
		println("Failed to connect to peripheral")
	}

	func centralManagerDidUpdateState(central: CBCentralManager) {
		if (ViewManager.sharedInstance.currentViewController is LocationPermissionViewController) {
			(ViewManager.sharedInstance.currentViewController as LocationPermissionViewController).presentNextController()
		}
		
		if central.state != CBCentralManagerState.PoweredOn {
			println("Central manager scanner off")
			central.stopScan()
			self.disableTimer()
		} else {
			println("Central manager scanner on")
			self.centralManager.scanForPeripheralsWithServices(services, options: nil)
		}
	}

	func findPeripherals() {
		println("Finding peripherals")
		self.centralManager.scanForPeripheralsWithServices(services, options: nil)
	}

	func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
		if peripheral.state != CBPeripheralManagerState.PoweredOn {
			println("Peripheral manager not on")
			peripheral.stopAdvertising()
		} else {
			println("Peripheral on")
			self.peripheralManager.startAdvertising(self.advertisingData)
		}
	}

	func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError) {
		println("Disconnected from peripheral \(peripheral)")
	}

	func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager!) {
		
	}
}