//
//  PackagesData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class PackagesData: Codable {
    var packages: [Package]?
    var after: String?
    var before: String?
    var per_page: Int?
    var detail: Package?
    var amountNotSufficient: Bool?
}

class Package: Codable {
    var id: Int?
    var title: String?
    var description: String?
    var price: Double?
    var image: String?
    var total_requests: Int?
    var category_id: Int?
    var subscribe: Bool?
}
