//
//  AddressTVC.swift
//  RoyoConsultant
//
//  Created by Chitresh Goyal on 21/01/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit

class AddressTVC: UITableViewCell, ReusableCell {
    
    typealias T = DefaultCellModel<AddressModel>
    
    @IBOutlet weak var lblSaveAs: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblLocation: UILabel!

    var item: DefaultCellModel<AddressModel>? {
        didSet {
            let obj = item?.property?.model
            
            lblSaveAs.text = /obj?.save_as
            lblAddress.text = /obj?.address_name
            lblLocation.text = /obj?.house_no
            
//            lblTitle.text = /obj?.message
//            imgView.setImageNuke(/obj?.form_user?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
//            lblTitle.setAttributedText(original: (/obj?.message, Fonts.CamptonBook.ofSize(14.0), ColorAsset.txtMoreDark.color), toReplace: (/obj?.form_user?.name, Fonts.CamptonSemiBold.ofSize(14.0), ColorAsset.txtMoreDark.color))
//            lblTime.text = /Date.init(timeIntervalSince1970: /obj?.sentAt / 1000.0).relativeTimeToString()
        }
    }

}
