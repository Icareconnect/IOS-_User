//
//  HomeVC_Tab1HomeVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 14/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//
import CoreLocation
import UIKit

class HomeVC: BaseVC {
    @IBOutlet weak var lblServiceTitle: UILabel!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var viewWhite: UIView! {
        didSet {
            viewWhite.roundCorners(with: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 24)
        }
    }
    
//    private var dataSource: TableDataSource<DefaultHeaderFooterModel<FilterOption>, DefaultCellModel<FilterOption>, FilterOption>?
//    private var categories = [FilterOption]()
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<PreferenceOption>, DefaultCellModel<PreferenceOption>, PreferenceOption>?

    private var categories = [PreferenceOption]()
    private var allCategories = [PreferenceOption]()
    private var preferenceId = String()

    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        if /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: false) && /UserPreference.shared.data?.isApproved == false {
//            let destVC = Storyboard<VerificationPendingVC>.Home.instantiateVC()
//            destVC.modalPresentationStyle = .overFullScreen
//            present(destVC, animated: false, completion: nil)
//        }
        lblAddress.text = "-------"
        tableViewInit()
        
        
        tfSearch.addTarget(self, action: #selector(searchTextDidChanged(tf:)), for: .editingChanged)
        tfSearch.addTarget(self, action: #selector(handleSearch), for: .editingDidEndOnExit)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        lblServiceTitle.text = VCLiteral.PICK_SERVICE_TEXT.localized
        tfSearch.attributedPlaceholder =
            NSAttributedString(string: VCLiteral.SEARCH_SERVICE.localized, attributes: [NSAttributedString.Key.foregroundColor: ColorAsset.txtLightGrey.color])

        tfSearch.placeholder = VCLiteral.SEARCH_SERVICE.localized
        lblName.text = String.init(format: VCLiteral.HI_USER.localized, UserPreference.shared.data?.name ?? VCLiteral.GUEST_USER.localized)
        imgProfile.setImageNuke(/UserPreference.shared.data?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        LocationManager.shared.startTrackingUser { (location) in
            self.generateAddress(latLng: location)
        }
    }
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
        
    }
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
        let ids = (allCategories.filter({/$0.isSelected})).compactMap({"\(/$0.id)"})
        if ids.count == 0 {
            return
        }
        if /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: true) {
            
            let destVC = Storyboard<RegisterCatVC>.Home.instantiateVC()
            destVC.selectedServices = ids.joined(separator: ",")
            pushVC(destVC)
        }
    }
}

//MARK:- VCFuncs
extension HomeVC {
    
    @objc private func searchTextDidChanged(tf: UITextField) { //Called in sync as text changed in Search textfield

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(handleSearch), object: nil)
        perform(#selector(handleSearch), with: nil, afterDelay: 0.1)
    }
    
    @objc private func handleSearch() { //with delay in typing speed
        
        if tfSearch.text == "" {
            categories = allCategories

        } else {
            let filtered = self.allCategories.filter({ ($0.option_name?.lowercased().contains(/tfSearch.text?.lowercased()) ?? false) })
            categories = filtered
        }
        self.dataSource?.updateAndReload(for: .SingleListing(items: self.categories), .FullReload)
    }
    
    //MARK:- Get Address String from latitude longitude
    private func generateAddress(latLng: LocationManagerData?) {
        let location = CLLocation.init(latitude: /latLng?.latitude, longitude: /latLng?.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placeMarks, error) in
            self?.lblAddress.text = /placeMarks?.first?.name
        }
    }
    
//    private func tableViewInit() {
//        dataSource = TableDataSource<DefaultHeaderFooterModel<FilterOption>, DefaultCellModel<FilterOption>, FilterOption>.init(.SingleListing(items: categories, identifier: CategoryCell.identfier, height: 48.0, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
//
//        dataSource?.configureCell = { (cell, item, indexPath) in
//            (cell as? CategoryCell)?.item = item
//        }
//
//        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
//            if /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: true) {
//                let destVC = Storyboard<RegisterCatVC>.Home.instantiateVC()
//                destVC.filter = item?.property?.model
//                self?.pushVC(destVC)
//            }
//        }
//
//        dataSource?.addPullToRefresh = { [weak self] in
//            self?.errorView.removeFromSuperview()
//            self?.getCategoriesAPI()
//        }
//
//        dataSource?.refreshProgrammatically()
//    }
    
//    private func getCategoriesAPI() {
//        EP_Home.getFilters(categoryId: UserPreference.shared.staticCategoryId).request(success: { [weak self] (responseData) in
//            self?.categories = (responseData as? FilterData)?.filters?.first?.options ?? []
//            UserPreference.shared.staticFilterMain = (responseData as? FilterData)?.filters?.first
//            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.categories ?? []), .FullReload)
//            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
//        }) { [weak self] (error) in
//            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
//            self?.stopLineAnimation()
//            if /self?.categories.count == 0 {
//                self?.showErrorView(error: /error, scrollView: self?.tableView, tapped: {
//                    self?.errorView.removeFromSuperview()
//                    self?.dataSource?.refreshProgrammatically()
//                })
//            }
//        }
//    }
    
    
    private func tableViewInit() {
        dataSource = TableDataSource<DefaultHeaderFooterModel<PreferenceOption>, DefaultCellModel<PreferenceOption>, PreferenceOption>.init(.SingleListing(items: categories, identifier: PreferencesCell.identfier, height: 48.0, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? PreferencesCell)?.item = item
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            self?.categories[indexPath.row].isSelected = !(/self?.categories[indexPath.row].isSelected)
            self?.tableView.reloadData()
        }
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getMasterPreferences()
        }
        dataSource?.refreshProgrammatically()
    }
    
    private func getMasterPreferences() {
        
        EP_Home.getMasterDuty(filter_ids: nil).request(success: { [weak self] (responseData) in
            
            self?.allCategories = (responseData as? PreferenceData)?.preferences?.first?.options ?? []
            self?.categories = self?.allCategories ?? []
//            self?.lblTitle.text = (responseData as? PreferenceData)?.preferences?.first?.preference_name
            self?.preferenceId = "\(/(responseData as? PreferenceData)?.preferences?.first?.id)"
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.categories ?? []), .FullReload)
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
        }) { [weak self] (error) in
          
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            self?.stopLineAnimation()
            if /self?.categories.count == 0 {
                self?.showErrorView(error: /error, scrollView: self?.tableView, tapped: {
                    self?.errorView.removeFromSuperview()
                    self?.dataSource?.refreshProgrammatically()
                })
            }
        }
    }
}
