//
//  VerificationPendingVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 11/09/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class VerificationPendingVC: BaseVC {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = VCLiteral.VERIFICATION_PENDING_TITLE.localized
        lblDesc.text = VCLiteral.VERIFICATION_PENDING_DESC.localized
    }
    
}
