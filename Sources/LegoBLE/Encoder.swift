//
//  File.swift
//  
//
//  Created by psksvp on 23/8/2024.
//

import Foundation
import CommonSwift

public extension Message
{
  static func encode(message: Message) -> [UInt8]?
  {
    guard let encoder = Register.shared.encoder(forMessageType: message.type) else
    {
      Log.error("There is no encoder for message.type == \(message.type)")
      return nil
    }
    
    return encoder(message)
  }
  
  static func encodeHubAction(message: Message) -> [UInt8]?
  {
    switch message
    {
      case let .action(a):
        return [4, 0, MessageType.hubAction.rawValue, a.rawValue]
        
      default:
        return nil
    }
  }
  
}



