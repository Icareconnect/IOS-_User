//
//  ReviewCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell, ReusableCell {
    
    typealias T = VD_Cell_Provider

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    
    var item: VD_Cell_Provider? {
        didSet {
            let review = item?.property?.model?.review
            imgView.setImageNuke(/review?.user?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
            lblName.text = /review?.user?.name?.capitalizingFirstLetter()
            lblReview.text = /review?.comment
            lblRating.text = String(/review?.rating)
        }
    }
    

}
