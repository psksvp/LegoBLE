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
      
      if n == IOTypeID.sound.rawValue
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
  public var messageHandler: ((Message)->Void)? = {message in print(message)}
  
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


