//
//  VendorDetailCollectionTVCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class VendorDetailCollectionTVCell: UITableViewCell, ReusableCell {
    
    typealias T = VD_Cell_Provider
    @IBOutlet weak var collectionVIew: UICollectionView!
    
    private var dataSource: CollectionDataSource?
    
    var item: VD_Cell_Provider? {
        didSet {
            collectionViewInit()
        }
    }
    
    private func collectionViewInit() {
        
        let widthOfBtn = (UIScreen.main.bounds.width - 48.0) / 2.0
        let heightOfBtn = widthOfBtn * 0.39024
        
        dataSource = CollectionDataSource.init(item?.property?.model?.subscriptions, VendorDetailBtnCell.identfier, collectionVIew, CGSize.init(width: widthOfBtn, height: heightOfBtn), UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16), 16, 16)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? VendorDetailBtnCell)?.item = item
        }
        
        dataSource?.didSelectItem = { (indexPath, item) in
            if /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: true) == false {
                return
            }
            
            if (item as? Service)?.need_availability == .TRUE {
                let destVC = Storyboard<CreateSchedulePopUpVC>.PopUp.instantiateVC()
                destVC.modalPresentationStyle = .overFullScreen
                destVC.scheduleTypeTapped = { (scheduleType) in
                    switch scheduleType {
                    case .instant:
                        let destVC = Storyboard<ConfirmBookingVC>.Home.instantiateVC()
                        destVC.vendor = self.item?.property?.model?.vendor
                        destVC.service = item as? Service
                        UIApplication.topVC()?.pushVC(destVC)
                    case .schedule:
                        let destVC = Storyboard<ChooseDateTimeVC>.Home.instantiateVC()
                        destVC.vendor = self.item?.property?.model?.vendor
                        destVC.service = item as? Service
                        destVC.didSelecteDateTime = { (selectedDateTimeData) in
                            let confirmVC = Storyboard<ConfirmBookingVC>.Home.instantiateVC()
                            confirmVC.vendor = self.item?.property?.model?.vendor
                            confirmVC.service = item as? Service
                            confirmVC.selectedDateTime = selectedDateTimeData
                            UIApplication.topVC()?.pushVC(confirmVC)
                        }
                        UIApplication.topVC()?.pushVC(destVC)
                    }
                }
                UIApplication.topVC()?.presentVC(destVC)
            } else {
                let destVC = Storyboard<ConfirmBookingVC>.Home.instantiateVC()
                destVC.vendor = self.item?.property?.model?.vendor
                destVC.service = item as? Service
                UIApplication.topVC()?.pushVC(destVC)
            }
        }
    }
}
