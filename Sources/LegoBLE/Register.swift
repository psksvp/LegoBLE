//
//  Register.swift
//
//
//  Created by psksvp on 23/8/2024.
//

import Foundation

public typealias Encoder = ((Message) -> [UInt8]?)
public typealias Decoder = (([UInt8]) -> Message?)

public class Register
{
  static let shared: Register =
  {
    let instance = Register()
    return instance
  }()
  
  private var decoderRegister = [MessageType : Decoder]()
  private var encoderRegister = [MessageType : Encoder]()
  
  public func registerDecoder(messageType: MessageType, decoder: @escaping Decoder)
  {
    self.decoderRegister[messageType] = decoder
  }
  
  public func registerEncoder(messageType: MessageType, encoder: @escaping Encoder)
  {
    self.encoderRegister[messageType] = encoder
  }
  
  public func decoder(forMessageType m: MessageType) -> Decoder?
  {
    self.decoderRegister[m]
  }
  
  public func encoder(forMessageType m: MessageType) -> Encoder?
  {
    self.encoderRegister[m]
  }
}
