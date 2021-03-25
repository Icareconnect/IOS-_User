//
//  HomeCareOptionCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 31/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class HomeCareOptionCell: UITableViewCell, ReusableCell {
    
    typealias T = DefaultCellModel<HCR_OptionModel>
    
    @IBOutlet weak var btnTick: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    var item: DefaultCellModel<HCR_OptionModel>? {
        didSet {
            lblTitle.text = /item?.property?.model?.option?.localized
            btnTick.isHidden = !(/item?.property?.model?.isSelected)
        }
    }
    
}
