//
//  Decoder.swift
//
//
//  Created by psksvp on 22/8/2024.
//

import Foundation
import CommonSwift

public extension Message
{
  static func decode(_ buffer: [UInt8]) -> Message?
  {
    guard let header = Header(buffer) else
    {
      return nil
    }
    
    guard let decode = Register.shared.decoder(forMessageType: header.messageType) else
    {
      Log.warn("There is no decoder registed from messageType: \(header.messageType)")
      Log.info("\(buffer)")
      return nil
    }
    
    return decode(buffer)
  }
  
//  static func decodeHubAttachedIO(_ buffer: [UInt8]) -> Message?
//  {
//    let ioDetetchedBytes = 5
//    let ioAttachedBytes = 15
//    let ioAttachedVirtualBytes = 9
//    
//    if buffer.count >= ioDetetchedBytes,
//       buffer[4] == IOEvent.detachedIO.rawValue // detach
//    {
//      return .detachedIO(port: buffer[3])
//    }
//    
//    if buffer.count >= ioAttachedBytes,
//       buffer[4] == IOEvent.attachedIO.rawValue // attach
//    {
//      let ioTypeID = IOTypeID.lookup(UInt16(buffer[6], buffer[5]))
//      let hwVer = Int32(buffer[10], buffer[9], buffer[8], buffer[7])
//      let swVer = Int32(buffer[14], buffer[13], buffer[12], buffer[11])
//      return .attachedIO(port: buffer[3], device: ioTypeID, hardwardVersion: hwVer, softwareVersion: swVer)
//    }
//    
//    if buffer.count >= ioAttachedVirtualBytes,
//       buffer[4] == IOEvent.attachedIO.rawValue // attach
//    {
//      let ioTypeID = IOTypeID.lookup(UInt16(buffer[5], buffer[6]))
//      return .attachedVirtualIO(port: buffer[3], device: ioTypeID, portA: buffer[7], portB: buffer[8])
//    }
//    
//    Log.error("fail to decode hub attached IO, unknown buffer size \(buffer.count)")
//    
//    return nil
//  }
  
  static func decodeHubDeviceAttachedDetached(_ buffer: [UInt8]) -> Message?
  {
    let ioDetetchedBytes = 5
    let ioAttachedBytes = 15
    //let ioAttachedVirtualBytes = 9
    
    if buffer.count >= ioDetetchedBytes,
       buffer[4] == IOEvent.detachedIO.rawValue // detach
    {
      return .deviceDetached(port: buffer[3])
    }
    
    if buffer.count >= ioAttachedBytes,
       buffer[4] == IOEvent.attachedIO.rawValue, // attach
       let kind = Device.Kind.lookup(UInt16(buffer[6], buffer[5]))
    {
      return .deviceAttached(port: buffer[3], device: kind)
    }
    
    Log.error("fail to decode hub attached IO, buffer size:\(buffer.count)")
    
    return nil
  }
  
  static func decodeHubAction(_ buffer: [UInt8]) -> Message?
  {
    guard  buffer.count >= 4 else
    {
      Log.error("Buffer size < 4")
      return nil
    }
    if let action = HubAction(rawValue: buffer[3])
    {
      return .action(action)
    }
    else
    {
      Log.error("unknown HubAction code \(buffer[3])")
      return nil
    }
  }
  
  static func decodeError(_ buffer: [UInt8]) -> Message?
  {
    guard buffer.count >= 5 else
    {
      Log.error("Buffer size < 5")
      return nil
    }
    
    if let code = GenericError(rawValue: buffer[4])
    {
      return .error(command: buffer[3], error: code)
    }
    else
    {
      Log.error("unknown error code \(buffer[3])")
      return nil
    }
  }
  
  static func decodePortOutputFeedback(_ buffer: [UInt8]) -> Message?
  {
    guard buffer.count >= 5 else
    {
      Log.error("Buffer size < 5")
      return nil
    }
    
    let m = stride(from: 3, to: buffer.count, by: 2)
            .map({(port: buffer[$0], feedback: buffer[$0 + 1])})
    
    return .portOutputFeedback(m)
  }
  
  static func decodeAlert(_ buffer: [UInt8]) -> Message?
  {
    guard buffer.count >= 6,
          let alertType = AlertType(rawValue: buffer[3]),
          let operation = AlertOperation(rawValue: buffer[4]),
          let payload = AlertPayload(rawValue: buffer[6]) else
    {
      Log.error("guard fail, buffer.count == \(buffer.count), require 6")
      return nil
    }
  
    return Message.alert(type: alertType,
                    operation: operation,
                      payload: payload)
  }
}
