//
//  ConfirmBookingData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 10/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class ConfirmBookingData: Codable {
    var total: Double?
    var discount: Double?
    var grand_total: Double?
    var book_slot_time: String?
    var book_slot_date: String?
    var coupon: Bool?
}
