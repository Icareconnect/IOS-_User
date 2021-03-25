//
//  Parameter+Keys.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

typealias OptionalDictionary = [String : Any]?

extension Sequence where Iterator.Element == Keys {
    func map(values: [Any?]) -> OptionalDictionary {
        var params = [String : Any]()
        
        for (index,element) in zip(self,values) {
            if element != nil {
                params[index.rawValue] = element
            }
        }
        return params
    }
}

enum Keys: String {
    case provider_type
    case provider_id
    case provider_verification
    case user_type
    case country_code
    case name
    case email
    case password
    case phone
    case code
    case fcm_id
    case dob
    case bio
    case profile_image
    case speciality
    case call_price
    case chat_price
    case category_id
    case experience
    case otp
    case date
    case service_type
    case parent_id
    case filter_option_ids
    case vendor_id = "doctor_id"
    case request_id
    case after
    case image
    case transaction_type
    case card_number
    case exp_month
    case exp_year
    case cvc
    case balance
    case card_id
    case consultant_id
    case schedule_type
    case type
    case CategoryId
    case time
    case service_id
    case coupon_code
    case search
    case review
    case rating
    case class_id
    case status
    case apn_token
    case app_type
    case current_version
    case device_type
    case country_id
    case state_id
    case address
    case country
    case state
    case city
    case insurance_enable
    case insurances
    case custom_fields
    case list_by
    case package_id
    case plan_id
    case favorite
    case filter_id
    case transaction_id
    case lat
    case long
    case first_name
    case last_name
    case service_for
    case home_care_req
    case reason_for_service
    case service_address
    case end_date
    case end_time
    case duties
    case filter_ids
    case dates
    case request_type
    case start_time
    case request_step
    case comment
    case master_preferences
    case preference_type
    case phone_number
    case address_name
    case save_as
    case house_no
    case save_as_preference
    case address_id
    case valid_hours
}

struct Parameters {
    static let login: [Keys] = [.provider_type, .provider_id, .provider_verification, .user_type, .country_code]
    
    static let register: [Keys] = [.name, .email, .password, .phone, .code, .user_type, .fcm_id, .country_code, .dob, .bio, .profile_image, .provider_type]
    
    static let profileUpdate: [Keys] = [.name, .email, .phone, .country_code, .dob, .bio, .speciality, .call_price, .chat_price, .category_id, .experience, .profile_image, .user_type]
    
    static let updatePhone: [Keys] = [.phone, .country_code, .otp]
    
    static let updateFCMId: [Keys] = [.fcm_id]
    
    static let forgotPsw: [Keys] = [.email]
    
    static let changePsw: [Keys] = [.password]
    
    static let sendOTP: [Keys] = [.phone, .country_code]
    
    static let requests: [Keys] = [.date, .service_type, .after]
    
    static let categories: [Keys] = [.parent_id, .after]
    
    static let vendorList: [Keys] = [.category_id, .filter_option_ids, .service_id, .search, .after]
    
    static let vendorDetail: [Keys] = [.vendor_id]
    
    static let chatMessages: [Keys] = [.request_id, .after]
    
    static let endChat: [Keys] = [.request_id]
    
    static let transactionHistory: [Keys] = [.transaction_type, .after]
    
    static let addCard: [Keys] = [.card_number, .exp_month, .exp_year, .cvc]
    
    static let addMoney: [Keys] = [.balance, .card_id]
    
    static let createRequest: [Keys] = [.consultant_id, .date, .time, .service_id, .schedule_type, .coupon_code, .request_id]
    
    static let notifications: [Keys] = [.after]
    
    static let classes: [Keys] = [.type, .CategoryId, .after]
    
    static let services: [Keys] = [.category_id]
    
    static let getFilters: [Keys] = [.category_id, .duties]
    
    static let addReview: [Keys] = [.consultant_id, .request_id, .review, .rating]
    
    static let getReviews: [Keys] = [.vendor_id, .after]
    
    static let deleteCard: [Keys] = [.card_id]
    
    static let updateCard: [Keys] = [.card_id, .name, .exp_month, .exp_year]
    
    static let coupons: [Keys] = [.category_id, .service_id]
    
    static let confirmRequest: [Keys] = [.consultant_id, .date, .time, .service_id, .schedule_type, .coupon_code, .request_id]
    
    static let getSlots: [Keys] = [.vendor_id, .date, .service_id, .category_id]
    
    static let enrollUser: [Keys] = [.class_id]
    
    static let classJoin: [Keys] = [.class_id]
    
    static let cancelRequest: [Keys] = [.request_id]
    
    static let makeCall: [Keys] = [.request_id]
    
    static let callStatus: [Keys] = [.request_id, .status]
    
    static let chatListing: [Keys] = [.after]
    
    static let appversion: [Keys] = [.app_type, .current_version, .device_type]
    
    static let clientDetail: [Keys] = [.app_type]
    
    static let countryData: [Keys] = [.type, .country_id, .state_id]
    
    static let insurancesAddress: [Keys] = [.name, .address, .country, .state, .city, .insurance_enable, .insurances, .custom_fields]
    
    static let getPackages: [Keys] = [.type, .category_id, .list_by, .after]
    
    static let packageDetail: [Keys] = [.package_id]
    
    static let buyPackage: [Keys] = [.plan_id]
    
    static let getFeeds: [Keys] = [.type , .consultant_id, .after]
    
    static let addFav: [Keys] = [.favorite]
    
    static let autoAllocate: [Keys] = [.category_id, .filter_id, .date, .time, .schedule_type, .request_id, .package_id, .transaction_id, .lat, .long, .first_name, .last_name, .service_for, .home_care_req, .reason_for_service, .service_address, .end_date, .end_time]
    
    static let vendorListNew: [Keys] = [.category_id, .filter_id, .date, .time, .lat, .long, .service_address, .end_date, .end_time, .duties, .after, .address_id]
    
    static let createRequestNew: [Keys] = [.consultant_id, .dates, .schedule_type, .request_type, .first_name, .last_name, .lat, .long, .service_for, .home_care_req, .reason_for_service, .service_address, .end_date, .end_time, .card_id, .start_time, .request_step, .filter_id, .service_id, .duties, .phone_number, .country_code]
    static let completeRequest: [Keys] = [.consultant_id, .dates, .schedule_type, .request_type, .first_name, .last_name, .lat, .long, .service_for, .home_care_req, .reason_for_service, .service_address, .end_date, .end_time, .card_id, .start_time, .request_step, .filter_id, .service_id, .duties, .phone_number, .country_code]
    static let masterDuty: [Keys] = [.filter_ids]
    static let requestCheck: [Keys] = [.transaction_id]
    static let updateRequestApprovalStatus: [Keys] = [.valid_hours, .status, .request_id, .comment]
    static let updateWorkPreferences: [Keys] = [.master_preferences]
    static let masterPreference: [Keys] = [.type, .preference_type]
    static let requestDetails: [Keys] = [.request_id]
    static let sendEmailOtp: [Keys] = [.email]
    static let verifyEmail: [Keys] = [.email, .otp]
    static let saveAddress: [Keys] = [.address_name, .save_as, .lat, .long, .house_no, .save_as_preference]
    
}

