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
        Button("run")
        {
          self.hub?.devices[0]?.send(command: .runTachoMotorDegrees(power: 10, degree: 270, breaking: .break))
        }
        Button("stop")
        {
          self.hub?.devices[0]?.send(command: .runTachoMotor(power: 0, breaking: .float))
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
    }
  }
}



