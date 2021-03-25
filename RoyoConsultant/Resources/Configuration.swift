//
//  Configuration.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 25/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

enum Configuration {
    
    enum ConfigKey: String {
        case ROYO_CONSULTANT_CLIENT_ID
        case ROYO_CONSULTANT_IMAGE_THUMBS
        case ROYO_CONSULTANT_IMAGE_UPLOAD
        case ROYO_CONSULTANT_IMAGE_ORIGINAL
        case ROYO_CONSULTANT_BASE_PATH
        case ROYO_CONSULTANT_SOCKET_BASE_PATH
        case ROYO_CONSULTANT_JITSI_SERVER
        case ROYO_CONSULTANT_APPLE_APP_ID
        case ROYO_CONSULTANT_ANDROID_PACKAGE_NAME
        case ROYO_CONSULTANT_FIREBASE_PAGE_LINK
        case ROYO_CONSULTANT_BUNDLE_ID
    }
    
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    private static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
    
    static func getValue(for key: ConfigKey) -> String {
        return try! Configuration.value(for: key.rawValue)
    }
    
}

