//
//  File.swift
//  
//
//  Created by psksvp on 2/9/2024.
//

import Foundation
import CommonSwift

// motor and actuator
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
    case setAccelerationProfile(timeMS: UInt16)
    case setDecelerationProfile(timeMS: UInt16)
  }
  
  func send(command: MotorCommand)
  {
    func scale(_ p: Int) -> UInt8
    {
      // copy from from Arduino
      func map(_ x: Int, _ inMin: Int, _ inMax: Int, _ outMin: Int, _ outMax: Int) -> Int
      {
        (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
      }
      
      let m = p.clamped(to: -100...100)
      
      if (m == 0)
      {
          return 127; // stop motor
      }
      else if (m > 0)
      {
          return UInt8(map(m, 0, 100, 0, 126))
      }
      else
      {
          return UInt8(map(-m, 0, 100, 255, 128))
      }
    }
    
    guard "\(self.kind)".contains("motor") else
    {
      Log.error("trying to sent motor command on non motor device.")
      return
    }
    
    let maxPower: UInt8 = 100
    switch command
    {
      case let .stopMotor(breaking: b):
        sent(bytes: [0x81, self.port, 0x11, 0x01, scale(0), maxPower, b.rawValue, 0x03])
        
      case let .runBasicMotor(power: p):
        sent(bytes: [0x81, self.port, 0x11, 0x51, 0x00, scale(p)])
      
      case let .runTachoMotor(power: p):
        sent(bytes: [0x81, self.port, 0x11, 0x01, scale(p), maxPower, Breaking.break.rawValue, 0x03])
        
      case let .runTachoMotorTime(power: p, timeMS: t):
        self.sent(bytes:  [0x81, port, 0x11, 0x09] +
                           UInt16(t).byteSwapped.byteArray +
                          [scale(p), maxPower, Breaking.break.rawValue, 0x03])
        
      case let .runTachoMotorDegrees(power: p, degree: d):
        self.sent(bytes: [0x81, port, 0x11, 0x0B] +
                          d.byteSwapped.bytes +
                         [scale(p), maxPower, Breaking.break.rawValue, 0x03])
        
      case let .setAbsoluteMotorPosition(power: p, degree: d):
        self.sent(bytes: [0x81, port, 0x11, 0x0D] + d.byteSwapped.bytes + [scale(p), maxPower, Breaking.break.rawValue, 0x03])
        
      case let .setAbsoluteMotorEncoderPosition(degree: d):
        self.sent(bytes: [0x81, port, 0x11, 0x51, 0x02] + d.byteSwapped.bytes)
        
      case let .setAccelerationProfile(timeMS: t):
        self.sent(bytes: [0x81, port, 0x10, 0x05] + t.byteSwapped.byteArray + [0x01])
        
      case let .setDecelerationProfile(timeMS: t):
        self.sent(bytes: [0x81, port, 0x10, 0x06] + t.byteSwapped.byteArray + [0x02])
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
