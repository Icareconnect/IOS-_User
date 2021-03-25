//
//  AllocatedNursePopUpVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 15/09/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class AllocatedNursePopUpVC: BaseVC {
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnOK: SKLottieButton!
    
    var vendor: User?
    var didClosePopUp: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.unhideVisualEffectView()
        }
    }
    
    @IBAction func btnAction(_ sender: SKLottieButton) {
        hideVisulEffectView()
    }
    
}

//MARK:- VCFuncs
extension AllocatedNursePopUpVC {
    private func localizedTextSetup() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = true
        lblTitle.text = VCLiteral.ALLOCATED_NURSE.localized
        btnOK.setTitle(VCLiteral.OK.localized, for: .normal)
        lblName.text = /vendor?.name?.capitalizingFirstLetter()
        imgView.setImageNuke(/vendor?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
    }
    
    private func unhideVisualEffectView() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.visualEffectView.alpha = 1.0
        }
    }
    
    private func hideVisulEffectView() {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.visualEffectView.alpha = 0.0
        }) { [weak self] (finished) in
            self?.visualEffectView.isHidden = true
            self?.dismiss(animated: true, completion: {
                self?.didClosePopUp?()
            })
        }
    }
}
