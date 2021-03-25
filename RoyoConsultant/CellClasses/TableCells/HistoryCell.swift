//
//  HistoryCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 25/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell, ReusableCell {
    
    typealias T = DefaultCellModel<Payment>
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblExtraInfo: UILabel!
    
    var item: DefaultCellModel<Payment>? {
        didSet {
            let obj = item?.property?.model
            
            imgView.setImageNuke(/obj?.from?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
            lblName.text = /obj?.from?.name
            let transactionDate = Date.init(fromString: /obj?.created_at, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"), timeZone: .utc)
            lblDate.text = /transactionDate.toString(DateFormat.custom("MMM d yyyy · hh:mm a"))
            let amount = /obj?.amount?.getFormattedPrice()
            lblAmount.text = "\(obj?.type == .withdrawal ? "-" : "+")\(amount)"
            
            
            let minutes = (/obj?.call_duration % 3600) / 60
            let seconds = (/obj?.call_duration % 3600) % 60
            lblExtraInfo.text = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        }
    }
    
}
