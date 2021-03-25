//
//  EP_Home.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 15/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation
import Moya

enum EP_Home {
    case categories(parentId: String?, after: String?)
    case requests(date: String?, serviceType: ServiceType, after: String?)
    case vendorList(categoryId: String?, filterOptionIds: String?, service_id: String?, search: String?, after: String?)
    case vendorListNew(category_id: String?, filter_id: Int?, date: String?, time: String?, lat: String?, long: String?, service_address: String?, end_date: String?, end_time: String?, duties: String?, after: String?, address_id: String?)
    
    case vendorDetail(id: String?)
    case getFilters(categoryId: String?, duties: String?)
    case logout
    case banners
    case chatListing(after: String?)
    case chatMessages(requestId: String?, after: String?)
    case uploadImage(image: UIImage)
    case endChat(requestId: String?)
    case transactionHistory(transactionType: TransactionType, after: String?)
    case wallet
    case cards
    case addCard(cardNumber: String?, expMonth: String?, expYear: String?, cvv: String?)
    case addMoney(balance: String?, cardId: String?)
    case createRequest(consultant_id: String?, date: String?, time: String?, service_id: String?, schedule_type: ScheduleType, coupon_code: String?, request_id: String?)
    case notifications(after: String?)
    case classes(type: ClassType, categoryId: String?, after: String?)
    case services(categoryId: String?)
    case updateFCMId
    case addReview(consultantId: String?, requestId: String?, review: String?, rating: String?)
    case updateRequestApprovalStatus(valid_hours: String?,status: String?, requestId: String?, comment: String?)
    case getReviews(vendorId: String?, after: String?)
    case deleteCard(cardId: String?)
    case updateCard(cardId: String?, name: String?, expMonth: String?, expYear: String?)
    case coupons(categoryId: String?, serviceId: String?)
    case confirmRequest(consultantId: String?, date: String?, time: String?, serviceId: String, scheduleType: ScheduleType, couponCode: String?, requestId: String?)
    case getSlots(vendorId: String?, date: String?, serviceId: String?, categoryId: String?)
    case enrollUser(classId: String?)
    case classJoin(classId: String?)
    case cancelRequest(requestId: String?)
    case makeCall(requestID: String?)
    case callStatus(requestID: String?, status: CallStatus)
    case appversion(app: AppType, version: String?)
    case pages
    case getClientDetail(app: AppType)
    case getCountryStateCity(type: CountryStateCity, countryId: Int?, stateId: Int?)
    case packages(type: PackageType, categoyId: Int?, listBy: ListBy, after: String?)
    case packageDetail(id: Int?)
    case buyPackage(planId: Int?)
    case getFeeds(feedType: FeedType?, consultant_id: Int?, after: String?)
    case addFav(feedId: Int?, favorite: CustomBool)
    case viewFeed(id: Int?)
    case autoAllocate(category_id: String?, filter_id: Int?, date: String?, time: String?, schedule_type: ScheduleType, request_id: Int?, package_id: Int?, transaction_id: String?, lat: String?, long: String?, first_name: String?, last_name: String?, service_for: String?, home_care_req: String?, reason_for_service: String?, service_address: String?, end_date: String?, end_time: String?)
    case getMasterDuty(filter_ids: String?)
    case createRequestNew(consultant_id: String?, dates: String?, schedule_type: ScheduleType, request_type: String?, first_name: String?, last_name: String?, lat: String?, long: String?, service_for: String?, home_care_req: String?, reason_for_service: String?, service_address: String?, end_date: String?, end_time: String?, card_id: String?, start_time: String?, request_step: String?, filter_id: String?, service_id: String?, duties: String?, phone_number: String?, country_code: String?)
    case completeRequest(consultant_id: String?, dates: String?, schedule_type: ScheduleType, request_type: String?, first_name: String?, last_name: String?, lat: String?, long: String?, service_for: String?, home_care_req: String?, reason_for_service: String?, service_address: String?, end_date: String?, end_time: String?, card_id: String?, start_time: String?, request_step: String?, filter_id: String?, service_id: String?, duties: String?, phone_number: String?, country_code: String?)
    case requestCheck(transaction_id: String?)
    case requestDetail (request_id: String?)
    case saveAddress (address_name: String?, save_as: String?, lat: String?, long: String?, house_no: String?, save_as_preference: Any?)
    case getAddress
    
}

extension EP_Home: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return URL.init(string: Configuration.getValue(for: .ROYO_CONSULTANT_BASE_PATH))!
    }
    
    var path: String {
        switch self {
        case .categories:
            return APIConstants.categories
        case .requests:
            return APIConstants.requests
        case .logout:
            return APIConstants.logout
        case .vendorList, .vendorListNew:
            return APIConstants.vendorList
        case .vendorDetail:
            return APIConstants.vendorDetail
        case .getFilters:
            return APIConstants.getFilters
        case .banners:
            return APIConstants.banners
        case .chatListing:
            return APIConstants.chatListing
        case .chatMessages:
            return APIConstants.chatMessages
        case .uploadImage:
            return APIConstants.uploadImage
        case .endChat:
            return APIConstants.endChat
        case .transactionHistory:
            return APIConstants.transactionHistory
        case .wallet:
            return APIConstants.wallet
        case .cards:
            return APIConstants.cards
        case .addCard:
            return APIConstants.addCard
        case .addMoney:
            return APIConstants.addMoney
        case .createRequest, .createRequestNew, .completeRequest:
            return APIConstants.createRequest
        case .notifications:
            return APIConstants.notifications
        case .classes:
            return APIConstants.classes
        case .services:
            return APIConstants.services
        case .updateFCMId:
            return APIConstants.updateFCMId
        case .addReview:
            return APIConstants.addReview
        case .getReviews:
            return APIConstants.getReviews
        case .deleteCard:
            return APIConstants.deleteCard
        case .updateCard:
            return APIConstants.updateCard
        case .coupons:
            return APIConstants.coupons
        case .confirmRequest(_, _, _, _, _, _, _):
            return APIConstants.confirmRequest
        case .getSlots:
            return APIConstants.getSlots
        case .enrollUser:
            return APIConstants.enrollUser
        case .classJoin:
            return APIConstants.classJoin
        case .cancelRequest:
            return APIConstants.cancelRequest
        case .makeCall:
            return APIConstants.makeCall
        case .callStatus:
            return APIConstants.callStatus
        case .appversion:
            return APIConstants.appVersion
        case .pages:
            return APIConstants.pages
        case .getClientDetail:
            return APIConstants.clientDetail
        case .getCountryStateCity:
            return APIConstants.countryData
        case .packages:
            return APIConstants.packages
        case .packageDetail:
            return APIConstants.packageDetail
        case .buyPackage:
            return APIConstants.buyPackage
        case .getFeeds:
            return APIConstants.feeds
        case .addFav(let id, _):
            return "\(APIConstants.addFav)/\(/id)"
        case .viewFeed(let id):
            return "\(APIConstants.viewFeed)/\(/id)"
        case .autoAllocate:
            return APIConstants.autAllocate
        case .getMasterDuty:
            return APIConstants.masterDuty
        case .requestCheck:
            return APIConstants.requestCheck
        case .updateRequestApprovalStatus:
            return APIConstants.updateRequestApprovalStatus
        case .requestDetail:
            return APIConstants.requestDetails
        case .saveAddress:
            return APIConstants.saveAddress
        case .getAddress:
            return APIConstants.getAddress
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .categories,
             .requests,
             .vendorList,
             .vendorListNew,
             .vendorDetail,
             .getFilters,
             .banners,
             .chatListing,
             .chatMessages,
             .transactionHistory,
             .wallet,
             .cards,
             .notifications,
             .classes,
             .services,
             .getReviews,
             .coupons,
             .getSlots,
             .pages,
             .getClientDetail,
             .getCountryStateCity,
             .packages,
             .packageDetail,
             .getFeeds,
             .viewFeed,
             .getMasterDuty,
             .requestCheck,
             .requestDetail,
             .getAddress:
            return .get
        default:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .categories(let parentId, let after):
            return Parameters.categories.map(values: [parentId, after])
        case .requests(let date, let serviceType, let after):
            return Parameters.requests.map(values: [date, serviceType.rawValue, after])
        case .vendorList(let categoryId, let filterOptionIds, let service_id, let search, let after):
            return Parameters.vendorList.map(values: [categoryId, filterOptionIds, service_id, search, after])
        case .vendorDetail(let id):
            return Parameters.vendorDetail.map(values: [id])
        case .chatMessages(let requestId, let after):
            return Parameters.chatMessages.map(values: [requestId, after])
        case .endChat(let requestId):
            return Parameters.endChat.map(values: [requestId])
        case .transactionHistory(let type, let after):
            return Parameters.transactionHistory.map(values: [type.rawValue, after])
        case .addCard(let cardNumber, let expMonth, let expYear, let cvv):
            return Parameters.addCard.map(values: [cardNumber, expMonth, expYear, cvv])
        case .addMoney(let balance, let cardId):
            return Parameters.addMoney.map(values: [balance, cardId])
        case .createRequest(let consultant_id, let date, let time, let service_id, let schedule_type, let coupon_code, let request_id):
            return Parameters.createRequest.map(values: [consultant_id, date, time, service_id, schedule_type.rawValue, coupon_code, request_id])
        case .notifications(let after):
            return Parameters.notifications.map(values: [after])
        case .classes(let type, let categoryId, let after):
            return Parameters.classes.map(values: [type.rawValue, categoryId, after])
        case .services(let categoryId):
            return Parameters.services.map(values: [categoryId])
        case .getFilters(let categoryId, let duties):
            return Parameters.getFilters.map(values: [categoryId, duties])
        case .updateFCMId:
            var dict = Parameters.updateFCMId.map(values: [UserPreference.shared.firebaseToken])
            if /UserPreference.shared.VOIP_TOKEN != "" {
                dict?[Keys.apn_token.rawValue] = /UserPreference.shared.VOIP_TOKEN
            }
            return dict
        case .addReview(let consultantId, let requestId, let review, let rating):
            return Parameters.addReview.map(values: [consultantId, requestId, review, rating])
        case .getReviews(let vendorId, let after):
            return Parameters.getReviews.map(values: [vendorId, after])
        case .deleteCard(let cardId):
            return Parameters.deleteCard.map(values: [cardId])
        case .updateCard(let cardId, let name, let expMonth, let expYear):
            return Parameters.updateCard.map(values: [cardId, name, expMonth, expYear])
        case .coupons(let categoryId, let serviceId):
            return Parameters.coupons.map(values: [categoryId, serviceId])
        case .confirmRequest(let consultantId, let date, let time, let serviceId, let scheduleType, let couponCode, let requestId):
            return Parameters.confirmRequest.map(values: [consultantId, date, time, serviceId, scheduleType.rawValue, couponCode, requestId])
        case .getSlots(let vendorId, let date, let serviceId, let categoryId):
            return Parameters.getSlots.map(values: [vendorId, date, serviceId, categoryId])
        case .enrollUser(let classId):
            return Parameters.enrollUser.map(values: [classId])
        case .classJoin(let classId):
            return Parameters.classJoin.map(values: [classId])
        case .cancelRequest(let requestId):
            return Parameters.cancelRequest.map(values: [requestId])
        case .makeCall(let requestID):
            return Parameters.makeCall.map(values: [requestID])
        case .callStatus(let requestID, let status):
            return Parameters.callStatus.map(values: [requestID, status.rawValue])
        case .chatListing(let after):
            return Parameters.chatListing.map(values: [after])
        case .appversion(let app, let version):
            return Parameters.appversion.map(values: [app.rawValue, version, "1"]) //1-IOS
        case .getClientDetail(let app):
            return Parameters.clientDetail.map(values: [app.rawValue])
        case .getCountryStateCity(let type, let countryId, let stateId):
            return Parameters.countryData.map(values: [type.rawValue, countryId, stateId])
        case .packages(let type, let categoyId, let listBy, let after):
            return Parameters.getPackages.map(values: [type.rawValue, categoyId, listBy.rawValue, after])
        case .packageDetail(let id):
            return Parameters.packageDetail.map(values: [id])
        case .buyPackage(let id):
            return Parameters.buyPackage.map(values: [id])
        case .getFeeds(let feedType, let consultant_id, let after):
            return Parameters.getFeeds.map(values: [feedType?.rawValue, consultant_id, after])
        case .addFav(_, let favorite):
            return Parameters.addFav.map(values: [/Int(favorite.rawValue)])
        case .autoAllocate(let category_id, let filter_id, let date, let time, let schedule_type, let request_id, let package_id, let transaction_id, let lat, let long, let first_name, let last_name, let service_for, let home_care_req, let reason_for_service, let service_address, let end_date, let end_time):
            let dict = Parameters.autoAllocate.map(values: [category_id, filter_id, date, time, schedule_type.rawValue, request_id, package_id, transaction_id, lat, long, first_name, last_name, service_for, home_care_req, reason_for_service, service_address, end_date, end_time])
            return dict
            
        case .vendorListNew(let category_id, let filter_id, let date, let time, let lat, let long, let service_address, let end_date, let end_time, let duties, let after, let address_id):
            let dict = Parameters.vendorListNew.map(values: [category_id, filter_id, date, time, lat, long, service_address, end_date, end_time, duties, after, address_id])
            return dict
        case .getMasterDuty(filter_ids: let filter_ids):
            return Parameters.masterDuty.map(values: [filter_ids])
            
        case .createRequestNew(let consultant_id, let dates, let schedule_type, let request_type, let first_name, let last_name, let lat, let long, let service_for, let home_care_req, let reason_for_service, let service_address, let end_date, let end_time, let card_id, let start_time, let request_step, let filter_id, let service_id, let duties, let phone_number,let  country_code):
            
            let dict = Parameters.createRequestNew.map(values: [consultant_id, dates, schedule_type.rawValue, request_type, first_name, last_name, lat, long, service_for, home_care_req, reason_for_service, service_address, end_date, end_time, card_id, start_time, request_step, filter_id, service_id, duties, phone_number, country_code])
            return dict
            
        case .completeRequest(let consultant_id, let dates, let schedule_type, let request_type, let first_name, let last_name, let lat, let long, let service_for, let home_care_req, let reason_for_service, let service_address, let end_date, let end_time, let card_id, let start_time, let request_step, let filter_id, let service_id, let duties, let phone_number,let  country_code):
            
            let dict = Parameters.completeRequest.map(values: [consultant_id, dates, schedule_type.rawValue, request_type, first_name, last_name, lat, long, service_for, home_care_req, reason_for_service, service_address, end_date, end_time, card_id, start_time, request_step, filter_id, service_id, duties, phone_number, country_code])
            return dict
        case .requestCheck(let transaction_id):
            return Parameters.requestCheck.map(values: [transaction_id])
        case .updateRequestApprovalStatus(let valid_hours, let status, let requestId, let comment):
            return Parameters.updateRequestApprovalStatus.map(values: [valid_hours, status, requestId, comment])
        case .requestDetail(let request_id):
            return Parameters.requestDetails.map(values: [request_id])
        case .saveAddress(let address_name,let save_as,let lat,let long,let house_no, let save_as_preference):
            return Parameters.saveAddress.map(values: [address_name, save_as, lat, long, house_no, save_as_preference])
            
        default:
            return nil
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .uploadImage:
            return Task.uploadMultipart(multipartBody ?? [])
        default:
            return Task.requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .appversion,
             .pages,
             .getClientDetail:
            return ["Accept" : "application/json",
                    "devicetype": "IOS",
                    "app-id": APIConstants.UNIQUE_APP_ID,
                    "user-type": UserType.customer.rawValue]
        default:
            return ["Accept" : "application/json",
                    "Authorization":"Bearer " + /UserPreference.shared.data?.token,
                    "devicetype": "IOS",
                    "app-id": APIConstants.UNIQUE_APP_ID,
                    "user-type": UserType.customer.rawValue]
        }
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .categories,
             .requests,
             .vendorList,
             .vendorListNew,
             .vendorDetail,
             .getFilters,
             .banners,
             .chatListing,
             .chatMessages,
             .transactionHistory,
             .wallet,
             .cards,
             .notifications,
             .classes,
             .services,
             .getReviews,
             .coupons,
             .getSlots,
             .pages,
             .getClientDetail,
             .getCountryStateCity,
             .packages,
             .packageDetail,
             .getFeeds,
             .viewFeed,
             .getMasterDuty,
             .requestCheck,
             .requestDetail,
             .getAddress:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
    
    var multipartBody: [MultipartFormData]? {
        switch self {
        case .uploadImage(let image):
            var multiPartData = [MultipartFormData]()
            let data = image.jpegData(compressionQuality: 0.5) ?? Data()
            multiPartData.append(MultipartFormData.init(provider: .data(data), name: Keys.image.rawValue, fileName: "image.jpg", mimeType: "image/jpeg"))
            parameters?.forEach({ (key, value) in
                let tempValue = /(value as? String)
                let data = tempValue.data(using: String.Encoding.utf8) ?? Data()
                multiPartData.append(MultipartFormData.init(provider: .data(data), name: key))
            })
            return multiPartData
        default:
            return []
        }
    }
    
}
