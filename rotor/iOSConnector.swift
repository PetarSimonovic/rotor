//
//  iOSConnector.swift
//  rotor
//
//  Created by Petar Simonovic on 04/02/2023.
//

import Foundation
import WatchConnectivity

class iOSConnector : NSObject,  WCSessionDelegate, ObservableObject {
    
    private let kMessageKey = "message"
    
    struct NotificationMessage: Identifiable {
        let id = UUID()
        let text: String
    }
    
    @Published var notificationMessage: NotificationMessage? = nil
    
    
    public override init() {
        super.init()
        
        if WCSession.isSupported() {
            print("Supported in iOS")
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
        
        
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func send(_ message: String) {
        guard WCSession.default.activationState == .activated else {
            return
        }
        guard WCSession.default.isWatchAppInstalled else {
            return
        }
        WCSession.default.sendMessage([kMessageKey : message], replyHandler: nil) { error in
            print("Cannot send message: \(String(describing: error))")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let notificationText = message[kMessageKey] as? String {
            DispatchQueue.main.async { [weak self] in
                self?.notificationMessage = NotificationMessage(text: notificationText)
            }
        }
        
        
    }
    
}
