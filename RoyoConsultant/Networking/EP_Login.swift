//
//  LoginEP.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation
import Moya

enum EP_Login {
    case login(provider_type: ProviderType, provider_id: String?, provider_verification: String?, user_type: UserType, country_code: String?)
    case sendOTP(phone: String?, countryCode: String?)
    case sendEmailOTP(email: String?)
    case verifyEmailOTP(email: String?, otp: String?)
    
    case profileUpdate(name: String?, email: String?, phone: String?, country_code: String?, dob: String?, bio: String?, speciality: String?, call_price: String?, chat_price: String?, category_id: String?, experience: String?, profile_image: String?)
    case register(name: String?, email: String?, password: String?, phone: String?, code: String?, user_type: UserType, fcm_id: String?, country_code: String?, dob: String?, bio: String?, profile_image: String?, provider_type: ProviderType)
    case forgotPsw(email: String?)
    case updatePhone(phone: String?, countryCode: String?, otp: String?)
    case updateInsuranceAndAddress(name: String?, address: String?, country: String?, state: String?, city: String?, insurance_enable: String?, insurances: String?, custom_fields: String?)
    case updateWorkPreferences(master_preferences: Any?)
    case getMasterPreferences(type: String?, preference_type: String?)
    
}

extension EP_Login: TargetType, AccessTokenAuthorizable {
    
    var baseURL: URL {
        return URL(string: Configuration.getValue(for: .ROYO_CONSULTANT_BASE_PATH))!
    }
    
    var path: String {
        switch self {
        case .login:
            return APIConstants.login
        case .sendOTP:
            return APIConstants.sendOTP
        case .profileUpdate,
             .updateInsuranceAndAddress, .updateWorkPreferences:
            return APIConstants.profileUpdate
        case .register:
            return APIConstants.register
        case .forgotPsw(_):
            return APIConstants.forgotPsw
        case .updatePhone(_, _, _):
            return APIConstants.updatePhone
        case .getMasterPreferences:
            return APIConstants.masterPreferences
        case .sendEmailOTP:
            return APIConstants.sendEmailOTP
        case .verifyEmailOTP:
            return APIConstants.verifyEmail
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMasterPreferences:
            return .get
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        default:
            return Task.requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .profileUpdate,
             .updatePhone,
             .updateInsuranceAndAddress, .updateWorkPreferences:
            return ["Accept" : "application/json",
                    "Authorization":"Bearer " + /UserPreference.shared.data?.token,
                    "devicetype": "IOS",
                    "app-id": APIConstants.UNIQUE_APP_ID,
                    "user-type": UserType.customer.rawValue]
        default:
            return ["devicetype": "IOS",
                    "Accept" : "application/json",
                    "app-id": APIConstants.UNIQUE_APP_ID,
                    "user-type": UserType.customer.rawValue]
        }
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    var parameters: [String: Any]? {
        //    let location = LocationManager.shared.locationData
        //    let latitude = String(location.latitude)
        //    let longitude = String(location.longitude)
        //    let deviceToken = /UserPreference.shared.firebaseToken
        
        switch self {
        case .login(let provider_type, let provider_id, let provider_verification, let user_type, let country_code):
            var dictionary = Parameters.login.map(values: [provider_type.rawValue, provider_id, provider_verification, user_type.rawValue, country_code])
            dictionary?[Keys.apn_token.rawValue] = /UserPreference.shared.VOIP_TOKEN
            return dictionary
        case .sendOTP(let phone, let countryCode):
            return Parameters.sendOTP.map(values: [phone, countryCode])
        case .profileUpdate(let name, let email, let phone, let country_code, let dob, let bio, let speciality, let call_price, let chat_price, let category_id, let experience, let profile_image):
            
            var dictionary = Parameters.profileUpdate.map(values: [name, email, phone, country_code, dob, bio, speciality, call_price, chat_price, category_id, experience, profile_image, UserType.customer.rawValue])
            dictionary?[Keys.apn_token.rawValue] = /UserPreference.shared.VOIP_TOKEN
            return dictionary
            
        case .register(let name, let email, let password, let phone, let code, let user_type, let fcm_id, let country_code, let dob, let bio, let profile_image, let provider_type):
            return Parameters.register.map(values: [name, email, password, phone, code, user_type.rawValue, fcm_id, country_code, dob, bio, profile_image, provider_type.rawValue])
        case .forgotPsw(let email):
            return Parameters.forgotPsw.map(values: [email])
        case .updatePhone(let phone, let countryCode, let otp):
            return Parameters.updatePhone.map(values: [phone, countryCode, otp])
        case .updateInsuranceAndAddress(let name, let address, let country, let state, let city, let insurance_enable, let insurances, let custom_fields):
            return Parameters.insurancesAddress.map(values: [name, address, country, state, city, insurance_enable, insurances, custom_fields])
        case .updateWorkPreferences(master_preferences: let master_preferences):
            return Parameters.updateWorkPreferences.map(values: [master_preferences])
        case .getMasterPreferences(type: let type, preference_type: let preference_type):
            return Parameters.masterPreference.map(values: [type, preference_type])
        case .sendEmailOTP(email: let email):
            return Parameters.sendEmailOtp.map(values: [email])
        case .verifyEmailOTP(email: let email, otp: let otp):
            return Parameters.verifyEmail.map(values: [email, otp])
            
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getMasterPreferences:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
    
}
