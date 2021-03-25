//
//  SubCategoryCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 16/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class SubCategoryCell: UICollectionViewCell, ReusableCellCollection {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backView: UIView!
    
    var imageSize: CGSize?

    var item: Any? {
        didSet {
            let obj = item as? Category
            
            lblTitle.text = /obj?.name
            backView.backgroundColor = UIColor.init(hex: /obj?.color_code?.lowercased())
            imgView.setCategoryImage(imageOrURL: /obj?.image, size: imageSize ?? CGSize.zero)
        }
    }
}
