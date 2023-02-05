//
//  watchConnector.swift
//  rotor Watch App
//
//  Created by Petar Simonovic on 04/02/2023.
//

import Foundation
import WatchConnectivity

class WatchConnector : NSObject,  WCSessionDelegate, ObservableObject {
    
    private let kMessageKey = "message"

    public override init() {
        super.init()

        if WCSession.isSupported() {
            print("Supported in watch")
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
  
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
        
        
        
    }
    
    func send(_ message: String) {
            guard WCSession.default.activationState == .activated else {
              return
            }
            guard WCSession.default.isCompanionAppInstalled else {
                return
            }
            WCSession.default.sendMessage([kMessageKey : message], replyHandler: nil) { error in
                print("Cannot send message: \(String(describing: error))")
            }
        }
    
    
    
}

