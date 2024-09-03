//
//  File.swift
//  
//
//  Created by psksvp on 2/9/2024.
//

import Foundation
import CommonSwift


public extension Device
{
  enum Breaking: UInt8
  {
    case float = 0
    case hold = 126
    case `break` = 127
  }
  
  enum MotorCommand
  {
    case stopMotor(breaking: Breaking)
    case runBasicMotor(power: Int)
    case runTachoMotor(power: Int)
    case runTachoMotorTime(power: Int, timeMS: Int16)
    case runTachoMotorDegrees(power: Int, degree: Int32)
    case setAbsoluteMotorPosition(power: Int, degree: Int32)
    case setAbsoluteMotorEncoderPosition(degree: Int32)
  }
  
  func send(command: MotorCommand)
  {
    let maxPower: UInt8 = 100
    switch command
    {
      case let .stopMotor(breaking: b):
        sent(bytes: [0x81, self.port, 0x11, 0x01, 0, maxPower, b.rawValue, 0x03])
        
      case let .runBasicMotor(power: p):
        sent(bytes: [0x81, self.port, 0x11, 0x51, 0x00, UInt8(p.clamped(to: -100...100))])
      
      case let .runTachoMotor(power: p):
        sent(bytes: [0x81, self.port, 0x11, 0x01, UInt8(p.clamped(to: -100...100)), maxPower, Breaking.break.rawValue, 0x03])
        
      case let .runTachoMotorTime(power: p, timeMS: t):
        self.sent(bytes:  [0x81, port, 0x11, 0x09] +
                           UInt16(t).byteSwapped.byteArray +
                          [UInt8(p.clamped(to: -100...100)), maxPower, Breaking.break.rawValue, 0x03])
        
      case let .runTachoMotorDegrees(power: p, degree: d):
        self.sent(bytes: [0x81, port, 0x11, 0x0B] +
                          d.byteSwapped.bytes +
                         [UInt8(p.clamped(to: -100...100)), maxPower, Breaking.break.rawValue, 0x03])
        
      case let .setAbsoluteMotorPosition(power: p, degree: d):
        self.sent(bytes: [0x81, port, 0x11, 0x0D] + d.byteSwapped.bytes + [UInt8(p.clamped(to: -100...100)), maxPower, Breaking.break.rawValue, 0x03])
        
      case let .setAbsoluteMotorEncoderPosition(degree: d):
        self.sent(bytes: [0x81, port, 0x11, 0x51, 0x02] + d.byteSwapped.bytes)
    }
  }
}

extension Comparable
{
  func clamped(to limits: ClosedRange<Self>) -> Self
  {
    return min(max(self, limits.lowerBound), limits.upperBound)
  }
}
