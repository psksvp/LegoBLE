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
  
  var body: some View
  {
    List
    {
      ForEach(Array(hub.devices.values), id:\.port)
      {
        device in
        self.deviceView(device)
      }
    }
  }
  
  func deviceView(_ d: LegoBLE.Device) -> some View
  {
    DeviceView(device: d)
  }
}
