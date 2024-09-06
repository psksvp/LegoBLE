import Foundation
import CommonSwift

public enum MessageType: UInt8
{
  case hubProperties = 0x01
  case hubAction = 0x02
  case hubAlert = 0x03
  case hubAttachedIO = 0x04
  case genericErrorMessage = 0x05
  case hwNetworkCommands = 0x08
  case fwUpdateBootMode = 0x10
  case fwUpdateLockMemory = 0x11
  case fwUpdateLockStatusRequest = 0x12
  case fwLockStatus = 0x13
  
  case portInfomationRequest = 0x21
  case portModeInfomationRequest = 0x22
  
  case portInputFormatSetupSingle = 0x41
  case portInputFormatSetupCombinedMode = 0x42
  case portInformation = 0x43
  case portModeInformation = 0x44
  case portValueSingle = 0x45
  case portValueCombinedMode = 0x46
  case portInputFormatSingle = 0x47
  case portInputFormatCombinedMode = 0x48
  
  case virtualPortSetup = 0x61
  case portOutputCommand = 0x81
  case portOutputCommandFeedback = 0x82
}

public enum HubProperty: UInt8
{
  case advertisingName = 0x01
  case button = 0x02
  case fwVersion = 0x03
  case hwVersion = 0x04
  case rssi = 0x05
  case batteryVoltage = 0x06
  case batteryType = 0x07
  case manufacturerName = 0x08
  case radioFirmwareVersion = 0x09
  case wirelessProtocolVersion = 0x0A
  case systemTypeID = 0x0B
  case hwNetworkID = 0x0C
  case primaryMAC = 0x0D
  case secondaryMAC = 0x0E
  case hwNetworkFamily = 0x0F
}

public enum HubPropertyOperation: UInt8
{
  case set = 0x01
  case enableUpdate = 0x02
  case disableUpdate = 0x03
  case reset = 0x04
  case requestUpdate = 0x05
  case update = 0x06
}

public enum AlertType: UInt8
{
  case lowVoltage = 0x01
  case highCurrent = 0x02
  case lowSignal = 0x03
  case overPower = 0x04
}

public enum AlertOperation: UInt8
{
  case enableUpdates = 0x01
  case disableUpdates = 0x02
  case requestUpdates = 0x03
  case update = 0x04
}

public enum AlertPayload: UInt8
{
  case statusOK = 0x00
  case alert = 0xFF
}

public enum IOEvent: UInt8
{
  case detachedIO = 0x00
  case attachedIO = 0x01
  case attachedVirtualIO = 0x02
}

public enum DeviceID: UInt16
{
  // down stream
  case motorTechnicLarge = 0x002E
  case motorTechnicXLarge = 0x002F
  case motorTechnicLargeAngular = 49   // Spike Prime
  case motorTechnicMediumAngular = 48   // Spike Prime
  case motorTechnicMediumAngularGrey = 75 // Mindstorms
  case motorTechnicLargeAngularGrey = 76   // Mindstorms
  case motorBasic = 0x0001
  case motorTrain = 0x0002
  case motorWithTachoExternal = 0x0026
  case motorwithTachoInternal = 0x0027
  
  case sound = 0x0016
  case lightRGB = 0x0017
  case lightColor = 0x0008
  
  // up stream
  case sensorTechnicMediumHubTemperature = 60
  case sensorTechnicMediumHubGesture = 54
  case sensorTechnicMediumHubAccelerometer = 57
  case sensorTechnicMediumHubGyro = 58
  case sensorTechnicMediumHubTilt = 59
  case sensorTechnicColor = 61               // Spike Prime
  case sensorTechnicDistance = 62           // Spike Prime
  case sensorTechnicForce = 63              // Spike Prime
  case sensorMarioHubGesture = 71          // https://github.com/bricklife/LEGO-Mario-Reveng
  case sensorMarioHubBarcode = 73          // https://github.com/bricklife/LEGO-Mario-Reveng
  case sensorMarioHubPant = 74             // https://github.com/bricklife/LEGO-Mario-Reveng
  
  case sensorTiltExternal = 0x0022
  case sensorMotion = 0x0023
  case sensorColor = 0x0025
  case sensorTiltInternal = 0x0028
  
  case sensorVoltage = 0x0014
  case sensorCurrent = 0x0015
  
  case button = 0x0005
  case remoteControlButton = 55
  case remoteControlRSSI = 56
  
  case unknown = 0
  
  static func lookup(_ n: UInt16) -> DeviceID
  {
    guard let ioType = DeviceID(rawValue: n) else
    {
      return .unknown
    }
    
    return ioType
  }
}

public enum HubAction: UInt8
{
  // downstream only
  case switchOffHub = 0x01
  case disconnect = 0x02
  case vccPortControlOn = 0x03
  case vccPortControlOff = 0x04
  case activateBusyIndication = 0x05
  case resetBusyIndication = 0x06
  case shutdownHub = 0x2f
  // upstream only
  case hubWillSwitchOff = 0x30
  case hubWillDisconnect = 0x31
  case hunWillGoIntoBootMode = 0x32
}

public enum GenericError: UInt8
{
  case ACK = 0x01
  case MACK = 0x02
  case bufferOverflow = 0x03
  case timeout = 0x04
  case unknownCommand = 0x05
  case invalidUse = 0x06
  case overCurrent = 0x07
  case internalError = 0x08
}

public enum MotorType: UInt16
{
  case motorTechnicLarge = 0x002E
  case motorTechnicXLarge = 0x002F
  case motorTechnicLargeAngular = 49   // Spike Prime
  case motorTechnicMediumAngular = 48   // Spike Prime
  case motorTechnicMediumAngularGrey = 75 // Mindstorms
  case motorTechnicLargeAngularGrey = 76   // Mindstorms
  case motorBasic = 0x0001
  case motorTrain = 0x0002
  case motorWithTachoExternal = 0x0026
  case motorwithTachoInternal = 0x0027 //motorDualMoveHub
}

public enum SensorType: UInt16
{
  case sensorTechnicMediumHubTemperature = 60
  case sensorTechnicMediumHubGesture = 54
  case sensorTechnicMediumHubAccelerometer = 57
  case sensorTechnicMediumHubGyro = 58
  case sensorTechnicMediumHubTilt = 59
  case sensorTechnicColor = 61               // Spike Prime
  case sensorTechnicDistance = 62           // Spike Prime
  case sensorTechnicForce = 63              // Spike Prime
  case sensorMarioHubGesture = 71          // https://github.com/bricklife/LEGO-Mario-Reveng
  case sensorMarioHubBarcode = 73          // https://github.com/bricklife/LEGO-Mario-Reveng
  case sensorMarioHubPant = 74             // https://github.com/bricklife/LEGO-Mario-Reveng
  
  case sensorTiltExternal = 0x0022
  case sensorMotion = 0x0023
  case sensorColor = 0x0025
  case sensorTiltInternal = 0x0028
  
  case sensorVoltage = 0x0014
  case sensorCurrent = 0x0015
}

public enum LightType: UInt16
{
  case lightRGB = 0x0017
  case lightColor = 0x0008
}

public enum OutputFeedback: UInt8
{
  case commandInProgress = 0x01
  case commandCompleted = 0x02
  case commandDiscarded = 0x04
  case busy = 0x10
  case idle = 0x08
}





