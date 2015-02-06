//
//  Bluetooth.swift
//  Bond
//
//  Created by Bond on 2/2/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothCentral: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    
    var uuid:NSUUID!
    var advertisingData: NSDictionary!
    var self_peripheral: CBPeripheral!
    var disc_peripheral: CBPeripheral!
    var scanOptions: NSDictionary!
    var services: NSArray!
    var centralManager: CBCentralManager!
    var data: NSMutableData!
    
    class var sharedInstance: BluetoothCentral {
        struct Static {
            static var instance: BluetoothCentral? = nil
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = BluetoothCentral()
        }
        
        return Static.instance!
    }
    
    func setup() {
        self.uuid = NSUUID(UUIDString: "5DBAC5C8-0B19-4FC7-B98E-E9681EC24DC9")
        self.advertisingData = [CBAdvertisementDataLocalNameKey:"bond-peripheral",
        CBAdvertisementDataServiceUUIDsKey:CBUUID(NSUUID: self.uuid)]
        self.self_peripheral = CBPeripheral()
        self.self_peripheral.delegate = self
        self.scanOptions = [CBCentralManagerScanOptionAllowDuplicatesKey:true]
        self.services = [CBUUID(NSUUID: self.uuid)]
    }
    
    func stop() {
        self.centralManager.stopScan()
    }
    
    func cleanup() {
        if self.disc_peripheral.services != nil {
            for service in self.disc_peripheral.services {
                if (service as CBService).characteristics != nil {
                    for char in (service as CBService).characteristics {
                        if (char as CBCharacteristic).UUID == CBUUID(NSUUID: self.uuid) {
                            if (char as CBCharacteristic).isNotifying == true {
                                self.disc_peripheral.setNotifyValue(false, forCharacteristic: char as CBCharacteristic)
                                return
                            }
                        }
                    }
                }
            }
        }
        
        self.centralManager.cancelPeripheralConnection(self.disc_peripheral)
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        println("Found peripheral \(peripheral)")
        self.disc_peripheral = peripheral
        self.centralManager.connectPeripheral(peripheral, options: nil)
    }
    
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Failed to connect to peripheral")
        self.cleanup()
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        println("Connected")
        self.centralManager.stopScan()
        println("Scanning stopped")
        self.data.length = 0
        
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(NSUUID: self.uuid)])
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        if (error != nil) {
            println(error)
            self.cleanup()
            return
        }
        
        for service in peripheral.services {
            peripheral.discoverCharacteristics([CBUUID(NSUUID: self.uuid)], forService: service as CBService)
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        if (error != nil) {
            println(error)
            self.cleanup()
            return
        }
        
        for char in service.characteristics {
            if (char as CBCharacteristic).UUID == CBUUID(NSUUID: self.uuid) {
                peripheral.setNotifyValue(true, forCharacteristic: char as CBCharacteristic)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if (error != nil) {
            println(error)
            self.cleanup()
            return
        }
        
        var stringFromData = NSString(data: characteristic.value, encoding: NSUTF8StringEncoding)
        
        if (stringFromData == "EOM") {
            println("Strings are equal to EOM")
            peripheral.setNotifyValue(false, forCharacteristic: characteristic)
            centralManager.cancelPeripheralConnection(peripheral)
        }
        
        self.data.appendData(characteristic.value)
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if characteristic.UUID != CBUUID(NSUUID: self.uuid) {
            return
        }
        
        if characteristic.isNotifying {
            println("Notification began on \(characteristic)")
        } else {
            println("Notification has stopped for \(characteristic)")
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        if (central.state != CBCentralManagerState.PoweredOn) {
            return
        } else {
            centralManager.scanForPeripheralsWithServices([CBUUID(NSUUID: self.uuid)], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
            println("Scanning started")
        }
    }
}