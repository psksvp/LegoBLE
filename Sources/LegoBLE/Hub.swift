//
//  File.swift
//
//
//  Created by psksvp on 24/8/2024.
//

import Foundation
import CoreBluetooth
import CommonSwift

public class Hub: NSObject, ObservableObject
{
  private let peripheral: CBPeripheral
  private var txChar: CBCharacteristic? = nil
  
  public var name: String {self.peripheral.name ?? ""}
  public var id: UUID {self.peripheral.identifier}
  
  @Published
  public private(set) var devices = [UInt8 : Device]()
  
  @Published
  public private(set) var connected = false
  
  public init(peripheral: CBPeripheral)
  {
    self.peripheral = peripheral
    super.init()
    self.peripheral.delegate = self
  }
  
  public func sent(bytes: [UInt8])
  {
    guard self.connected,
          let tx = self.txChar else
    {
      Log.error("txChar is nil or not connected")
      Log.warn("Message did not send.")
      return
    }
    self.peripheral.writeValue(Data(bytes), for: tx, type: .withResponse)
  }
  
  public func switchOff()
  {
    self.sent(bytes: [4, 00, MessageType.hubAction.rawValue,
                             HubAction.switchOffHub.rawValue])
  }
  
  func process(message: Message)
  {
    switch message
    {
      case .action(.hubWillDisconnect), .action(.hubWillSwitchOff):
        Log.info("\(message)")
        self.connected = false
      
      case .deviceAttached(port: let p, device: let d):
        Log.info("\(d) at port: \(p)")
        self.devices[p] = Device(hub: self, port: p, kind: d)
        
      case .deviceDetached(port: let p):
        self.devices.removeValue(forKey: p)
        Log.info("detatchIO at port: \(p)")
        
      case .portOutputFeedback(let feedbacks):
        for f in feedbacks
        {
          self.devices[f.port]?.received(message: .portOutputFeedback([f]))
        }
        
      case .portSingleValue(port: let p, values: _):
        self.devices[p]?.received(message: message)
        
        
      default:
        Log.info("\(message)")
        return
    }
  }
}





//////
/// CBPeripheralDelegate
//////
extension Hub: CBPeripheralDelegate
{
  public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
  {
    guard let services = peripheral.services else
    {
      Log.warn("device \(peripheral) has no services???")
      return
    }
    
    for service in services
    {
      print("Discovered service: \(service.description) - \(service.uuid)")
      peripheral.discoverCharacteristics(nil, for: service)
    }
  }
  
  public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
  {
    guard let characteristics = service.characteristics else
    {
      return
    }

    for characteristic in characteristics
    {
      if characteristic.uuid.isEqual(LegoCentralBLE.idCharTxRx)
      {
        self.txChar = characteristic
        peripheral.setNotifyValue(true, for: self.txChar!)
        peripheral.readValue(for: characteristic)
        Log.info("found hub tx -> \(characteristic.uuid)")
        self.connected = true
        return
      }
    }
  }
  
  public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
  {
    guard characteristic == self.txChar,
          let characteristicValue = characteristic.value else { return }
    
    let bytes = [UInt8](characteristicValue)
    if let m = Message.decode(bytes)
    {
      self.process(message: m)
    }
    else
    {
      Log.info("No decoder for Value Recieved: [\(bytes.count), \(bytes[0])] \(bytes.map({String(format: "%02X", $0)}))")
    }
  }
  
  public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?)
  {
    if let e = error
    {
      Log.error("Error sending: \(e)")
      return
    }

    Log.info("Message sent")
  }
  
  public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?)
  {
    if (error != nil)
    {
      Log.error("Error changing notification state:\(String(describing: error?.localizedDescription))")
    }
  }
  
  public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?)
  {
  }
}

