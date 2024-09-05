//
//  File.swift
//  
//
//  Created by psksvp on 5/9/2024.
//

import Foundation
import CommonSwift

public extension Device
{
  enum SensorValue
  {
    case voltage(Double)
    case current(Double)
    case motorPosition(degree: Int)
    case xyz(x: Int, y: Int, z: Int, sensor: SensorType)
  }
  
  func decode(rawSensorData: [UInt8]) -> SensorValue?
  {
    switch self.kind
    {
      case .sensor(.sensorCurrent):
        return decodeCurrent(rawSensorData)
        
      case .sensor(.sensorVoltage):
        return decodeVoltage(rawSensorData)
        
      case .motor(_):
        return decodeTachoMotor(rawSensorData)
        
      case .sensor(.sensorTechnicMediumHubTilt):
        return decodeXYZ(rawSensorData, sensor: .sensorTechnicMediumHubTilt)
        
      case .sensor(.sensorTiltExternal):
        return decodeXYZ(rawSensorData, sensor: .sensorTiltExternal)
        
      case .sensor(.sensorTiltInternal):
        return decodeXYZ(rawSensorData, sensor: .sensorTiltInternal)
        
      case .sensor(.sensorTechnicMediumHubGyro):
        return decodeXYZ(rawSensorData, sensor: .sensorTechnicMediumHubGyro)
        
      case .sensor(.sensorTechnicMediumHubAccelerometer):
        return decodeXYZ(rawSensorData, sensor: .sensorTechnicMediumHubAccelerometer)
        
      default:
        return nil
    }
  }
  
  func decodeVoltage(_ data: [UInt8]) -> SensorValue?
  {
    guard  data.count >= 2 else
    {
      Log.error("buffer.count < 2")
      return nil
    }
    
    let voltageMax = 9.6
    let voltageRawMax = 3893.0
    let scale = voltageMax / voltageRawMax
    
    let raw = Double(UInt16(data[1], data[0]))
    
    return .voltage(raw * scale)
  }
  
  func decodeCurrent(_ data: [UInt8]) -> SensorValue?
  {
    guard data.count >= 2 else
    {
      Log.error("buffer.count < 2")
      return nil
    }
    
    let currentMax = 2444.0
    let currentRawMax = 4095.0
    let scale = currentMax / currentRawMax
    
    let raw = Double(UInt16(data[1], data[0]))
    
    return .current(raw * scale)
  }
  
  func decodeTachoMotor(_ data: [UInt8]) -> SensorValue?
  {
    guard data.count >= 4 else
    {
      Log.error("buffer.count < 4")
      return nil
    }
    
    return .motorPosition(degree: Int(Int32(data[3], data[2], data[1], data[0])))
  }
  
  
  func decodeXYZ(_ data: [UInt8], sensor: SensorType) -> SensorValue?
  {
    guard data.count >= 6 else
    {
      Log.error("buffer.count < 6")
      return nil
    }
    
    let x = Int(UInt16(data[1], data[0]))
    let y = Int(UInt16(data[3], data[2]))
    let z = Int(UInt16(data[4], data[5]))
    return .xyz(x: x, y: y, z: z, sensor: sensor)
  }
  
}
