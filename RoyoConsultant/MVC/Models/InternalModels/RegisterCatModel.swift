//
//  RegisterCatModel.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 14/09/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class RegisterCatModel {
    var name: String?
    var requestingFor: String?
    var otherName: String?
    var hcr: [HCR_OptionModel]?
    var address: LocationManagerData?
    var filterOption: FilterOption?
    var startTime: Date?
    var endTime: Date?
    var startDate: [Date]?
    var endDate: [Date]?
    var ros: String?
    var selectedServices: String?
    var consultant_id: String?
    var phone_number: String?
    var country_code: String?
    
    init() {
        
    }
}
