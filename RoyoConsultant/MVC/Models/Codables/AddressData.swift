//
//  NotificationData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 26/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class AddressData: Codable {
    var after: String?
    var before: String?
    var per_page: Int?
    var addresses: [AddressModel]?
}

class AddressModel: Codable {

    var lat: String?
    var long: String?
    var save_as: String?
    var house_no: String?
    var address_name: String?
    var id: Int?
}
