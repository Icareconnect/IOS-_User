//
//  SideMenuVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 14/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

class ProfileVC: BaseVC {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblVersionNo: UILabel!
    @IBOutlet weak var lblVersionInfo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var headerView: UIView!
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<ProfileItem>, DefaultCellModel<ProfileItem>, ProfileItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        imgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(editProfile)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateProfileData()
    }
    
    @IBAction func btnWalletAction(_ sender: UIButton) {
        pushVC(Storyboard<WalletVC>.Home.instantiateVC())
    }
}

//MARK:- VCFuncs
extension ProfileVC {
    
    public func updateProfileData() {
        tableView.tableHeaderView = headerView
        lblName.text = /UserPreference.shared.data?.name
        
        lblAge.text = ""
        imgView.setImageNuke(/UserPreference.shared.data?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
    }
    
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.PROFILE.localized
        lblVersionNo.text = String.init(format: VCLiteral.VERSION.localized, Bundle.main.versionNumber)
        lblVersionInfo.text = VCLiteral.VERSION_INFO.localized
        tableView.contentInset.top = 16.0
        dataSource = TableDataSource<DefaultHeaderFooterModel<ProfileItem>, DefaultCellModel<ProfileItem>, ProfileItem>.init(.SingleListing(items: ProfileItem.getItems(pages: UserPreference.shared.pages), identifier: SideMenuCell.identfier, height: 56.0, leadingSwipe: nil, trailingSwipe: nil), tableView)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? SideMenuCell)?.item = item
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            switch item?.property?.model?.title ?? .HOME {
            case .HISTORY:
                self?.pushVC(Storyboard<HistoryVC>.Home.instantiateVC())
            case .INVITE_PEOPLE:
                self?.shareApp(self?.tableView.cellForRow(at: indexPath))
            case .PACAKAGES:
                self?.pushVC(Storyboard<PackagesVC>.Home.instantiateVC())
            case .LOGOUT:
                self?.logoutAlert()
            case .SAVED_CARDS:
                let destVC = Storyboard<AddMoneyVC>.Home.instantiateVC()
                destVC.isManaging = true
                self?.pushVC(destVC)
                
            default:
                let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
                destVC.linkTitle = (/UserPreference.shared.clientDetail?.domain_url + "/" + /item?.property?.model?.page?.slug, /item?.property?.model?.page?.title)
                self?.pushVC(destVC)
            }
        }
    }
    
    @objc private func editProfile() {
        pushVC(Storyboard<ProfileDetailsVC>.Home.instantiateVC())
    }
    
    private func shareApp(_ source: UIView?) {
        let appLink = "\(Configuration.getValue(for: .ROYO_CONSULTANT_BASE_PATH))\(DynamicLinkPage.Invite.rawValue)"
        
        guard let shareLink = DynamicLinkComponents.init(link: URL.init(string: appLink)!, domainURIPrefix: "https://\(Configuration.getValue(for: .ROYO_CONSULTANT_FIREBASE_PAGE_LINK))") else {
            return
        }
        
        shareLink.iOSParameters = DynamicLinkIOSParameters.init(bundleID: /Bundle.main.bundleIdentifier)
        shareLink.iOSParameters?.appStoreID = Configuration.getValue(for: .ROYO_CONSULTANT_APPLE_APP_ID)
        shareLink.androidParameters = DynamicLinkAndroidParameters.init(packageName: Configuration.getValue(for: .ROYO_CONSULTANT_ANDROID_PACKAGE_NAME))
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = Bundle.main.infoDictionary?["CFBundleName"] as? String
        shareLink.socialMetaTagParameters?.descriptionText = VCLiteral.APP_DESC.localized
        shareLink.socialMetaTagParameters?.imageURL = URL.init(string: Configuration.getValue(for: .ROYO_CONSULTANT_IMAGE_UPLOAD) + /UserPreference.shared.clientDetail?.applogo)
        
        shareLink.shorten { [weak self] (url, warnings, error) in
            self?.share(items: [/url?.absoluteString], sourceView: source)
        }
    }
    
    private func logoutAlert() {
        alertBoxOKCancel(title: VCLiteral.LOGOUT.localized, message: VCLiteral.LOGOUT_ALERT_MESSAGE.localized, tapped: { [weak self] in
            self?.logoutAPI()
        }, cancelTapped: nil)
    }
    
    private func logoutAPI() {
        playLineAnimation()
        EP_Home.logout.request(success: { [weak self] (_) in
            self?.stopLineAnimation()
            UIWindow.replaceRootVC(Storyboard<LoginSignUpNavVC>.PopUp.instantiateVC())
        }) { [weak self] (_) in
            self?.stopLineAnimation()
        }
    }
}
