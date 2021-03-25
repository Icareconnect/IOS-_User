//
//  APIConstants.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

enum CloneIds: String {
    case NURSING_STAFF = "fc3eda974104a85c07d59108190ad6056"
}

internal struct APIConstants {
    
    static let UNIQUE_APP_ID = CloneIds.NURSING_STAFF.rawValue

    static let login = "api/login"
    static let register = "api/register"
    static let profileUpdate = "api/profile-update"
    static let uploadImage = "api/upload-image"
    static let updatePhone = "api/update-phone"
    static let updateFCMId = "api/update-fcm-id"
    static let forgotPsw = "api/forgot_password"
    static let changePsw = "api/change_password"
    static let logout = "api/app_logout"
    static let sendOTP = "api/send-sms"
    static let categories = "api/categories"
    static let requests = "api/requests-cs"
    static let vendorList = "api/doctor-list"
    static let vendorDetail = "api/doctor-detail"
    static let getFilters = "api/get-filters"
    static let banners = "api/banners"
    static let transactionHistory = "api/wallet-history"
    static let wallet = "api/wallet"
    static let cards = "api/cards"
    static let addMoney = "api/add-money"
    static let addCard = "api/add-card"
    static let createRequest = "api/create-request"
    static let notifications = "api/notifications"
    static let services = "api/services"
    static let addReview = "api/add-review"
    static let getReviews = "api/review-list"
    static let deleteCard = "api/delete-card"
    static let updateCard = "api/update-card"
    static let coupons = "api/coupons"
    static let confirmRequest = "api/confirm-request"
    static let getSlots = "api/get-slots"
    static let classes = "api/classes"
    static let enrollUser = "api/enroll-user"
    static let classJoin = "api/class/join"
    static let cancelRequest = "api/cancel-request"
    static let callStatus = "api/call-status"
    static let makeCall = "api/make-call"
    static let appVersion = "api/appversion"
    static let pages = "api/pages"
    static let clientDetail = "api/clientdetail"
    static let countryData = "api/countrydata"
    static let packages = "api/pack-sub"
    static let packageDetail = "api/pack-detail"
    static let buyPackage = "api/sub-pack"
    static let feeds = "api/feeds"
    static let addFav = "api/feeds/add-favorite"
    static let viewFeed = "api/feeds/view"
    static let autAllocate = "api/auto-allocate"
    
    //Chat
    static let chatListing = "api/chat-listing"
    static let chatMessages = "api/chat-messages"
    static let endChat = "api/complete-chat"
    
    static let termsConditions = "terms-conditions"
    static let privacyPolicy = "privacy-policy"
    
    static let masterDuty = "api/master/duty"
    static let requestCheck = "api/request-check"
    
    static let updateRequestApprovalStatus = "api/request-user-approve"
    static let masterPreferences = "api/master/preferences"
    static let requestDetails = "api/request-detail"
    static let sendEmailOTP = "api/send-email-otp"
    static let verifyEmail = "api/email-verify"
    
    static let saveAddress = "api/save-address"
    static let getAddress = "api/get-address"

}

enum SDK: String {
    case GoogleSignInKey = "952614479078-ibeh87gtthl05g6481aegn7mcn9i422q.apps.googleusercontent.com"
    case GooglePlaceKey = "AIzaSyCWRLStt_5Kmgd877p8o_fPM2W5pdZ4WbU"
    
}

