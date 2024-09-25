//
//  File.swift
//  
//
//  Created by psksvp on 6/9/2024.
//

import Foundation
import SwiftUI
import LegoBLE

struct HubView: View
{
  @ObservedObject var hub: LegoBLE.Hub
  @State var steer: Int = 0
  @State var dir: Int = 1
  
  var body: some View
  {
    VStack
    {
      steeringView()
      Divider()
      List
      {
        ForEach(Array(hub.devices.values), id:\.port)
        {
          device in
          self.deviceView(device)
        }
      }
    }
  }
  
  func deviceView(_ d: LegoBLE.Device) -> some View
  {
    DeviceView(device: d)
  }
  
  func steeringView() -> some View
  {
    HStack
    {
      TextField("degree", value: self.$steer, formatter: NumberFormatter())
      TextField("dir", value: self.$dir, formatter: NumberFormatter())
      Button("steer")
      {
        //self.hub.devices[3]?.send(command: .setAbsoluteMotorPosition(power: 30 * self.dir, degree: Int32(self.steer)))
        //self.hub.devices[0]?.send(command: .runTachoMotor(power: self.dir))
        self.hub.devices[3]?.sensorHandler = callBack
        doingRight = true
        done = false
        left = nil
        right = nil
        self.hub.devices[3]?.send(command: .runTachoMotor(power: self.dir))
      }
      Button("center")
      {
        //self.hub.devices[3]?.send(command: .setAbsoluteMotorPosition(power: 30 * self.dir, degree: Int32(self.steer)))
        
        self.hub.devices[3]?.sensorHandler = callBack
        self.hub.devices[3]?.send(command: .setAbsoluteMotorPosition(power: self.dir, degree: 0))
      }
    }
  }
}


var left: Int? = nil
var right: Int? = nil

var doingRight = true
var done = false

func hasNotChanged(_ cur: Int, _ val: Int?, tolerent: Int) -> Bool
{
  guard let v = val else
  {
    return false
  }
  
  return abs(cur - v) <= tolerent
  
}

func maxRight(_ cur: Int, device: Device)
{
  if hasNotChanged(cur, right, tolerent: 1)
  {
    device.send(command: .stopMotor(breaking: .break))
    print("right break sent")
    doingRight = false
    device.send(command: .runTachoMotor(power: -10))
    return
  }
  
  right = cur
}


func maxLeft(_ cur: Int, device: Device)
{
  
  if hasNotChanged(cur, left, tolerent: 1)
  {
    device.send(command: .stopMotor(breaking: .break))
    print("left break sent")
    done = true
    if let (_, m) = range()
    {
      device.send(command: .setAbsoluteMotorPosition(power: 10, degree: Int32(m)))
    }
    return
  }
  
  left = cur
}

func range() -> (range: Int, mid: Int)?
{
  guard let l = left, let r = right else {return nil}
  return (abs(l - r), abs(l - r) / 2)
}


func callBack(device: Device, s: Device.SensorValue)
{
  if done
  {
    print("done")
    return
  }
  switch s
  {
    case .motorPosition(degree: let d):
      if doingRight
      {
        maxRight(d, device: device)
      }
      else
      {
        maxLeft(d, device: device)
      }
    default:
      return
  }
  print("12322333 ---> \(s),  \(range())")
}
