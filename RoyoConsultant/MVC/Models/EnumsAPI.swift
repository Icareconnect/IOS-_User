//
//  Enums.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

protocol CaseIterableDefaultsLast: Decodable & CaseIterable & RawRepresentable
where RawValue: Decodable, AllCases: BidirectionalCollection { }

extension CaseIterableDefaultsLast {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.last!
    }
}

enum ProviderType: String, Codable, CaseIterableDefaultsLast{
    case facebook
    case google
    case email
    case phone
    case apple
    
    case unknown
}

enum UserType: String {
    case customer
    case service_provider
}

enum AppType: String {
    case UserApp = "1"
    case VendorApp = "2"
}

enum TransactionType: String, Codable, CaseIterableDefaultsLast {
    case deposit
    case withdrawal
    case refund
    case all
    case add_package

    var transactionText: VCLiteral {
        switch self {
        case .withdrawal:
            return .MONEY_SENT_TO
        case .deposit:
            return .ADDED_TO_WALLET
        case .refund:
            return .REFUND_FROM
        case .all:
            return .NA
        case .add_package:
            return .ADDED_PACKAGE
        }
    }
}

enum ServiceType: String, Codable, CaseIterableDefaultsLast {
    case chat
    case call
    case all
    case home
    
    case unknown
    
}

enum RequestStatus: String, Codable, CaseIterableDefaultsLast {
    case pending
    case inProgress = "in-progress"
    case accept
    case completed
    case start_service
    case noAnswer = "no-answer"
    case busy
    case failed
    case canceled
    case start
    case unknown
    case reached
    case cancel_service
    
    var linkedColor: ColorAsset {
        switch self {
        case .noAnswer:
            return .requestStatusNoAnswer
        case .busy:
            return .requestStatusBusy
        case .failed, .canceled, .cancel_service:
            return .requestStatusFailed
        case .unknown:
            return .appTint
        case .start_service, .start, .reached:
            return .appTint
        default:
            return .appTint
        }
    }
    
    var title: VCLiteral {
        switch self {
        case .pending:
            return .NEW
        case .inProgress:
            return .INPROGRESS
        case .accept:
            return .ACCEPT
        case .completed:
            return .COMPLETE
        case .noAnswer:
            return .NO_ANSWER
        case .busy:
            return .BUSY
        case .failed:
            return .FAILED
        case .unknown:
            return .NA
        case .canceled, .cancel_service:
            return .CANCELLED
        case .start_service:
            return .STARTED
        case .start:
            return .INPROGRESS
        case .reached:
            return .REACHED
        }
    }
}

extension String {
    var experience: String {
        if self == "1" {
            return String.init(format: VCLiteral.YR_EXP.localized, /self)
        } else if /self == "" {
            return ""
        } else {
            return String.init(format: VCLiteral.YRS_EXP.localized, /self)
        }
    }
}

enum AddMoneyAmounts: Int {
    case Amount1 = 500
    case Amount2 = 1000
    case Amount3 = 1500
    
    var formattedText: String {
        return "+ " + /Double(self.rawValue).getFormattedPrice()
    }
}

enum ScheduleType: String, Codable {
    case instant
    case schedule
}

enum ClassType: String, Codable, CaseIterableDefaultsLast {
    case USER_COMPLETED
    case USER_OCCUPIED
    case VENDOR_ADDED
    case VENDOR_COMPLETED
    case USER_SIDE
    case DEFAULT
}

enum CustomBool: String, Codable, CaseIterableDefaultsLast {
    case TRUE = "1"
    case FALSE = "0"
}

enum PriceType: String, Codable, CaseIterableDefaultsLast {
    case fixed_price
    case price_range
    
}

enum DiscountType: String, Codable, CaseIterableDefaultsLast {
    case currency
    case percentage
}

enum ClassStatus: String, Codable, CaseIterableDefaultsLast {
    case started
    case completed
    case added
    case Default
}

enum BannerType: String, Codable, CaseIterableDefaultsLast {
    case category = "category"
    case classs = "class"
    case service_provider = "service_provider"
}


enum CallStatus: String, Codable, CaseIterableDefaultsLast {
    case CALL_RINGING
    case CALL_ACCEPTED
    case CALL_CANCELED
}

enum CallType: String {
    case Incoming
    case Outgoing
}

enum CountryStateCity: String, Codable {
    case country
    case state
    case city
}

enum AppUpdateType: Int, Codable, CaseIterableDefaultsLast {
    case MajorUpdate = 2
    case MinorUpdate = 1
    case NoUpdate = 0
}

enum DynamicLinkPage: String {
    case userProfile
    case Invite
}

enum ListBy: String {
    case all
    case purchased
}

enum PackageType: String {
    case open
    case category
}

enum FeedType: String, CaseIterableDefaultsLast, Codable {
    case blog
    case article
    case na
    case faq
    
    var listingTitle: String {
        switch self {
        case .article:
            return VCLiteral.ARTICLES.localized
        case .blog:
            return VCLiteral.BlOGS.localized
        default:
            return ""
        }
    }
}
