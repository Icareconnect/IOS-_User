//
//  VendorData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class VendorData: Codable {
    var vendors: [Vendor]?
    var after: String?
    var before: String?
    var per_page: Int?
    var next_page: Int?
    
    private enum CodingKeys: String, CodingKey {
        case after
        case before
        case per_page
        case next_page
        case vendors = "doctors"
    }
}

class Vendor: Codable {
    var id: Int?
    var sp_id: Int?
    var category_service_id: Int?
    var available: CustomBool?
    var duration: String?
    var price: Double?
    var service_type: String?
    var vendor_data: User?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case sp_id
        case category_service_id
        case available
        case duration
        case service_type
        case price
        case vendor_data = "doctor_data"
    }
}

class VendorDetailData: Codable {
    var vendor_data: User?
    
    private enum CodingKeys: String, CodingKey {
        case vendor_data = "dcotor_detail"
    }
}


