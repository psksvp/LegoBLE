//
//  File.swift
//
//
//  Created by psksvp on 31/8/2024.
//

import Foundation
import CoreBluetooth
import CommonSwift

public class LegoCentralBLE: NSObject, ObservableObject
{
  static let idLego = CBUUID(string: "00001623-1212-EFDE-1623-785FEABCD123")
  static let idCharTxRx = CBUUID(string: "00001624-1212-EFDE-1623-785FEABCD123")
  private let centralManager: CBCentralManager
  private let scanningTimeout: TimeInterval = 15.0
  
  @Published
  public private(set) var hubs = [UUID : Hub]()
  
  @Published
  public private(set) var peripherals = [CBPeripheral]()
  
  @Published
  public private(set) var state: CBManagerState = .unknown
  
  public override init()
  {
    self.centralManager = CBCentralManager()
    super.init()
    Message.registerDecoder()
  }
  
  deinit
  {
    self.stopScanning()
  }
  
  public func startScanning()
  {
    guard !self.centralManager.isScanning else {return}

    self.centralManager.delegate = self
    self.centralManager.scanForPeripherals(withServices: [LegoCentralBLE.idLego])
    Log.info("start scanning.")
    Timer.scheduledTimer(withTimeInterval: self.scanningTimeout, repeats: false)
    {
      _ in
      self.stopScanning()
    }
  }
  
  public func stopScanning()
  {
    guard self.centralManager.isScanning else {return}
    self.centralManager.stopScan()
    Log.info("stop scanning.")
  }
  
  public func connect(hubID: UUID) -> Hub?
  {
    if let hub = self.hubs[hubID]
    {
      return hub
    }
    
    for p in self.peripherals
    {
      if p.identifier == hubID
      {
        let hub = Hub(peripheral: p)
        self.hubs[hub.id] = hub
        self.centralManager.connect(p)
        return hub
      }
    }
    Log.error("there is no hub id == \(hubID)")
    return nil
  }
  
}

extension LegoCentralBLE: CBCentralManagerDelegate
{
  public func centralManagerDidUpdateState(_ central: CBCentralManager)
  {
    DispatchQueue.main.async
    {
      self.state = central.state
    }
  }
  
  public func centralManager(_ central: CBCentralManager,
                      didDiscover peripheral: CBPeripheral,
                      advertisementData: [String : Any],
                      rssi RSSI: NSNumber)
  {
    guard !self.peripherals.contains(where: {$0.identifier == peripheral.identifier}) else {return}
    
    Log.info("discover \(peripheral)")
    Log.info("advertisementData \(advertisementData)")
    self.peripherals.append(peripheral)
  }
  
  public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
  {
    Log.info("connected to \(peripheral)")
    peripheral.discoverServices([LegoCentralBLE.idLego])
  }
}
