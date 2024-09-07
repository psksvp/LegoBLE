//
//  File.swift
//  
//
//  Created by psksvp on 6/9/2024.
//

import Foundation
import CommonSwift


public class Driver
{
  public enum Command
  {
    case steer(degree: Int)
    case forward(power: Int, distance: Int)
    case reverse(power: Int, distance: Int)
    case `break`
  }
  
  public func drive(command: Driver.Command)
  {
    fatalError("Driver.drive empty implementation")
  }
}

//Audi RS Q e-tron 42160
public class AudiETronDriver: Driver
{
  let hub: Hub
  let frontMotor: Device
  let rearMotor: Device
  let steeringMotor: Device
  
  public init?(hub: Hub)
  {
    self.hub = hub
    guard let front = self.hub.devices[1],
          let rear = self.hub.devices[0],
          let steer = self.hub.devices[2] else
    {
      Log.error("fail to get device for front or rear or steering motor.")
      return nil
    }
    
    self.frontMotor = front
    self.rearMotor = rear
    self.steeringMotor = steer
    
    super.init()
    
    self.frontMotor.sensorHandler = self.sensor
    self.rearMotor.sensorHandler = self.sensor
    self.steeringMotor.sensorHandler = self.sensor
  }
  
  public func sensor(_ device: Device, _ sensorVale: Device.SensorValue)
  {
    
  }
  
  public func steer(degree: Int)
  {
    
  }
  
  public override func drive(command: Driver.Command)
  {
    switch command
    {
      case .steer(degree: let d):
        print("steer \(d)")
        
      case .forward(power: let p, distance: let d):
        print("forward \(p), \(d)")
        
      case .reverse(power: let p, distance: let d):
        print("reverse \(p), \(d)")
        
      case .break:
        print("break")
    }
  }
  
  
}
