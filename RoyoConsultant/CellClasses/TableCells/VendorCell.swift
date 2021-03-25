//
//  VendorCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class VendorCell: UITableViewCell, ReusableCell {
    
    typealias T = DefaultCellModel<Vendor>
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblFilters: UILabel!
    
    var item: DefaultCellModel<Vendor>? {
        didSet {
            let obj = item?.property?.model?.vendor_data
            imgView.setImageNuke(/obj?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
            lblName.text = /obj?.name
//            let price = Double(/obj?.price).getFormattedPrice() + getUnit(/Int(/obj?.unit_price))

            let experience = "Exp · " + /obj?.custom_fields?.first(where: {/$0.field_name == "Work experience"})?.field_value
            var desc = [experience]
            
            desc.removeAll(where: {/$0 == ""})
            
            lblDesc.text = desc.joined(separator: " \n")
            lblRating.text = /obj?.profile?.location?.name
            
            if let filters = obj?.filters, filters.count > 0 {
                if let options = filters[0].options {
                    let filterTitle = (options.filter({ /$0.isSelected }).compactMap( { $0.option_name } ))

                    lblFilters.text = filterTitle.joined(separator: ", ")
                }
            }
        }
    }
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
