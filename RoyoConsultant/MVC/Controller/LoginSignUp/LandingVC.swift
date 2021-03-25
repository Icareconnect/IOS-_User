//
//  LandingVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 11/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class LandingVC: BaseVC {
    
    @IBOutlet weak var lblFacebook: UILabel!
    @IBOutlet weak var lblGoogle: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblNewUser: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var viewNewUser: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Facebook
            break
        case 1: //Google
            break
        case 2: //Login using Email
            let destVC = Storyboard<LoginEmailVC>.LoginSignUp.instantiateVC()
            pushVC(destVC)
        case 3: //Login using Mobile Number
            let destVC = Storyboard<LoginMobileVC>.LoginSignUp.instantiateVC()
            destVC.providerType = .phone
            pushVC(destVC)
        case 4: //SignUp
            let destVC = Storyboard<SignUpVC>.LoginSignUp.instantiateVC()
            pushVC(destVC)
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension LandingVC {
    
    private func loginAPI(providerType: ProviderType, loginData: Any?) {
//        startAnimation()
//        EP_Login.login(provider_type: providerType, provider_id: nil, provider_verification: /loginData?.accessToken, user_type: .customer, country_code: nil).request(success: { [weak self] (response) in
//
//            self?.stopAnimation()
//            if /(response as? User)?.phone == "" {
//                let destVC = Storyboard<LoginMobileVC>.LoginSignUp.instantiateVC()
//                destVC.providerType = providerType
//                self?.pushVC(destVC)
//            } else {
//               UIWindow.replaceRootVC(Storyboard<NavgationTabVC>.TabBar.instantiateVC())
//            }
//        }) { [weak self] (error) in
//            self?.stopAnimation()
//        }
    }
    
    private func localizedTextSetup() {
        lblFacebook.text = VCLiteral.FACEBOOK.localized
        lblGoogle.text = VCLiteral.GOOGLE.localized
        lblEmail.text = VCLiteral.LOGIN_USING_EMAIL.localized
        lblMobileNumber.text = VCLiteral.LOGIN_USING_MOBILE.localized
        lblNewUser.text = VCLiteral.NEW_USER.localized
        btnSignUp.setTitle(VCLiteral.SIGNUP.localized, for: .normal)
    }
    
    
    private func startAnimation() {
        view.isUserInteractionEnabled = false
        lblNewUser.isHidden = true
        btnSignUp.isHidden = true
        dotsAnimationView.frame = CGRect.init(x: 0, y: -(128 - viewNewUser.bounds.height) / 2 , width: viewNewUser.bounds.width, height: 128)
        viewNewUser.addSubview(dotsAnimationView)
        dotsAnimationView.play()
    }
    
    private func stopAnimation() {
        dotsAnimationView.stop()
        dotsAnimationView.removeFromSuperview()
        view.isUserInteractionEnabled = true
        lblNewUser.isHidden = false
        btnSignUp.isHidden = false
    }
}
