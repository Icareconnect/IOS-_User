//
//  LoginEmailVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 11/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class LoginEmailVC: BaseVC {
    
    @IBOutlet weak var lblLoginEmail: UILabel!
    @IBOutlet weak var lblLoginDesc: UILabel!
    @IBOutlet weak var tfEmail: JVFloatLabeledTextField!
    @IBOutlet weak var tfPassword: JVFloatLabeledTextField!
    @IBOutlet weak var btnForgotPsw: UIButton!
    @IBOutlet weak var btnTermsAccept: UIButton!
    
    @IBOutlet weak var vwTerms: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        nextBtnAccessory.didTapContinue = { [weak self] in
            let btn = UIButton.init()
            btn.tag = 3
            self?.btnAction(btn)
        }
        tfResponder = TFResponder()
        tfResponder?.addResponders([TVTF.TF(tfEmail), TVTF.TF(tfPassword)])
        
        tfEmail.becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return nextBtnAccessory
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Forgot Password
            let alert = UIAlertController.init(title: VCLiteral.FORGOT_PASSWORD.localized, message: VCLiteral.FORGOT_PSW_MESSAGE.localized, preferredStyle: .alert)
            alert.addTextField { (tf) in
                tf.placeholder = VCLiteral.EMAIL_PLACEHOLDER.localized
            }
            alert.addAction(UIAlertAction.init(title: VCLiteral.CANCEL.localized, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction.init(title: VCLiteral.OK.localized, style: .default, handler: { [weak self] (_) in
                self?.forgotPswAPI(email: alert.textFields?.first?.text)
            }))
            presentVC(alert)
        case 2: //SignUp
            break
        case 3: //Next
            switch Validation.shared.validate(values: (.EMAIL, /tfEmail.text), (.PASSWORD, /tfPassword.text)) {
            case .success:
                view.endEditing(true)
                loginAPI()
            case .failure(let alertType, let message):
                Toast.shared.showAlert(type: alertType, message: message.localized)
            }
        case 4:
            popVC(animated: false)
        case 5: //ACCEPT Terms
            btnTermsAccept.isSelected = !btnTermsAccept.isSelected
        case 6: //Privacy Policy
            let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
            destVC.linkTitle = (Configuration.getValue(for: .ROYO_CONSULTANT_BASE_PATH) + APIConstants.privacyPolicy, VCLiteral.PRIVACY.localized)
            pushVC(destVC)
        default:
            break
        }
    }
    
}

//MARK:- VCFuncs
extension LoginEmailVC {
    
    private func forgotPswAPI(email: String?) {
        nextBtnAccessory.startAnimation()
        EP_Login.forgotPsw(email: email).request(success: { [weak self] (response) in
            self?.nextBtnAccessory.stopAnimation()
            Toast.shared.showAlert(type: .success, message: VCLiteral.PASSWORD_RESET_MESSAGE.localized)
        }) { [weak self] (_) in
            self?.nextBtnAccessory.stopAnimation()
        }
    }
    
    private func loginAPI() {
        nextBtnAccessory.startAnimation()
        view.isUserInteractionEnabled = false
        EP_Login.login(provider_type: .email, provider_id: /tfEmail.text, provider_verification: tfPassword.text, user_type: .customer, country_code: nil).request(success: { [weak self] (responseData) in
            self?.nextBtnAccessory.stopAnimation()
            self?.view.isUserInteractionEnabled = true
//            if /(responseData as? User)?.phone == "" {
//                let destVC = Storyboard<LoginMobileVC>.LoginSignUp.instantiateVC()
//                destVC.providerType = .email
//                self?.pushVC(destVC)
//            } else {
                UIWindow.replaceRootVC(Storyboard<NavgationTabVC>.TabBar.instantiateVC())
//            }
        }) { [weak self] (error) in
            self?.nextBtnAccessory.stopAnimation()
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    private func localizedTextSetup() {
        lblLoginEmail.text = VCLiteral.LOGIN_USING_EMAIL.localized
        lblLoginDesc.text = ""
        tfEmail.placeholder = VCLiteral.EMAIL_PLACEHOLDER.localized
        tfPassword.placeholder = VCLiteral.PSW_PLACEHOLDER.localized
        btnForgotPsw.setTitle(VCLiteral.FORGOT_PASSWORD.localized, for: .normal)
    }
}
