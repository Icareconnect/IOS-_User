//
//  CategoryCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 31/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell, ReusableCell {
    
    typealias T = DefaultCellModel<FilterOption>
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var item: DefaultCellModel<FilterOption>? {
        didSet {
            lblTitle.text = /item?.property?.model?.option_name
        }
    }
}
