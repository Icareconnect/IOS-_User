//
//  ServicesData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 04/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class ServicesData: Codable {
    var services: [Service]?
    var after: String?
    var before: String?
    var per_page: Int?
}

class Service: Codable {
    var id: Int?
    var category_id: Int?
    var service_id: Int?
    var available: CustomBool?
    var price_minimum: Double?
    var price_maximum: Double?
    var minimum_duration: Double?
    var gap_duration: Double?
    var duration: String?
    var name: String?
    var unit_price: Double?
    var color_code: String?
    var description: String?
    var need_availability: CustomBool?
    var price_fixed: Double?
    var price_type: PriceType?
    var minimmum_heads_up: String?
    var price: Double?
    var category_service_id: Int?
    var service_name: String?
    
    //Additional Property not from backend
    var isSelected: Bool? = false
    
    init(serviceId: Int?, categoryId: Int?) {
        service_id = serviceId
        category_id = categoryId
    }
}
