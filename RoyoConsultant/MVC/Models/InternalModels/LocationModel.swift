//
//  LocationModel.swift
//  RoyoConsultant
//
//  Created by Chitresh Goyal on 13/01/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import Foundation

class Location: Codable {
    
    var request_id: Int?
    var receiverId: Int?
    var lat: String?
    var long: String?
    var senderId: Int?
    
    init(socketResponse: [String : Any]) {
        request_id = Int(String.init(describing: socketResponse["request_id"] ?? ""))
        senderId = Int(String.init(describing: socketResponse["senderId"] ?? ""))
        receiverId = socketResponse["receiverId"] as? Int
        lat = socketResponse["lat"] as? String
        long = socketResponse["long"] as? String
    }
}
