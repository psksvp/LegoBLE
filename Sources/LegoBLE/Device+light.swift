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
  enum LEDColor: UInt8
  {
    case black = 0
    case pink = 1
    case purple = 2
    case blue = 3
    case lightBlue = 4
    case cyan = 5
    case green = 6
    case yellow = 7
    case orange = 8
    case red = 9
    case white = 10
    case numColors
    case none = 255
  }
  
  func setHubLED(color: LEDColor)
  {
    // set LED color mode
    self.sent(bytes: [0x41, self.port, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00])
    
    // set the color
    self.sent(bytes: [0x81, self.port, 0x11, 0x51, 0x00, color.rawValue])
  }
  
  func setHubRGB(red: UInt8, green: UInt8, blue: UInt8)
  {
    // set LED color mode
    self.sent(bytes: [0x41, self.port, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00])
    
    // set the color
    self.sent(bytes: [0x81, self.port, 0x11, 0x51, 0x01, red, green, blue])
  }
  
  /*
   byte port = getPortForDeviceType((byte)DeviceType::HUB_LED);
   byte setColorMode[8] = {0x41, port, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00};
   WriteValue(setColorMode, 8);
   byte setColor[6] = {0x81, port, 0x11, 0x51, 0x00, color};
   WriteValue(setColor, 6);
   
   void Lpf2Hub::setLedRGBColor(char red, char green, char blue)
   {
       byte port = getPortForDeviceType((byte)DeviceType::HUB_LED);
       byte setRGBMode[8] = {0x41, port, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00};
       WriteValue(setRGBMode, 8);
       byte setRGBColor[8] = {0x81, port, 0x11, 0x51, 0x01, red, green, blue};
       WriteValue(setRGBColor, 8);
   }

   */
}
