//
//  AddressListVC.swift
//  RoyoConsultant
//
//  Created by Chitresh Goyal on 21/01/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit

class AddressListVC: BaseVC {
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var btnAddAddress: UIButton!
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<AddressModel>, DefaultCellModel<AddressModel>, AddressModel>?
    private var items: [AddressModel]?
    public var addNewAddress: (() -> Void)?
    var didSelected: ((_ addess: LocationManagerData?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        tableViewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.unhideVisualEffectView()
        }
    }
    
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Cancel
            hideVisulEffectView()
//        case 1: //Apply
//            if /filters?.compactMap({$0.options}).flatMap({$0}).filter({/$0.isSelected}).count == 0 {
//                btnApply.vibrate()
//            } else {
//                hideVisulEffectView(filterApplied: true, isCleared: false)
//            }
        case 2: //Add new address
            self.view.endEditing(true)
            hideVisulEffectView()
            self.addNewAddress?()
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension AddressListVC {
    
    private func localizedTextSetup() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = true
        lblTitle.text = VCLiteral.ADDRESS.localized

    }
    
    private func tableViewInit() {
       
        dataSource = TableDataSource<DefaultHeaderFooterModel<AddressModel>, DefaultCellModel<AddressModel>, AddressModel>.init(.SingleListing(items: items ?? [], identifier: AddressTVC.identfier, height: UITableView.automaticDimension, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? AddressTVC)?.item = item
        }
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getNotificationsAPI(isRefreshing: true)
        }
        
//        dataSource?.addInfiniteScrolling = { [weak self] in
//            if self?.after != nil {
//                self?.getNotificationsAPI()
//            }
//        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in

            var address = LocationManagerData()
            address.latitude = /Double(/item?.property?.model?.lat)
            address.longitude = /Double(/item?.property?.model?.long)
            address.locationName = item?.property?.model?.address_name
            address.address = item?.property?.model?.house_no
            address.save_as = item?.property?.model?.save_as
            address.address_id = "\(/item?.property?.model?.id)"

            if /item?.property?.model?.house_no == "" {
                address.address = "\(/item?.property?.model?.save_as)\n\(/item?.property?.model?.address_name)"
            } else {
                address.address = "\(/item?.property?.model?.save_as)\n(\(/item?.property?.model?.house_no))\n\(/item?.property?.model?.address_name)"
            }
            self?.didSelected?(address)
            self?.hideVisulEffectView()
        }
        
        dataSource?.refreshProgrammatically()
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
                
            })
        }
    }
}
extension AddressListVC {
    
    private func getNotificationsAPI(isRefreshing: Bool? = false) {
        
        EP_Home.getAddress.request(success: { [weak self] (responseData) in
            let response = (responseData as? AddressData)

            self?.items = response?.addresses
            
            /self?.items?.count == 0 ? self?.showVCPlaceholder(type: .NoAddress, scrollView: self?.tableView) : ()
            self?.dataSource?.stopInfiniteLoading(.NoContentAnyMore)
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.items ?? []), .FullReload)
        }) { [weak self] (error) in
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            if /self?.items?.count == 0 {
                self?.showErrorView(error: /error, scrollView: self?.tableView, tapped: {
                    self?.errorView.removeFromSuperview()
                    self?.dataSource?.refreshProgrammatically()
                })
            }
        }
    }
}
