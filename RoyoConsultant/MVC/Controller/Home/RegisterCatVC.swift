//
//  RegisterCatVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 31/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

enum RequestingService: Int {
    case _Self = 0
    case Father = 1
    case Mother = 2
    case Child = 3
    case Other = 4
    
    var backendValue: String {
        switch self {
        case ._Self:
            return "Self"
        case .Father:
            return "Father"
        case .Mother:
            return "Mother"
        case .Child:
            return "Child"
        case .Other:
            return "Other"
        }
    }
}

enum HCR_Option: String {
    case HCR_Option_1
    case HCR_Option_2
    case HCR_Option_3
    case HCR_Option_4
    case HCR_Option_5
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

class HCR_OptionModel {
    var option: HCR_Option?
    var isSelected: Bool?
    
    class func getArray() -> [HCR_OptionModel] {
        return [HCR_OptionModel(.HCR_Option_1),
                HCR_OptionModel(.HCR_Option_2),
                HCR_OptionModel(.HCR_Option_3),
                HCR_OptionModel(.HCR_Option_4),
                HCR_OptionModel(.HCR_Option_5)]
    }
    
    init(_ _option: HCR_Option) {
        option = _option
    }
}

class RegisterCatVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitleDes: UILabel!
    @IBOutlet weak var viewWhite: UIView! {
        didSet {
            viewWhite.roundCorners(with: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 24)
        }
    }
    @IBOutlet weak var tfFullName: JVFloatLabeledTextField!
    @IBOutlet weak var lblRequestingFor: UILabel!
    @IBOutlet var viewDot: [UIView]!
    @IBOutlet var lblRequestingForArray: [UILabel]!
    @IBOutlet weak var lblifServieNotSelf: UILabel!
    @IBOutlet weak var tfOtherFullName: JVFloatLabeledTextField!
    @IBOutlet weak var viewOtherInfo: UIView!
    @IBOutlet weak var lblHomeCareTitle: UILabel!
    @IBOutlet weak var lblHomeCareType: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tfAddress: JVFloatLabeledTextField!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnContinue: SKLottieButton!
    @IBOutlet weak var viewHomeCareOptions: UIView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var tfMobileNumber: UITextField!
    
    
    private var requestingType: RequestingService = ._Self
    private var homeCareOptions = HCR_OptionModel.getArray()
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<HCR_OptionModel>, DefaultCellModel<HCR_OptionModel>, HCR_OptionModel>?
    private var address: LocationManagerData?
    private var isTermsSelected = false
    public var filter: FilterOption?
    public var interMediateData = RegisterCatModel()
    var selectedServices: String?
    private var categories = [FilterOption]()
    private var countryPicker: CountryManager?
    private var currentCountry: CountryISO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategoriesAPI()
        localizedTextSetup()
        initialSetup()
        tfAddress.addTarget(self, action: #selector(didAddressTapped(tf:)), for: .allEditingEvents)
    }
    
    @IBAction func btnRequestingForAction(_ sender: UIButton) {
        requestingType = RequestingService(rawValue: sender.tag) ?? ._Self
        viewDot.forEach({$0.isHidden = true})
        viewDot[requestingType.rawValue].isHidden = false
        viewOtherInfo.isHidden = requestingType == ._Self
        tfOtherFullName.placeholder = requestingType == ._Self ? VCLiteral.FULL_NAME.localized : "\(requestingType.backendValue)'s \(VCLiteral.FULL_NAME.localized )"
    }
    
    @IBAction func btnHomeCareAction(_ sender: UIButton) {
        viewHomeCareOptions.isHidden = !(viewHomeCareOptions.isHidden)
    }
    
    @IBAction func btnTermsAction(_ sender: UIButton) {
        isTermsSelected = !isTermsSelected
        toggleTerms()
    }
    @IBAction func actionBack(_ sender: UIButton) {
        popVC()
    }
    
    @IBAction func btnContinueAction(_ sender: SKLottieButton) {
        if requestingType != ._Self && /tfOtherFullName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.OTHER_SERVICE_FULL_NAME_ALERT.localized)
            return
        }
        else if requestingType != ._Self && /tfMobileNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" && /Int(/tfMobileNumber.text?.count) < 7 {
            Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.OTHER_SERVICE_MOBILE_ALERT.localized)
            return
        }
        //        else if homeCareOptions.filter({/$0.isSelected}).count == 0 {
        //            Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.HCR_ALERT.localized)
        //            return
        //        }
        else if /tfAddress.text == "" {
            Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.ADDRESS_ALERT.localized)
            return
        }
        //        else if isTermsSelected == false {
        //            Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.REGSITER_CAT_TERMS_ALERT.localized)
        //            return
        //        }
        interMediateData.name = requestingType == ._Self ? tfFullName.text : tfOtherFullName.text
        interMediateData.requestingFor = requestingType.backendValue
        interMediateData.otherName = tfOtherFullName.text
        interMediateData.hcr = homeCareOptions.filter({/$0.isSelected})
        interMediateData.address = address
        interMediateData.filterOption = filter
        interMediateData.selectedServices = selectedServices
        interMediateData.phone_number = requestingType != ._Self ? /tfMobileNumber.text : UserPreference.shared.data?.phone
        interMediateData.country_code = requestingType != ._Self ? /lblCountryCode.text : UserPreference.shared.data?.country_code
        
        let destVC = Storyboard<RegisterNurseVC>.Home.instantiateVC()
        destVC.interMediateData = interMediateData
        pushVC(destVC)
    }
}

//MARK:- VCFuncs
extension RegisterCatVC {
    private func toggleTerms() {
        btnTerms.backgroundColor = isTermsSelected ? ColorAsset.appTint.color : UIColor.clear
        btnTerms.setImage(isTermsSelected ? #imageLiteral(resourceName: "ic_tick") : nil, for: .normal)
    }
    
    @objc func didAddressTapped(tf: JVFloatLabeledTextField) {
        tf.resignFirstResponder()
        self.view.endEditing(true)
        
        let destVC = Storyboard<AddressListVC>.PopUp.instantiateVC()
        
        destVC.didSelected = { [weak self] (address) in
            tf.text = /address?.locationName
            self?.address = address
        }
        destVC.addNewAddress = { [weak self] in
            
            self?.view.endEditing(true)
            let destVC = Storyboard<AddAddressVC>.Home.instantiateVC()
            destVC.address = self?.address
            destVC.didSelected = { [weak self] (address) in
                tf.text = /address?.locationName
                self?.address = address
            }
            self?.pushVC(destVC)
        }
        presentVC(destVC)
        
    }
    
    private func initialSetup() {
        lblCountryCode.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(presentCountryPicker)))
        countryPicker = CountryManager()
        currentCountry = countryPicker?.currentCountry
        lblCountryCode.text = "\(/currentCountry?.ISO) +\(/currentCountry?.CC)"
    }
    
    @objc private func presentCountryPicker() {
        countryPicker?.openCountryPicker({ [weak self] (country) in
            self?.currentCountry = country
            self?.lblCountryCode.text = "\(/self?.currentCountry?.ISO) +\(/self?.currentCountry?.CC)"
        })
    }
    
    private func localizedTextSetup() {
        tfFullName.text = /UserPreference.shared.data?.name
        lblTitle.text = VCLiteral.APPOINTMENT_DETAILS.localized
        lblTitleDes.text = ""//VCLiteral.REGISTER_DESC.localized
        tfFullName.placeholder = VCLiteral.FULL_NAME.localized
        tfOtherFullName.placeholder = VCLiteral.FULL_NAME.localized
        lblRequestingForArray[0].text = VCLiteral.SELF.localized
        lblRequestingForArray[1].text = VCLiteral.FATHER.localized
        lblRequestingForArray[2].text = VCLiteral.MOTHER.localized
        lblRequestingForArray[3].text = VCLiteral.CHILD.localized
        lblRequestingForArray[4].text = VCLiteral.OTHER.localized
        lblifServieNotSelf.text = VCLiteral.IF_SERVICE_NOT_SELF.localized
        lblHomeCareTitle.text = VCLiteral.HOME_CARE_REQUIREMENT.localized
        lblHomeCareType.text = VCLiteral.CHOOSE_HOME_CARE.localized
        tfAddress.placeholder = VCLiteral.SERVICE_ADDRESS.localized
        lblTerms.text = VCLiteral.TERMS_INTELLGENT_MEMBER.localized
        btnContinue.setTitle(VCLiteral.CONTINUE.localized, for: .normal)
        viewDot.forEach({$0.isHidden = true})
        viewDot.first?.isHidden = false
        viewOtherInfo.isHidden = true
        viewHomeCareOptions.isHidden = true
        toggleTerms()
        
        tfMobileNumber.placeholder = VCLiteral.MOBILE_PACEHOLDER.localized
        
    }
    
    private func configureOptions() {
        dataSource = TableDataSource<DefaultHeaderFooterModel<HCR_OptionModel>, DefaultCellModel<HCR_OptionModel>, HCR_OptionModel>.init(.SingleListing(items: homeCareOptions, identifier: HomeCareOptionCell.identfier, height: UITableView.automaticDimension, leadingSwipe: nil, trailingSwipe: nil), tableView)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? HomeCareOptionCell)?.item = item
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            self?.homeCareOptions[indexPath.row].isSelected = !(/item?.property?.model?.isSelected)
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.homeCareOptions ?? []), .Reload(indexPaths: [indexPath], animation: .automatic))
            let selectedCount = /self?.homeCareOptions.filter({$0.isSelected == true}).count
            self?.lblHomeCareType.text = selectedCount == 0 ? VCLiteral.CHOOSE_HOME_CARE.localized : String.init(format: VCLiteral.HOME_CARE_SELECTED.localized, "\(selectedCount)")
        }
    }
    
    private func getCategoriesAPI() {
        EP_Home.getFilters(categoryId: UserPreference.shared.staticCategoryId, duties: /selectedServices).request(success: { [weak self] (responseData) in
            self?.categories = (responseData as? FilterData)?.filters?.first?.options ?? []
            
            self?.lblHomeCareType.text = (self?.categories.map({ /$0.option_name }))?.joined(separator: ", ")
            
        }) { [weak self] (error) in
            self?.stopLineAnimation()
        }
    }
}

extension RegisterCatVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == tfAddress {
            
            let destVC = Storyboard<AddressListVC>.PopUp.instantiateVC()
            destVC.modalPresentationStyle = .fullScreen
            
            destVC.didSelected = { [weak self] (address) in
                self?.tfAddress.text = /address?.locationName
                self?.address = address
            }
            destVC.addNewAddress = { [weak self] in
                
                let destVC = Storyboard<AddAddressVC>.Home.instantiateVC()
                
                destVC.address = self?.address
                destVC.didSelected = { [weak self] (address) in
                    //                    self?.tfAddress.text = /address?.locationName
                    //                    self?.address = address
                    
                    let destVC = Storyboard<AddressListVC>.PopUp.instantiateVC()
                    destVC.modalPresentationStyle = .fullScreen
                    
                    destVC.didSelected = { [weak self] (address) in
                        self?.tfAddress.text = /address?.locationName
                        self?.address = address
                    }
                    self?.presentVC(destVC)
                    
                }
                self?.pushVC(destVC)
            }
            presentVC(destVC)
        }
        return textField == tfAddress ? false : true
    }
}
