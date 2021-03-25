//
//  ReviewsData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 07/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class ReviewsData: Codable {
    var review_list: [Review]?
    var after: String?
    var before: String?
    var per_page: Int?
}

class Review: Codable {
    var id: Int?
    var from_user: Int?
    var rating: Double?
    var comment: String?
    var user: User?
}
