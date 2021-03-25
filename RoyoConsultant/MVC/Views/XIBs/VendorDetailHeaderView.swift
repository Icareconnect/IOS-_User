//
//  VendorDetailHeaderView.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class VendorDetailHeaderView: UITableViewHeaderFooterView, ReusableHeaderFooter {
    
    typealias T = VD_HeaderFooter_Provider
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var viewRating: UIView!
    
    var item: VD_HeaderFooter_Provider? {
        didSet {
            lblTitle.text = /item?.headerProperty?.model?.title
            lblRating.text = String(/item?.headerProperty?.model?.rating)
            viewRating.isHidden = item?.headerProperty?.model?.rating == nil
        }
    }
    
}
