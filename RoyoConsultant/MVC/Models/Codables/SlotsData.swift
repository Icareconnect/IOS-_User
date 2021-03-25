//
//  SlotsData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 10/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class SlotsData: Codable {
    var slots: [Slot]?
    var interval: [Interval]?
    var date: String?
}

class Slot: Codable {
    var start_time: String?
    var end_time: String?
}

class Interval: Codable {
    var time: String?
    var available: Bool?
    
    //Extra local key
    var isSelected: Bool? = false
}
