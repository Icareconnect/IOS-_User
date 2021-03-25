//
//  LoginPopUpVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 14/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
enum CallBackType {
    case DEFAULT
    case BUTTON_TAPPED
    case TERMS_TAPPED
    case PRIVACY_TAPPED
    case EMAIL_SIGNUP
}

class LoginPopUpVC: BaseVC {
    

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSignUpText: UILabel!
    @IBOutlet weak var lblContinueToAgree: UILabel!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var lblAlreadyAccount: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var viewForLottie: UIView!
    @IBOutlet weak var lblSignUpWithEmail: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    
    public var didDismiss: ((_ provider: ProviderType?, _ callBackType: CallBackType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        
        case 0: //Back
            popVC()
        case 1: //SignUp Phone number
            
            let destVC = Storyboard<LoginMobileVC>.LoginSignUp.instantiateVC()
            destVC.providerType = .email
            UIApplication.topVC()?.pushVC(destVC)
        case 2: //Sign Up with Email
            
            let destVC = Storyboard<SignUpVC>.LoginSignUp.instantiateVC()
            UIApplication.topVC()?.pushVC(destVC)
        case 4: //Terms of service
            let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
            destVC.linkTitle = (Configuration.getValue(for: .ROYO_CONSULTANT_BASE_PATH) + APIConstants.termsConditions, VCLiteral.TERMS_AND_CONDITIONS.localized)
            UIApplication.topVC()?.pushVC(destVC)
        case 5: //Privacy policy
            let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
            destVC.linkTitle = (Configuration.getValue(for: .ROYO_CONSULTANT_BASE_PATH) + APIConstants.privacyPolicy, VCLiteral.PRIVACY.localized)
            UIApplication.topVC()?.pushVC(destVC)
        case 6: //Login
            let destVC = Storyboard<LoginMobileVC>.LoginSignUp.instantiateVC()
            destVC.providerType = .phone
            UIApplication.topVC()?.pushVC(destVC)
        default:
            break
        }
    }
    
}

//MARK:- VCFuncs
extension LoginPopUpVC {
    
    private func loginAPI(providerType: ProviderType, loginData: Any?, callBack: CallBackType) {
        startAnimation()
        EP_Login.login(provider_type: providerType, provider_id: nil, provider_verification: nil, user_type: .customer, country_code: nil).request(success: { [weak self] (response) in
            self?.stopAnimation()

        }) { [weak self] (error) in
            self?.stopAnimation()
        }
    }
    
    
    private func startAnimation() {
        view.isUserInteractionEnabled = false
        lineAnimation.removeFromSuperview()
        let width = UIScreen.main.bounds.width
        let height = width * (5 / 450)
        lineAnimation.frame = CGRect.init(x: 0, y: 0, width: width, height: height - 2.0)
        viewForLottie.addSubview(lineAnimation)
        lineAnimation.clipsToBounds = true
        lineAnimation.play()
    }
    
    private func stopAnimation() {
        lineAnimation.stop()
        lineAnimation.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
    
    private func localizedTextSetup() {
        
        let titleString = String.init(format: VCLiteral.YOU_NEED_ACCOUNT.localized, VCLiteral.APP_TITLE_PREFIX.localized)
        lblTitle.text = titleString
//        lblTitle.setAttributedText(original: (titleString, Fonts.CamptonSemiBold.ofSize(16), ColorAsset.txtMoreDark.color), toReplace: (VCLiteral.APP_TITLE_SUFFIX.localized, Fonts.CamptonSemiBold.ofSize(16), ColorAsset.appTint.color))
        lblSignUpText.text = VCLiteral.SIGNUP_USING_MOBILE.localized
        lblContinueToAgree.text = VCLiteral.BY_CONTINUE.localized
        btnTerms.setTitle(VCLiteral.TERMS.localized, for: .normal)
        lblAlreadyAccount.text = VCLiteral.ALREADY_ACCOUNT.localized
        btnLogin.setTitle(VCLiteral.LOGIN.localized, for: .normal)
        lblSignUpWithEmail.text = VCLiteral.SIGN_UP_WITH_EMAIL.localized
        lblOr.text = VCLiteral.OR.localized
    }
    
}
