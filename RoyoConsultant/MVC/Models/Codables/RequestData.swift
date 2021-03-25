//
//  RequestData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 16/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class RequestData: Codable {
    var requests: [Requests]?
    var after: String?
    var before: String?
    var per_page: Int?
}

class RequestDetailsData: Codable {
    var request_detail: Requests?
    
}

class Requests: Codable {
    var id: Int?
    var from_user: User?
    var to_user: User?
    var booking_date: String?
    var bookingDateUTC: String?
    var canReschedule: Bool?
    var canCancel: Bool?
    var time: String?
    var service_type: String?
    var duration: Double?
    var status: RequestStatus?
    var price: String?
    var schedule_type: ScheduleType?
    var service_id: Int?
    var extra_detail: ExtraDetails?
    var duties: [Duties]?
    
    var user_status: String?
    var user_comment: String?
    var user_status_time: String?
    var userIsApproved : Bool?
    var rating: Double?
    var comment: String?
    var total_hours: Double?
    var canceled_by: User?
}

class ExtraDetails: Codable {
    var id: Int?
    var request_id: Int?
    var first_name: String?
    var last_name: String?
    var service_for: String?
    var home_care_req: String?
    var service_address: String?
    var distance: String?
    var lat: String?
    var long: String?
    var reason_for_service: String?
    var working_dates: String?
    var start_time: String?
    var end_time: String?
    var filter_name: String?
    var country_code: String?
    var phone_number: String?
}

class Duties: Codable {
    var id: Int?
    var option_name: String?
    var preference_id: Int?
    var image: String?
    var description: String?
}
