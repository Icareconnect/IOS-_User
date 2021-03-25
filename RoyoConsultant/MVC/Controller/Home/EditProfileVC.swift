//
//  EditProfileVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 25/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SZTextView

class EditProfileVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var tfName: JVFloatLabeledTextField!
    @IBOutlet weak var tfDOB: JVFloatLabeledTextField!
    @IBOutlet weak var tfEmail: JVFloatLabeledTextField!
    @IBOutlet weak var tvBio: SZTextView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnUpdate: SKLottieButton!
    @IBOutlet weak var lblBio: UILabel!

    @IBOutlet weak var lbCountryCode: UILabel!
    @IBOutlet weak var tfPhone: UITextField!
    
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwPhone: UIView!

    
    private var image_URL: String?
    private var dob: String?
    private var countryPicker: CountryManager?
    private var currentCountry: CountryISO?

    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        
        tfDOB.inputView = SKDatePicker.init(frame: .zero, mode: .date, maxDate: Date().dateBySubtractingMonths(5 * 12), minDate: nil, configureDate: { [weak self] (selectedDate) in
            self?.dob = selectedDate.toString(DateFormat.custom("yyyy-MM-dd"))
            self?.tfDOB.text = selectedDate.toString(DateFormat.custom("MMM d, yyyy"))
        })
        
        lbCountryCode.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(presentCountryPicker)))
        countryPicker = CountryManager()
        currentCountry = countryPicker?.currentCountry
        lbCountryCode.text = "\(/currentCountry?.ISO) +\(/currentCountry?.CC)"
        
        imgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectImage)))
    }

    override func viewWillAppear(_ animated: Bool) {
        initialDataSet()
    }
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Update
            updateProfileAPI()
        default:
            break
        }
    }
    
}

//MARK:- VCFuncs
extension EditProfileVC {
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.EDIT_PROFILE.localized
        tfName.placeholder = VCLiteral.NAME_PLACEHOLDER.localized
        tfDOB.placeholder = VCLiteral.DOB_PLACEHOLDER.localized
        tfEmail.placeholder = VCLiteral.EMAIL_PLACEHOLDER.localized
        lblBio.text = VCLiteral.BIO_PLACEHOLDER.localized
        btnUpdate.setTitle(VCLiteral.UPDATE.localized, for: .normal)
        
        switch UserPreference.shared.data?.provider_type ?? .phone {
        case .facebook, .google, .apple:
            tfEmail.isUserInteractionEnabled = false
        default:
            tfEmail.isUserInteractionEnabled = true
        }
    }
    
    private func initialDataSet() {
        let user = UserPreference.shared.data
        tfName.text = /user?.name
        tfEmail.text = /user?.email
        tfDOB.text = Date.init(fromString: /user?.profile?.dob, format: DateFormat.custom("yyyy-MM-dd")).toString(DateFormat.custom("MMM d, yyyy"), timeZone: .local)
        tvBio.text = /user?.profile?.bio
        lbCountryCode.text = user?.country_code ?? "\(/currentCountry?.ISO) +\(/currentCountry?.CC)"
        tfPhone.text = /user?.phone
        tvBio.text = /user?.profile?.bio
        imgView.setImageNuke(/user?.profile_image, placeHolder: nil)
        
        if UserPreference.shared.data?.provider_type == ProviderType.email {
            vwEmail.isHidden = true
        } else {
            vwPhone.isHidden = true
        }
    }
    
    @objc private func selectImage() {
        view.endEditing(true)
        mediaPicker.presentPicker({ [weak self] (image) in
            self?.imgView.image = image
            self?.uploadImageAPI()
            }, nil, nil)
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
    
    
    @objc private func presentCountryPicker() {
        countryPicker?.openCountryPicker({ [weak self] (country) in
            self?.currentCountry = country
            self?.lbCountryCode.text = "\(/self?.currentCountry?.ISO) +\(/self?.currentCountry?.CC)"
        })
    }
    
    private func updateProfileAPI() {
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        
        btnUpdate.playAnimation()
        EP_Login.profileUpdate(name: tfName.text, email: tfEmail.text, phone: /tfPhone.text, country_code: "+\(/currentCountry?.CC)", dob: nil, bio: nil, speciality: nil, call_price: nil, chat_price: nil, category_id: nil, experience: nil, profile_image: image_URL).request(success: { [weak self] (response) in
            self?.view.isUserInteractionEnabled = true
            self?.btnUpdate.stop()
            if /UserPreference.shared.clientDetail?.openAddressInsuranceScreen() {
                let destVC = Storyboard<AddressInsuranceVC>.LoginSignUp.instantiateVC()
                destVC.isUpdating = true
                self?.pushVC(destVC)
            } else {
                self?.popVC()
            }
        }) { [weak self] (error) in
            self?.view.isUserInteractionEnabled = true
            self?.btnUpdate.stop()
        }
    }
}
