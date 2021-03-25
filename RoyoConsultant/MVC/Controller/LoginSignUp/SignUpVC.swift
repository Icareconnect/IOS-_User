//
//  SignUpVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 11/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class SignUpVC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPsw: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var lblAlreadyRegister: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblBySigningUp: UILabel!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewLottie: UIView!
    
    private var image_URL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tfResponder = TFResponder.init()
        tfResponder?.addResponders([.TF(tfName), .TF(tfEmail), .TF(tfPsw)])
        localizedTextSetup()
        
        imgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectImage)))

    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC(animated: false)
        case 1: //Login
            let destVC = Storyboard<LoginMobileVC>.LoginSignUp.instantiateVC()
            destVC.providerType = .phone
            pushVC(destVC)
        case 2: //Next
            view.endEditing(true)
            switch Validation.shared.validate(values: (.NAME, /tfName.text), (.EMAIL, /tfEmail.text), (.PASSWORD, /tfPsw.text)) {
            case .success:
                if !btnAccept.isSelected {
                    Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.REGSITER_CAT_TERMS_ALERT.localized)

                } else {
                    registerAPI()
                }
            case .failure(let alertType, let meessage):
                Toast.shared.showAlert(type: alertType, message: meessage.localized)
            }
        case 3: //Terms of Service
            let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
            destVC.linkTitle = (Configuration.getValue(for: .ROYO_CONSULTANT_BASE_PATH) + APIConstants.termsConditions, VCLiteral.TERMS_AND_CONDITIONS.localized)
            pushVC(destVC)
        case 4: //Privacy Policy
            let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
            destVC.linkTitle = (Configuration.getValue(for: .ROYO_CONSULTANT_BASE_PATH) + APIConstants.privacyPolicy, VCLiteral.PRIVACY.localized)
            pushVC(destVC)
        case 5:
            btnAccept.isSelected = !btnAccept.isSelected
        default:
            break
        }
    }
    
}

//MARK:- VCFuncs
extension SignUpVC {
    
    @objc private func selectImage() {
        view.endEditing(true)
        mediaPicker.presentPicker({ [weak self] (image) in
            self?.imgView.image = image
            self?.uploadImageAPI()
            }, nil, nil)
    }
    
    private func registerAPI() {
        startAnimation()
        /*
         
         EP_Login.register(name: /tfName.text, email: /tfEmail.text, password: /tfPsw.text, phone: nil, code: nil, user_type: .customer, fcm_id: nil, country_code: nil, dob: nil, bio: nil, profile_image: /image_URL).request(success: { [weak self] (response) in
         self?.stopAnimation()
         //            if /(response as? User)?.phone == "" {
         let destVC = Storyboard<WorkEnvironmentVC>.LoginSignUp.instantiateVC()
         //                destVC.providerType = .email
         self?.pushVC(destVC)
         //            } else {
         //                UIWindow.replaceRootVC(Storyboard<NavgationTabVC>.TabBar.instantiateVC())
         //            }
         }) { [weak self] (error) in
         self?.stopAnimation()
         }*/
        EP_Login.sendEmailOTP(email: /tfEmail.text).request(success: { [weak self] (response) in
            self?.stopAnimation()
            
            let destVC = Storyboard<VerificationVC>.LoginSignUp.instantiateVC()
            destVC.providerType = .email
            destVC.email = /self?.tfEmail.text
            destVC.password = /self?.tfPsw.text
            destVC.image = /self?.image_URL
            destVC.name = /self?.tfName.text
            self?.pushVC(destVC)

        }) { [weak self] (error) in
            self?.stopAnimation()
        }
    }
    
    private func uploadImageAPI() {
        playUploadAnimation(on: imgView)
        EP_Home.uploadImage(image: (imgView.image)!).request(success: { [weak self] (responseData) in
            self?.stopUploadAnimation()
            self?.image_URL = (responseData as? ImageUploadData)?.image_name
        }) { [weak self] (error) in
            self?.stopUploadAnimation()
            self?.alertBox(title: VCLiteral.UPLOAD_ERROR.localized, message: error, btn1: VCLiteral.CANCEL.localized, btn2: VCLiteral.RETRY.localized, tapped1: {
                self?.imgView.image = nil
            }, tapped2: {
                self?.uploadImageAPI()
            })
        }
    }
    
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.SIGNUP.localized
        tfName.placeholder = VCLiteral.NAME_PLACEHOLDER.localized
        tfEmail.placeholder = VCLiteral.EMAIL_PLACEHOLDER.localized
        tfPsw.placeholder = VCLiteral.PSW_PLACEHOLDER.localized
        lblAlreadyRegister.text =  VCLiteral.ALREADY_REGISTER.localized
        btnLogin.setTitle(VCLiteral.LOGIN.localized, for: .normal)
        lblBySigningUp.text = VCLiteral.BY_SIGNING_UP.localized
        btnTerms.setTitle(VCLiteral.TERMS.localized, for: .normal)
        btnTerms.setTitle(VCLiteral.TERMS.localized, for: .normal)
        btnAccept.setTitle(VCLiteral.TERMS_AGREED.localized, for: .normal)

    }
    
    private func startAnimation() {
        view.isUserInteractionEnabled = false
        lblAlreadyRegister.isHidden = true
        btnLogin.isHidden = true
        btnNext.isHidden = true
        dotsAnimationView.frame = viewLottie.bounds
        viewLottie.addSubview(dotsAnimationView)
        viewLottie.isHidden = false
        dotsAnimationView.play()
    }
    
    private func stopAnimation() {
        dotsAnimationView.stop()
        dotsAnimationView.removeFromSuperview()
        view.isUserInteractionEnabled = true
        viewLottie.isHidden = true

        lblAlreadyRegister.isHidden = false
        btnLogin.isHidden = false
        btnNext.isHidden = false
    }
}
