//
//  Device.swift
//  
//
//  Created by psksvp on 30/8/2024.
//

import Foundation
import CommonSwift

public class Device
{
  public enum Kind
  {
    case motor(MotorType)
    case sensor(SensorType)
    case light(LightType)
    case sound
    
    static func lookup(_ n: UInt16) -> Kind?
    {
      if let m = MotorType(rawValue: n)
      {
        return .motor(m)
      }
      
      if let s = SensorType(rawValue: n)
      {
        return .sensor(s)
      }
      
      if let l = LightType(rawValue: n)
      {
        return .light(l)
      }
      
      if n == DeviceID.sound.rawValue
      {
        return .sound
      }
      
      Log.warn("lookup fail for raw value: \(n)")
      
      return nil
    }
  }
  
  public let attachedHub: Hub
  public let port: UInt8
  public let kind: Kind
  public var sensorHandler: ((Device, SensorValue)->Void)? = nil
  
  public init(hub: Hub, port: UInt8, kind: Kind)
  {
    self.attachedHub = hub
    self.port = port
    self.kind = kind
    self.activateUpdate()
  }
  
  public func sent(bytes: [UInt8])
  {
    self.attachedHub.sent(bytes: [UInt8(bytes.count + 2), 0] + bytes)
  }
  
  public func received(message: Message)
  {
    print("\(self.kind): \(message)")
    switch message
    {
      case .portSingleValue(port: _, values: let v):
        if let sensorValue = self.decode(rawSensorData: v)
        {
          self.sensorHandler?(self, sensorValue)
          print(sensorValue)
        }
        
      default:
        Log.warn("device: \(self) ignores message \(message)")
    }
  }
  
  public func activateUpdate()
  {
    func portMode() -> UInt8
    {
      switch self.kind
      {
        case .motor(_):                       return HubPropertyOperation.enableUpdate.rawValue
        case .sensor(.sensorColor):           return 0x08
        case .sensor(.sensorMarioHubGesture): return 0x01
        default:                              return 0

      }
    }
    
    self.sent(bytes: [0x41, self.port, portMode(), 0x01, 0x00, 0x00, 0x00, 0x01])
  }
}


