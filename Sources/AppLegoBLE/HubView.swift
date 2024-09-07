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
        self.hub.devices[0]?.send(command: .runTachoMotor(power: self.dir))
      }
    }
  }
}
