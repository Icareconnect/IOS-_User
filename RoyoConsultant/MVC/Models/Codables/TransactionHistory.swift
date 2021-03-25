//
//  TransactionHistory.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class TransactionData: Codable {
    var payments: [Payment]?
    var after: String?
    var before: String?
    var per_page: Int?
}

class Payment: Codable {
    var id: Int?
    var from: User?
    var to: User?
    var transaction_id: Int?
    var created_at: String?
    var updated_at: String?
    var call_duration: Int?
    var service_type: ServiceType?
    var amount: Double?
    var type: TransactionType?
    var status: String?
    var closing_balance: Double?
}

class WalletBalance: Codable {
    var balance: Double?
}

class CardsData: Codable {
    var cards: [PaymentCard]?
}

class PaymentCard: Codable {
    var id: Int?
    var card_brand: String?
    var last_four_digit: String?
    var created_at: String?
    var is_default: CustomBool?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case card_brand
        case last_four_digit
        case created_at
        case is_default = "default"
    }
}

class CreateRequestData: Codable {
    var amountNotSufficient: Bool?
}
