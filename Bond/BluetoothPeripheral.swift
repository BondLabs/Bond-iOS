//
//  BluetoothPeripheral.swift
//  Bond
//
//  Created by Bond on 2/2/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothPeripheral: NSObject, CBPeripheralManagerDelegate {
    var peripheralManager: CBPeripheralManager!
    var trans_characteristic: CBMutableCharacteristic!
    var data: NSData!
    var sendDataIndex: Int!
    var uuid: NSUUID!
    
    required override init() {
    }
    
    class var sharedInstance: BluetoothPeripheral {
        struct Static {
            static var instance: BluetoothPeripheral? = nil
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = BluetoothPeripheral()
        }
        
        return Static.instance!
    }
    
    func setup() {
        self.uuid = NSUUID(UUIDString: "5DBAC5C8-0B19-4FC7-B98E-E9681EC24DC9")
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        self.peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey : CBUUID(NSUUID: self.uuid)])
    }
    
    func sendData() {
        var sendingEOM:Bool = false
        if sendingEOM == true {
            var didSend:Bool = peripheralManager.updateValue("EOM".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), forCharacteristic: self.trans_characteristic, onSubscribedCentrals: nil)
            if (didSend) {
                sendingEOM = false
            }
            return
        }
        
        if self.sendDataIndex >= self.data.length {
            return
        }
        
        var didSend = true
        
        while (didSend) {
            var amountToSend:Int = self.data.length - self.sendDataIndex
            if amountToSend > 20 {
                amountToSend = 20
            }
            var chunk:NSData = NSData(bytes: self.data.bytes + self.sendDataIndex, length: amountToSend)
            didSend = self.peripheralManager.updateValue(chunk, forCharacteristic: self.trans_characteristic, onSubscribedCentrals: nil)
            
            if (!didSend) {
                return
            }
            
            var stringFromData = NSString(data: chunk, encoding: NSUTF8StringEncoding)
            println("Sent: \(stringFromData)")
            
            self.sendDataIndex = self.sendDataIndex + Int(amountToSend)
            
            if (self.sendDataIndex > self.data.length) {
                sendingEOM = true
                var eomSent:Bool = self.peripheralManager.updateValue("EOM".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), forCharacteristic: self.trans_characteristic, onSubscribedCentrals: nil)
                if eomSent {
                    sendingEOM = false
                    println("Sent: EOM")
                }
                
                return
            }
        }
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if peripheral.state != CBPeripheralManagerState.PoweredOn {
            return
        }
        
        var service = CBMutableService(type: CBUUID(NSUUID: self.uuid), primary: true)
        service.characteristics = [self.trans_characteristic]
        self.peripheralManager.addService(service)
    }
    
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager!) {
        self.sendData()
    }
    
    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didSubscribeToCharacteristic characteristic: CBCharacteristic!) {
        self.data = ("TEST").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        self.sendDataIndex = 0
        self.sendData()
    }
    
    
}