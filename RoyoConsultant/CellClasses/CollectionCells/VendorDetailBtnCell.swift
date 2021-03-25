//
//  VendorDetailBtnCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class VendorDetailBtnCell: UICollectionViewCell, ReusableCellCollection {
        
    @IBOutlet weak var lblTItle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPerUnit: UILabel!
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var backView: UIView!
    
    var item: Any? {
        didSet {
            let obj = item as? Service
            lblTItle.text = /obj?.service_name?.capitalizingFirstLetter()
            lblPrice.text = /obj?.price?.getFormattedPrice()
            backView.backgroundColor = UIColor.init(hex: /obj?.color_code)
            lblPerUnit.text = getUnit(/Int(/obj?.unit_price))
        }
    }
    
    
//    func getUnit(_ seconds: Int) -> String {
//        if seconds == 60 {
//            return "/minute"
//        } else if seconds == 1 {
//            return "/second"
//        } else if seconds < 60 {
//            return "/ \(seconds) seconds"
//        } else {
//            return "/ \(seconds / 60) minute"
//        }
//    }
    
    
    func getUnit(_ seconds: Int) -> String {
        if seconds == 60 {
            return "/minute"
        } else if seconds == 1 {
            return "/second"
        } else if seconds < 60 {
            return "/ \(seconds) seconds"
        } else if seconds >= 3600 {
            return "/ \(seconds / 3600) hour"
        } else {
            return "/ \(seconds / 60) minute"
        }
    }
}
