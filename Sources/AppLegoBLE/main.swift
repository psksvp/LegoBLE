import Foundation
import SwiftUI
import MinimalSwiftUI
import LegoBLE

// Entry point
NSApplication.shared.run
{
  ContentView().frame(maxWidth: .infinity, maxHeight: .infinity)
}


// root view
struct ContentView: View
{
  var body: some View
  {
    LegoBLEView().padding()
  }
}

struct LegoBLEView: View
{
  @ObservedObject var legoBLE = LegoCentralBLE()
  @State var hub: Hub? = nil
  @State var power: Int = 0
  @State var degree: Int = 0
  
  var body: some View
  {
    VStack
    {
      HStack
      {
        Button("scan")
        {
          self.legoBLE.startScanning()
        }
        Button("Off")
        {
          self.hub?.switchOff()
        }
        TextField("power", value: self.$power, formatter: NumberFormatter())
        Button("run")
        {
          self.hub?.devices[3]?.send(command: .runTachoMotorDegrees(power: self.power, degree: Int32(degree)))
          //self.hub?.devices[3]?.send(command: .runTachoMotorTime(power: -self.power, timeMS: 1))
          //self.hub?.devices[0]?.send(command: .setAbsoluteMotorPosition(power: self.power, degree: Int32(self.degree)))
        }
        TextField("degree", value: self.$degree, formatter: NumberFormatter())
        Button("zero")
        {
          self.hub?.devices[3]?.send(command: .setAbsoluteMotorPosition(power: 20, degree: Int32(0)))
        }
        Button("stop")
        {
          self.hub?.devices[1]?.send(command: .stopMotor(breaking: .float))
        }
      }
      List(self.legoBLE.peripherals, id: \.identifier)
      {
        p in
        Button("\(p.description)")
        {
          self.hub  = self.legoBLE.connect(hubID: p.identifier)
        }
      }
      
      if let h = self.hub
      {
        HubView(hub: h)
      }
    }
  }
}



