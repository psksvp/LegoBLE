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
    case runBasicMotor(power: Int)
    case runTachoMotor(power: Int, breaking: Breaking)
    case runTachoMotorTime(power: Int, timeMS: Int16, breaking: Breaking)
    case runTachoMotorDegrees(power: Int, degree: Int32, breaking: Breaking)
  }
  
  func send(command: MotorCommand)
  {
    let maxPower: UInt8 = 100
    switch command
    {
      case let .runBasicMotor(power: p):
        sent(bytes: [0x81, self.port, 0x11, 0x51, 0x00, UInt8(p.clamped(to: -100...100))])
      
      case let .runTachoMotor(power: p, breaking: b):
        sent(bytes: [0x81, self.port, 0x11, 0x01, UInt8(p.clamped(to: -100...100)), maxPower, b.rawValue, 0x03])
        
      case let .runTachoMotorTime(power: p, timeMS: t, breaking: b):
        self.sent(bytes:  [0x81, port, 0x11, 0x09] +
                           UInt16(t).byteSwapped.byteArray +
                          [UInt8(p.clamped(to: -100...100)), maxPower, b.rawValue, 0x03])
        
      case let .runTachoMotorDegrees(power: p, degree: d, breaking: b):
        self.sent(bytes: [0x81, port, 0x11, 0x0B] +
                          d.byteSwapped.bytes +
                         [UInt8(p.clamped(to: -100...100)), maxPower, b.rawValue, 0x03])
        
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
