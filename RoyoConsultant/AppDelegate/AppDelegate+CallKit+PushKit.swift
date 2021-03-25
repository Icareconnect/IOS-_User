//
//  AppDelegate+CallKit+PushKit.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import PushKit
import CallKit

extension AppDelegate {
    //MARK:- PushKit Setup
    internal func VoIP_Registry() {
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]
        providerDelegate = ProviderDelegate()
        useVoipToken(voipRegistry.pushToken(for: .voIP))
    }
    
    internal func useVoipToken(_ tokenData: Data?) {
        guard let token = tokenData else { return }
        UserPreference.shared.VOIP_TOKEN = token.reduce("", {$0 + String(format: "%02X", $1) })
        if checkUserLoggedIn(showPopUp: false) {
            EP_Home.updateFCMId.request(success: { (_) in
                
            })
        }
    }
}

//MARK:- PuskKit Delegates
extension AppDelegate: PKPushRegistryDelegate {
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        useVoipToken(pushCredentials.token)
    }

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        
        let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        guard let dictionaryPayLoad = payload.dictionaryPayload as? [String : Any] else {
            return
        }
        let data = ((dictionaryPayLoad["aps"]) as? [String : Any])?["data"] as? [String : Any]
        
        let requestID = String(/(data?["request_id"] as? Int))
        let handle = data?["sender_name"] as? String
        let isVideo = /(data?["service_type"] as? String)?.lowercased() == "video call"
        
        providerDelegate?.displayIncomingCall(requestId: requestID, uuid: UUID(), handle: /handle, hasVideo: isVideo, completion: { (error) in
            Toast.shared.showAlert(type: .notification, message: /error?.localizedDescription)
            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
        })
    }
}

//MARK:- CALLKIT PROVIDER CXProvider
class ProviderDelegate: NSObject {
    
    private let provider: CXProvider
    var currentCallUUID: UUID?
    var requestId: String?
    var isVideo: Bool?
    
    override init() {
        provider = CXProvider(configuration: ProviderDelegate.providerConfiguration)
        super.init()
        provider.setDelegate(self, queue: nil)
    }
    
    static var providerConfiguration: CXProviderConfiguration {
        let localizedName = VCLiteral.APP_TITLE_PREFIX.localized + VCLiteral.APP_TITLE_SUFFIX.localized
        let providerConfiguration = CXProviderConfiguration(localizedName: localizedName)
        
        providerConfiguration.supportsVideo = true
        
        providerConfiguration.maximumCallsPerCallGroup = 1
        
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        
        providerConfiguration.ringtoneSound = "call_sound.caf"
        
        providerConfiguration.iconTemplateImageData = #imageLiteral(resourceName: "logo_call").pngData()
        
        return providerConfiguration
    }
    
    func displayIncomingCall(requestId: String?, uuid: UUID, handle: String, hasVideo: Bool = true, completion: ((Error?) -> Void)?) {
        // 1.
        self.requestId = requestId
        self.currentCallUUID = uuid
        self.isVideo = hasVideo
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
        update.hasVideo = hasVideo
        // 2.
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if error == nil {
                
            }
            self.currentCallUUID = uuid
            // 4.
            completion?(error)
        }
        EP_Home.callStatus(requestID: /self.requestId, status: .CALL_RINGING).request(success: { (_) in
            
        }) { (_) in
            
        }
    }
    
    func endCall() {
        
        guard let uuid = currentCallUUID else {
            return
        }
        
        provider.reportCall(with: uuid, endedAt: Date(), reason: .remoteEnded)
        
        provider.invalidate()
        currentCallUUID = nil
        
    }
    
}

//MARK:- CXProvider Delegates
extension ProviderDelegate: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        DispatchQueue.main.async {
            EP_Home.callStatus(requestID: /self.requestId, status: .CALL_ACCEPTED).request(success: { (_) in
                
            }) { (_) in
                
            }
            (UIApplication.shared.delegate as? AppDelegate)?.startJitsiCall(roomName: /UserPreference.shared.clientDetail?.getJitsiUniqueID(.CALL, id: /Int(/self.requestId)), requestId: self.requestId, subject: VCLiteral.CALL.localized, isVideo: self.isVideo)
        }
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        EP_Home.callStatus(requestID: requestId, status: .CALL_CANCELED).request(success: { (_) in
            
        }) { (_) in
            
        }
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        EP_Home.callStatus(requestID: requestId, status: .CALL_CANCELED).request(success: { (_) in
            
        }) { (_) in
            
        }
        action.fulfill()
    }
}

