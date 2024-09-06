//
//  File.swift
//  
//
//  Created by psksvp on 6/9/2024.
//

import Foundation
import SwiftUI
import LegoBLE

struct DeviceView: View
{
  @ObservedObject var device: LegoBLE.Device
  
  var body: some View
  {
    HStack
    {
      Text("Port: \(self.device.port)")
      Text("Device: \(self.device.kind)")
      self.device.sensor != nil ? Text("Sensor: \(device.sensor!)") : Text("Sensor: None")
    }
  }
}
