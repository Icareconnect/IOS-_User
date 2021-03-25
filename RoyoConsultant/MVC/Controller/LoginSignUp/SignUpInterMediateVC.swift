//
//  SignUpInterMediateVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class SignUpInterMediateVC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfName: JVFloatLabeledTextField!
    @IBOutlet weak var tfEmail: JVFloatLabeledTextField!
    @IBOutlet weak var imgView: UIImageView!
    
    private var image_URL: String?
    
    public var isViaAppleSignUp: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        nextBtnAccessory.didTapContinue = { [weak self] in
            let btn = UIButton()
            btn.tag = 1
            self?.btnAction(btn)
        }
        
        tfResponder = TFResponder()
        tfResponder?.addResponders([.TF(tfName), .TF(tfEmail)])
        
        imgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectImage)))

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
        case 1: //Next
            switch Validation.shared.validate(values: (ValidationType.NAME, /tfName.text)) {
            case .success:
                updateProfileAPI()
            case .failure(let alertType, let message):
                Toast.shared.showAlert(type: alertType, message: message.localized)
            }
//            switch Validation.shared.validate(values: (ValidationType.NAME, /tfName.text), (ValidationType.DOB, /tfDOB.text), (ValidationType.EMAIL, /tfEmail.text), (ValidationType.BIO, tvBio.text.trimmingCharacters(in: .whitespacesAndNewlines))) {
//            case .success:
//                updateProfileAPI()
//            case .failure(let alertType, let message):
//                Toast.shared.showAlert(type: alertType, message: message.localized)
//            }
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension SignUpInterMediateVC {
    
    @objc private func selectImage() {
        view.endEditing(true)
        mediaPicker.presentPicker({ [weak self] (image) in
            self?.imgView.image = image
            self?.uploadImageAPI()
            }, nil, nil)
    }
    
    private func updateProfileAPI() {
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        nextBtnAccessory.startAnimation()
        EP_Login.profileUpdate(name: tfName.text, email: tfEmail.text, phone: nil, country_code: nil, dob: nil, bio: nil, speciality: nil, call_price: nil, chat_price: nil, category_id: nil, experience: nil, profile_image: image_URL).request(success: { [weak self] (response) in
            self?.view.isUserInteractionEnabled = true
            self?.nextBtnAccessory.stopAnimation()
            
            let destVC = Storyboard<WorkEnvironmentVC>.LoginSignUp.instantiateVC()
            self?.pushVC(destVC)

        }) { [weak self] (error) in
            self?.view.isUserInteractionEnabled = true
            self?.nextBtnAccessory.stopAnimation()
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
        
//        if /isViaAppleSignUp {
//            tfName.text = /UserPreference.shared.appleData?.name
//            tfEmail.text = /UserPreference.shared.appleData?.email
//            tfEmail.isUserInteractionEnabled = /UserPreference.shared.appleData?.email == ""
//        }
    }
}
