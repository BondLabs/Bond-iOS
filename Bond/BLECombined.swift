//
//  BLECombined.swift
//  Bond
//
//  Created by Bond on 2/2/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

class BLECombined: NSObject, CLLocationManagerDelegate, CBPeripheralManagerDelegate {
    var locationManager: CLLocationManager!
    var locationScanner: CLLocationManager!
    var beaconRegion: CLBeaconRegion!
    var scannerRegion: CLBeaconRegion!
    var beaconPeripheralData: NSMutableDictionary!
    var peripheralManager: CBPeripheralManager!
    
    class var sharedInstance: BLECombined {
        struct Static {
            static var instance: BLECombined? = nil
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = BLECombined()
        }
        
        return Static.instance!
    }
    
    func setup() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationScanner = CLLocationManager()
        locationScanner.delegate = self
        
        self.initBeacon()
        self.initRegion()
        self.locationManager(self.locationManager, didStartMonitoringForRegion: self.scannerRegion)
    }
    
    func initBeacon() {
        println("Starting beacon")
        var uuid = NSUUID(UUIDString: "5DBAC5C8-0B19-4FC7-B98E-E9681EC24DC9")
        self.beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 1, minor: 1, identifier: "sh.bond")
        self.transmitBeacon(self)
    }
    
    func transmitBeacon(sender: BLECombined) {
        self.beaconPeripheralData = self.beaconRegion.peripheralDataWithMeasuredPower(nil)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if peripheral.state == CBPeripheralManagerState.PoweredOn {
            println("Powered on")
            self.peripheralManager.startAdvertising(self.beaconPeripheralData)
        } else if peripheral.state == CBPeripheralManagerState.PoweredOff {
            println("Powered off")
            self.peripheralManager.stopAdvertising()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        self.locationManager.startRangingBeaconsInRegion(self.beaconRegion)
    }
    
    func initRegion() {
        var uuid = NSUUID(UUIDString: "5DBAC5C8-0B19-4FC7-B98E-E9681EC24DC9")
        self.scannerRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "sh.bond")
        self.scannerRegion.notifyEntryStateOnDisplay = true
        self.scannerRegion.notifyOnEntry = true
        self.scannerRegion.notifyOnExit = true
        self.locationScanner.startMonitoringForRegion(self.scannerRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("Entered region")
        self.locationScanner.startRangingBeaconsInRegion(self.scannerRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("Exited region")
        self.locationScanner.stopRangingBeaconsInRegion(self.scannerRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        var beacon = CLBeacon()
        println("# of beacons: \(beacons.count)")
        if (beacons != nil && beacons.count > 0) {
            println(beacons)
        }
    }
}