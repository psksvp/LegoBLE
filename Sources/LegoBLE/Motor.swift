//
//  File.swift
//  
//
//  Created by psksvp on 30/8/2024.
//

//import Foundation
//
//public class Motor: Device
//{
//  public enum Command
//  {
//    case forward(power: UInt8)
//    case backward(power: UInt8)
//    case float
//    case `break`
//  }
//  
//  public enum Breaking: UInt8
//  {
//    case float = 0
//    case hold = 126
//    case `break` = 127
//  }
//  
//  
//  public func move(command: Command)
//  {
//    switch command
//    {
//      case let .forward(power: a): 
//        setMotor(speed: Int(a))
//      case let .backward(power: a): 
//        setMotor(speed: -Int(a))
//      case let .float, .`break`:
//        setMotor(speed: 0)
//      
//    }
//  }
//  
//  public func setMotor(speed: Int)
//  {
//    var clampSpeed = speed
//    clampSpeed = clampSpeed < -100 ? -100 : clampSpeed
//    clampSpeed = clampSpeed >  100 ?  100 : clampSpeed
//    self.sent(commandBytes: [0x81, self.port, 0x11, 0x51, 0x00, UInt8(clampSpeed)])
//  }
//  
//}


