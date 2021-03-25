//
//  SocketManager.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 20/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import SocketIO

enum EventName: String {
    case sendMessage //used
    case messageFromServer //used
    case typing
    case broadcast
    case acknowledgeMessage
    case readMessage
    case deliveredMessage
    case sendlivelocation

}

class SocketIOManager {
    static let shared = SocketIOManager()
    
    private let manager = SocketManager.init(socketURL: URL.init(string: Configuration.getValue(for: .ROYO_CONSULTANT_SOCKET_BASE_PATH))!, config: [.log(true), .connectParams(["user_id" : "\(/UserPreference.shared.data?.id)"]), .forceNew(true)])
    
    public var didRecieveMessage: ((_ message: Message) -> Void)?
    public var didReceiveLocation: ((_ location: Location) -> Void)?
    public var didRequestCompleted: (() -> Void)?
    public var didReadMessageByOtherUser: (() -> Void)?
    public var didDeliveredMessageByOtherUser: (() -> Void)?
    
    private var isListening = false

    
    public func connect() {
        
        let defaultSocket = manager.defaultSocket
        
        switch defaultSocket.status {
        case .disconnected, .notConnected:
            disconnect()
            defaultSocket.connect()
        case .connected, .connecting:
            return
        }
        
        isListening ? () : setupListeners()

    }
    
    public func disconnect() {
        
        manager.defaultSocket.off(SocketClientEvent.disconnect.rawValue)
        manager.defaultSocket.off(SocketClientEvent.connect.rawValue)
        manager.defaultSocket.off(SocketClientEvent.error.rawValue)
        
        
        manager.defaultSocket.off(EventName.sendMessage.rawValue)
        manager.defaultSocket.off(EventName.messageFromServer.rawValue)
        manager.defaultSocket.off(EventName.typing.rawValue)
        manager.defaultSocket.off(EventName.broadcast.rawValue)
        manager.defaultSocket.off(EventName.acknowledgeMessage.rawValue)
        manager.defaultSocket.off(EventName.readMessage.rawValue)
        manager.defaultSocket.off(EventName.deliveredMessage.rawValue)
        
        manager.defaultSocket.disconnect()
        
        isListening = false

    }
    
    private func setupListeners() {
        
        isListening = true

        manager.defaultSocket.on(SocketClientEvent.disconnect.rawValue) { [weak self] (response, _) in
            debugPrint("👹👹👹👹👹👹👹👹👹👹 Socket Disconnected: \(response)")
            self?.disconnect()
        }
        
        manager.defaultSocket.on(SocketClientEvent.connect.rawValue) { (response, _) in
            debugPrint("😍😍😍😍😍😍😍😍😍😍 Socket Connnected: \(response)")
        }
        
        manager.defaultSocket.on(SocketClientEvent.error.rawValue) { [weak self] (response, socket) in
            debugPrint("👹👹👹👹👹👹👹👹👹👹 Socket Error: \(response)", socket)
            self?.disconnect()
        }
        
        manager.defaultSocket.on(EventName.messageFromServer.rawValue) { [weak self] (response, _) in
            debugPrint("🐦🐦🐦🐦🐦🐦🐦🐦🐦🐦 Chat Message Received: \(response)")
            guard let messageDict = response.first as? [String : Any] else {
                return
            }
            let model = Message.init(socketResponse: messageDict)
            self?.deliveredMessage(message: model)
            self?.didRecieveMessage?(model)
            if /UIApplication.topVC()?.isKind(of: ChatVC.self) && UIApplication.shared.applicationState == .active {
                self?.readMessage(message: model)
            }
        }
        
        manager.defaultSocket.on(EventName.readMessage.rawValue) { [weak self] (response, _) in
            guard let messageDict = response.first as? [String : Any] else {
                return
            }
            self?.didReadMessageByOtherUser?()
            debugPrint("😍😍😍😍😍😍😍😍😍😍 Chat Message read by other user: \(messageDict)")
        }
        
        manager.defaultSocket.on(EventName.deliveredMessage.rawValue) { [weak self] (response, _) in
            guard let messageDict = response.first as? [String : Any] else {
                return
            }
            self?.didDeliveredMessageByOtherUser?()
            debugPrint("😍😍😍😍😍😍😍😍😍😍 Chat Message delivered to other user: \(messageDict)")
        }
        
        manager.defaultSocket.on(EventName.typing.rawValue) { (response, _) in
            debugPrint("🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫 Chat User is typing: \(response)")
        }
        
        manager.defaultSocket.on(EventName.acknowledgeMessage.rawValue) { (response, _) in
            debugPrint("😍😍😍😍😍😍😍😍😍😍 Chat Message Acknowledgement: \(response)")
        }
        
        manager.defaultSocket.on(EventName.sendlivelocation.rawValue) { [weak self] (response, _) in
            guard let dict = response.first as? [String : Any] else {
                return
            }
            let model = Location.init(socketResponse: dict)
            self?.didReceiveLocation?(model)

            debugPrint("😍😍😍😍😍😍😍😍😍😍 location to other user: \(dict)")
        }
    }
    
    public func sendMessage(message: Message) {
//        var dict = JSONHelper<Message>().toDictionary(model: message) ?? [:]
//        dict["sentAt"] = Int64(Date().timeIntervalSince1970 * 1000)
//        dict.removeValue(forKey: "messageId")
//        dict.removeValue(forKey: "user")
//        manager.defaultSocket.emitWithAck(EventName.sendMessage.rawValue, dict).timingOut(after: 1.0) { [weak self] (response) in
//            let responseDict = (response as? [[String : Any]])?.first
//            if /(responseDict?["status"] as? String) == "REQUEST_COMPLETED" {
//                self?.didRequestCompleted?()
//            }
//            debugPrint("😍😍😍😍😍😍😍😍😍😍 Chat Message sent: \(response)")
//        }
    }
    
    public func readMessage(message: Message?) {
        let dict = ["messageId" : /message?.messageId,
                    "senderId": /message?.receiverId,
                    "receiverId": /message?.senderId]
        
        manager.defaultSocket.emitWithAck(EventName.readMessage.rawValue, dict).timingOut(after: 1.0) { (response) in
            debugPrint("😍😍😍😍😍😍😍😍😍😍 Chat Message Read from this side: \(response)")
        }
    }
    
    private func deliveredMessage(message: Message?) {
        let dict = ["messageId" : /message?.messageId,
                    "senderId": /message?.receiverId,
                    "receiverId": /message?.senderId]
        manager.defaultSocket.emitWithAck(EventName.deliveredMessage.rawValue, dict).timingOut(after: 1.0) { (response) in
            debugPrint("😍😍😍😍😍😍😍😍😍😍 Chat Message Delivered from this side: \(response)")
        }
    }
}
