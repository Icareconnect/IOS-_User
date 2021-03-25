//
//  AvailabilityModels.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 31/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

enum AvailabilityDataType {
    case WhileLoginModule
    case WhileManaging
    case WhileInCompleteSetup

    var addAvailabilityTitle: VCLiteral {
        switch self {
        case .WhileLoginModule:
            return .ADD_AVAILABILITY
        case .WhileManaging:
            return .MANAGE_AVAILABILITY
        default:
            return .MANAGE_AVAILABILITY
        }
    }
}
