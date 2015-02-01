//
//  LocationData.swift
//  Bond
//
//  Created by Bond on 1/27/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import CoreBluetooth
import CoreLocation
import UIKit

class Location: NSObject, CLLocationManagerDelegate, CBPeripheralManagerDelegate {
    
    var count = 0
    var broadcastPower:Int!
    var uuid:NSUUID!
    var power:NSNumber!
    var region:CLBeaconRegion!
    var locationManager:CLLocationManager!
    var peripheralManager:CBPeripheralManager!
    
    class var sharedInstance: Location {
        struct Static {
            static var instance: Location? = nil
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Location()
        }
        
        return Static.instance!
    }
    
    func setup() {
        self.broadcastPower = -59
        self.locationManager = CLLocationManager()
        self.uuid = NSUUID(UUIDString: "5DBAC5C8-0B19-4FC7-B98E-E9681EC24DC9")
        self.region = CLBeaconRegion(proximityUUID: self.uuid, major: 0, minor: 5, identifier: "sh.bond")
        region.notifyEntryStateOnDisplay = true
        region.notifyOnEntry = true
        region.notifyOnExit = true
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func broadcast() {
        self.power = self.broadcastPower
        self.peripheralManager.delegate = self
    }
    
    func listen() {
        self.locationManager.delegate = self
        self.locationManager.startMonitoringForRegion(self.region)
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager(self.locationManager, didStartMonitoringForRegion: self.region)
        if (self.locationManager.respondsToSelector("requestAlwaysAuthorization")) {
            self.locationManager.requestAlwaysAuthorization()
        }
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound | UIUserNotificationType.Badge, categories: nil))
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if (peripheral.state == CBPeripheralManagerState.PoweredOn) {
            println("Beginning advertising")
            self.peripheralManager.startAdvertising(self.region.peripheralDataWithMeasuredPower(nil))
        } else {
            println("Stopping advertising")
            self.peripheralManager.stopAdvertising()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        self.locationManager.startRangingBeaconsInRegion(self.region)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("Entered: \(region)")
        self.locationManager.startRangingBeaconsInRegion(self.region)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("Exited: \(region)")
        self.locationManager.stopRangingBeaconsInRegion(self.region)
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        // Process beacons here (if necessary) to figure out which bonds should be retained
        println(beacons.count)
        /*if (beacons.count == 0) {
            return
        }
        var beacon = beacons.last as CLBeacon
        println("Ranging beacons \(count)")
        println(beacon.proximityUUID.UUIDString)
        count += 1*/
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        if (state == CLRegionState.Inside) {
            self.locationManager.startRangingBeaconsInRegion(self.region)
            // self.sendLocalNotificationForRegionConfirmedWithText("Region Inside")
            println("Region Inside")
        } else {
            self.locationManager.stopRangingBeaconsInRegion(self.region)
            // self.sendLocalNotificationForRegionConfirmedWithText("Region Outside")
            println("Region Outside")
        }
    }
    
    // Utility for local notification
    func sendLocalNotificationForRegionConfirmedWithText(text: String) {
        var localNotif = UILocalNotification()
        localNotif.timeZone = NSTimeZone.defaultTimeZone()
        localNotif.alertBody = text
        localNotif.alertAction = "View Details"
        localNotif.applicationIconBadgeNumber = 1
        var info = NSDictionary(object: text, forKey: "KEY")
        localNotif.userInfo = info
        UIApplication.sharedApplication().presentLocalNotificationNow(localNotif)
    }
}