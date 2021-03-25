//
//  Colors.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

enum ColorAsset: String {
    case appTint
    case appTintExtraLight
    case backgroundColor
    case backgroundDullWhite
    case backgroundCell
    case btnBackWhite
    case btnBorder
    case textFieldTint
    case txtDark
    case txtGrey
    case txtLightGrey
    case txtTheme
    case txtExtraLight
    case txtWhite
    case txtMoreDark
    case btnWhiteTint
    case btnDarkTint
    case shadow
    case bannerBack
    case activityIndicator
    
    case requestCall
    case requestChat
    case requestHome
    case requestStatusAccept
    case requestStatusCompleted
    case requestStatusFailed
    case requestStatusInProgress
    case requestStatusPending
    case requestStatusNoAnswer
    case requestStatusBusy
    
    var color: UIColor {
        return UIColor.init(named: self.rawValue) ?? UIColor()
    }
}
