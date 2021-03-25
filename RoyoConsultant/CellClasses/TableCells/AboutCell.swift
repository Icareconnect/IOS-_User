//
//  AboutCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class AboutCell: UITableViewCell, ReusableCell {
    
    typealias T = VD_Cell_Provider

    @IBOutlet weak var lblDesc: UILabel!
    
    var item: VD_Cell_Provider? {
        didSet {
            lblDesc.text = /item?.property?.model?.about
        }
    }

}
