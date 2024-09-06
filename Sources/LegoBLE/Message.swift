//
//  File.swift
//  
//
//  Created by psksvp on 6/9/2024.
//

import Foundation
import CommonSwift

public enum Message
{
  case alert(type: AlertType, operation: AlertOperation, payload: AlertPayload)
  
  case deviceAttached(port: UInt8, device: Device.Kind)
  case deviceDetached(port: UInt8)
  
//  case attachedIO(port: UInt8, device: IOTypeID, hardwardVersion: Int32, softwareVersion: Int32)
//  case attachedVirtualIO(port: UInt8, device: IOTypeID, portA: UInt8, portB: UInt8)
//  case detachedIO(port: UInt8)
  
  case action(HubAction)
  case error(command: UInt8, error: GenericError)
  case portOutputFeedback([(port: UInt8, feedback: UInt8)])
  case portOutputCommand(port: UInt8)
  
  case portSingleValue(port: UInt8,  values: [UInt8])
  case portInputFormatSingle(port: UInt8, mode: UInt8, deltaInterval: UInt32, notificationEnabled: Bool)
  
  var type: MessageType
  {
    switch self
    {
      case .action(_):
        return .hubAction
      case .alert(_, _, _):
        return .hubAlert
      case .deviceAttached(port: _, device: _),
           .deviceDetached(port: _):
        return .hubAttachedIO
        
      case .error(_, _):
        return .genericErrorMessage
      case .portOutputFeedback(_):
        return .portOutputCommandFeedback
      case .portSingleValue(port: _, values: _):
        return .portValueSingle
      default:
        fatalError("Add missing code")
    }
  }
}

extension Message
{
  public static func registerDecoder()
  {
    Register.shared.registerEncoder(messageType: .hubAction, encoder: Message.encodeHubAction)
    Register.shared.registerDecoder(messageType: .hubAttachedIO, decoder: Message.decodeHubDeviceAttachedDetached)
    Register.shared.registerDecoder(messageType: .hubAction, decoder: Message.decodeHubAction)
    Register.shared.registerDecoder(messageType: .genericErrorMessage, decoder: Message.decodeError)
    Register.shared.registerDecoder(messageType: .portOutputCommandFeedback, decoder: Message.decodePortOutputFeedback)
    Register.shared.registerDecoder(messageType: .hubAlert, decoder: Message.decodeAlert)
    Register.shared.registerDecoder(messageType: .portValueSingle, decoder: decodePortValueSingle)
    Register.shared.registerDecoder(messageType: .portInputFormatSingle, decoder: decodePortInputFormatSingle)
  }
  
  struct Header
  {
    public let length: UInt8
    public let hubID: UInt8
    public let messageType: MessageType
    
    public init(length: UInt8, messageType: MessageType)
    {
      self.length = length
      self.messageType = messageType
      self.hubID = 0
    }
    
    public init?(_ buffer: [UInt8])
    {
      guard buffer.count >= 3 else
      {
        Log.error("buffer.count < 3")
        return nil
      }
      
      guard let messageType = MessageType(rawValue: buffer[2]) else
      {
        Log.error("There is no messageType:( \(buffer[2]) ) declared in enum MessageType")
        return nil
      }
      
      self.length = buffer[0]
      self.hubID = buffer[1]
      self.messageType = messageType
    }
    
    var encodedBytes: [UInt8]
    {
      [length, hubID, messageType.rawValue]
    }
  }
}
