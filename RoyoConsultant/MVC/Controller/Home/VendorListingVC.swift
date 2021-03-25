//
//  VendorListingVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 16/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class VendorListingVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionFilters: UICollectionView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var collectionCoupons: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    public var category: Category?
    var interMediateData: RegisterCatModel?
    
    private var couponDataSource: CollectionDataSource?
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<Vendor>, DefaultCellModel<Vendor>, Vendor>?
    private var collectionDataSource: CollectionDataSource?
    private var items: [Vendor]?
    private var after: String?
    private var filters: [Filter]?
    private var services: [Service]?
    private var serviceId: String?
    private var searchText: String?
    private var coupons: [Coupon]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        tableViewInit()
        collectionFiltersInit()
        //        getFiltersAPI()
        //        getServicesAPI()
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        //            self?.getCouponsAPI()
        //        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Filter
            let destVC = Storyboard<FilterPopUpVC>.PopUp.instantiateVC()
            destVC.modalPresentationStyle = .overFullScreen
            destVC.filters = Filter.generateNewReferenceArray(filters: filters ?? [])
            destVC.filtersApplied = { [weak self] (selectedFilters, isCleared) in
                self?.filters = selectedFilters
                self?.setColorsForBtnFilter(isSelected: !(/isCleared))
                self?.playLineAnimation()
                self?.getVendorsListAPI(isRefreshing: true)
            }
            presentVC(destVC)
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension VendorListingVC {
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.AVAILABLE_PROFESSIONALS.localized///category?.name
        tfSearch.placeholder = String.init(format: VCLiteral.SEARCH_FOR.localized, VCLiteral.AVAILABLE_PROFESSIONALS.localized.lowercased())
        collectionFilters.isHidden = true
        btnFilter.isHidden = true
        collectionCoupons.isHidden = true
        setColorsForBtnFilter(isSelected: false)
        tfSearch.addTarget(self, action: #selector(searchTextDidChanged(tf:)), for: .editingChanged)
        tfSearch.addTarget(self, action: #selector(handleSearch), for: .editingDidEndOnExit)
        pageControl.isHidden = true
    }
    
    @objc private func searchTextDidChanged(tf: UITextField) { //Called in sync as text changed in Search textfield
        searchText = tf.text
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(handleSearch), object: nil)
        perform(#selector(handleSearch), with: nil, afterDelay: 0.5)
    }
    
    @objc private func handleSearch() { //with delay in typing speed
        getVendorsListAPI(isRefreshing: true)
    }
    
    private func collectionFiltersInit() {
        collectionDataSource = CollectionDataSource.init(services, VendorFilterCell.identfier, collectionFilters, CGSize.init(width: 88, height: 36), UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16), 16, 0)
        
        collectionDataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? VendorFilterCell)?.item = item
        }
        
        collectionDataSource?.didSelectItem = { [weak self] (indexPath, item) in
            if /self?.services?[indexPath.item].isSelected {
                self?.services?[indexPath.item].isSelected = false
                self?.serviceId = nil
            } else {
                self?.services?.forEach({$0.isSelected = false})
                self?.services?[indexPath.item].isSelected = true
                self?.serviceId = String(/(item as? Service)?.service_id)
            }
            self?.collectionDataSource?.updateData(self?.services)
            self?.playLineAnimation()
            self?.getVendorsListAPI(isRefreshing: true)
        }
    }
    
    private func tableViewInit() {
        
        tableView.contentInset.top = 12
        
        dataSource = TableDataSource<DefaultHeaderFooterModel<Vendor>, DefaultCellModel<Vendor>, Vendor>.init(.SingleListing(items: items ?? [], identifier: VendorCell.identfier, height: UITableView.automaticDimension, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            self?.tfSearch.text = nil
            self?.getVendorsListAPI(isRefreshing: true)
        }
        
        dataSource?.addInfiniteScrolling = { [weak self] in
            if self?.after != nil {
                self?.getVendorsListAPI()
            }
        }
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? VendorCell)?.item = item
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            let destVC = Storyboard<VendorDetailVC>.Home.instantiateVC()
            destVC.vendor = item?.property?.model?.vendor_data
            destVC.interMediateData = self?.interMediateData
            self?.pushVC(destVC)
        }
        
        dataSource?.refreshProgrammatically()
    }
    
    private func getVendorsListAPI(isRefreshing: Bool? = false) {
        errorView.removeFromSuperview()
        
        
        let dates = interMediateData?.startDate.flatMap({$0})
        
        var datesStr = [String]()
        for date in dates ?? [] {
            datesStr.append(date.toString(DateFormat.custom("yyyy-MM-dd"), timeZone: .local))
        }
        
        EP_Home.vendorListNew(category_id: UserPreference.shared.staticCategoryId, filter_id: interMediateData?.filterOption?.id, date: datesStr.joined(separator: ","), time: interMediateData?.startTime?.toString(DateFormat.custom("HH:mm"), timeZone: .local), lat: String(/interMediateData?.address?.latitude), long: String(/interMediateData?.address?.longitude), service_address: interMediateData?.address?.address, end_date: nil, end_time: interMediateData?.endTime?.toString(DateFormat.custom("HH:mm"), timeZone: .local), duties: /interMediateData?.selectedServices, after: /after, address_id: /interMediateData?.address?.address_id).request(success: { [weak self] (responseData) in
            
            let response = responseData as? VendorData
            self?.after = response?.after
            
            if /isRefreshing {
                self?.items = response?.vendors
            } else {
                self?.items = (self?.items ?? []) + (response?.vendors ?? [])
            }
            /self?.items?.count == 0 ? self?.showVCPlaceholder(type: .NoVendors(categoryName: /self?.category?.name?.capitalizingFirstLetter()), scrollView: self?.tableView) : ()
            self?.dataSource?.stopInfiniteLoading(response?.after == nil ? .NoContentAnyMore : .FinishLoading)
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.items ?? []), .FullReload)
            self?.stopLineAnimation()
        }) { [weak self] (error) in
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            self?.stopLineAnimation()
            if /self?.items?.count == 0 {
                self?.showErrorView(error: /error, scrollView: self?.tableView, tapped: {
                    self?.errorView.removeFromSuperview()
                    self?.dataSource?.refreshProgrammatically()
                })
            }
        }
    }
    
    private func getFiltersAPI() {
        EP_Home.getFilters(categoryId: String(/category?.id), duties: nil).request(success: { [weak self] (responseData) in
            self?.filters = (responseData as? FilterData)?.filters
            UIView.animate(withDuration: 0.3) {
                self?.btnFilter.isHidden = /self?.filters?.count == 0
            }
        }) { (error) in
            
        }
    }
    
    private func getServicesAPI() {
        EP_Home.services(categoryId: String(/category?.id)).request(success: { [weak self] (responseData) in
            self?.services = (responseData as? ServicesData)?.services
            self?.collectionDataSource?.updateData(self?.services)
            UIView.animate(withDuration: 0.3) {
                self?.collectionFilters.isHidden = /self?.services?.count <= 1
            }
        }) { (error) in
            
        }
    }
    
    private func getCouponsAPI() {
        EP_Home.coupons(categoryId: String(/category?.id), serviceId: nil).request(success: { [weak self] (responseData) in
            self?.coupons = (responseData as? CouponsData)?.coupons
            if /self?.coupons?.count > 0 {
                self?.couponsConfig()
            }
        }) { (_) in
            
        }
    }
    
    private func couponsConfig() {
        
        collectionCoupons.isHidden = false
        pageControl.isHidden = false
        pageControl.numberOfPages = /coupons?.count
        pageControl.currentPage = 0
        
        let width = UIScreen.main.bounds.width
        
        let sizeProvider = CollectionSizeProvider.init(cellSize: CGSize.init(width: width, height: 120.0), interItemSpacing: 0, lineSpacing: 0, edgeInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        
        collectionCoupons.isPagingEnabled = true
        
        couponDataSource = CollectionDataSource.init(coupons, CouponCell.identfier, collectionCoupons, sizeProvider.cellSize, sizeProvider.edgeInsets, sizeProvider.lineSpacing, sizeProvider.interItemSpacing)
        
        couponDataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? CouponCell)?.item = item
        }
        
        couponDataSource?.didChangeCurrentIndex = { [weak self] (indexPath) in
            self?.pageControl.currentPage = indexPath.item
        }
    }
    
    private func setColorsForBtnFilter(isSelected: Bool) {
        btnFilter.borderColor = isSelected ? ColorAsset.appTint.color : ColorAsset.btnBorder.color
        btnFilter.backgroundColor = isSelected ? ColorAsset.appTint.color : ColorAsset.backgroundColor.color
        btnFilter.tintColor = isSelected ? ColorAsset.txtWhite.color : ColorAsset.txtExtraLight.color
    }
}
