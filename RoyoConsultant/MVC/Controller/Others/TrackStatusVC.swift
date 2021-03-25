//
//  TrackStatusVC.swift
//  RoyoConsultantVendor
//
//  Created by Chitresh Goyal on 24/12/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class TrackStatusVC: BaseVC {

    //MARK: - IBOutlets
    
    public var request: Requests?

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - IBActions
    @IBAction func actionClose(_ sender: Any) {
        dismissVC()
    }
    
}
