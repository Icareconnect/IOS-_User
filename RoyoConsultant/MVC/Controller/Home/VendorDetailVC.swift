//
//  VendorDetailVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import MXParallaxHeader
import FirebaseDynamicLinks

class VendorDetailVC: BaseVC {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblServiceDetails: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblRatingReviews: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerXIBForHeaderFooter(VendorDetailHeaderView.identfier)
        }
    }
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var viewExp: UIView!
    @IBOutlet weak var viewClients: UIView!

    @IBOutlet weak var lblExtra1InfoTitle: UILabel!
    @IBOutlet weak var lblExtra2InfoTitle: UILabel!
    @IBOutlet weak var lblExtra3InfoTitle: UILabel!
    @IBOutlet weak var lblExtra1Value: UILabel!
    @IBOutlet weak var lblExtra2Value: UILabel!
    @IBOutlet weak var lblExtra3Value: UILabel!
    @IBOutlet weak var btnContinue: SKLottieButton!
    
    public var vendor: User?
    private var dataSource: TableDataSource<VD_HeaderFooter_Provider, VD_Cell_Provider, VD_Modal>?
    private var items: [VD_HeaderFooter_Provider]?
    private var after: String?
    var interMediateData: RegisterCatModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        getVendorDetailAPI()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Share
            let url = "\(Configuration.getValue(for: .ROYO_CONSULTANT_BASE_PATH))\(DynamicLinkPage.userProfile.rawValue)?id=\("\(/vendor?.id)")"
            
            guard let link = URL.init(string: url) else { return }
            
            guard let shareLink = DynamicLinkComponents.init(link: link, domainURIPrefix: "https://\(Configuration.getValue(for: .ROYO_CONSULTANT_FIREBASE_PAGE_LINK))") else {
                return
            }
            shareLink.iOSParameters = DynamicLinkIOSParameters.init(bundleID: /Bundle.main.bundleIdentifier)
            shareLink.iOSParameters?.appStoreID = Configuration.getValue(for: .ROYO_CONSULTANT_APPLE_APP_ID)
            shareLink.iOSParameters?.minimumAppVersion = Bundle.main.versionNumber
            shareLink.androidParameters = DynamicLinkAndroidParameters.init(packageName: Configuration.getValue(for: .ROYO_CONSULTANT_ANDROID_PACKAGE_NAME))
            shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
            shareLink.socialMetaTagParameters?.title = "\(/vendor?.categoryData?.name) | \(/vendor?.name)"
            shareLink.socialMetaTagParameters?.descriptionText = /vendor?.profile?.bio
            shareLink.socialMetaTagParameters?.imageURL = URL.init(string: Configuration.getValue(for: .ROYO_CONSULTANT_IMAGE_UPLOAD) + /vendor?.profile_image)
            
            shareLink.shorten { [weak self] (url, warnings, error) in
                self?.share(items: [/url?.absoluteString], sourceView: sender)
            }
        case 2: //Book Appointment
            
            interMediateData?.consultant_id = "\(/vendor?.id)"
            btnContinue.playAnimation()
            
            
            let dates = interMediateData?.startDate.flatMap({$0})
            
            var datesStr = [String]()
            for date in dates ?? [] {
                datesStr.append(date.toString(DateFormat.custom("yyyy-MM-dd"), timeZone: .local))
            }

            EP_Home.createRequestNew(consultant_id: interMediateData?.consultant_id, dates: datesStr.joined(separator: ","), schedule_type: .schedule, request_type: "multiple", first_name: interMediateData?.name, last_name: interMediateData?.name, lat: "\(/interMediateData?.address?.latitude)", long: "\(/interMediateData?.address?.longitude)", service_for: interMediateData?.requestingFor, home_care_req: interMediateData?.selectedServices, reason_for_service: interMediateData?.ros, service_address: interMediateData?.address?.address, end_date: nil, end_time: interMediateData?.endTime?.toString(DateFormat.custom("HH:mm"), timeZone: .local), card_id: nil, start_time: interMediateData?.startTime?.toString(DateFormat.custom("HH:mm"), timeZone: .local), request_step: "confirm", filter_id: nil, service_id: "1", duties: interMediateData?.selectedServices, phone_number: interMediateData?.phone_number, country_code: interMediateData?.country_code).request(success: { [weak self] (responseData) in
                
                self?.btnContinue.stop()

                let bookingData = responseData as? ConfirmBookingData
               
                let destVC = Storyboard<AddMoneyVC>.Home.instantiateVC()
                destVC.interMediateData = self?.interMediateData
                destVC.bookingData = bookingData
                self?.pushVC(destVC)
            }) { [weak self] (_) in
                self?.btnContinue.stop()
            }
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension VendorDetailVC {
    private func initialSetup() {
        
        lblName.text = /vendor?.name
        lblTitle.text = /vendor?.name
        imgView.setImageNuke(/vendor?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
        let experience = "Exp · " + /vendor?.custom_fields?.first(where: {/$0.field_name == "Work experience"})?.field_value
        
        lblDesc.text = experience
        
//        if let filters = vendor?.filters, filters.count > 0 {
//            if let options = filters[0].options {
//                let filterTitle = options.map({ /$0.option_name })
//
//                lblRatingReviews.text = filterTitle.joined(separator: ", ")
//            }
//        }
        lblRatingReviews.text = ""
        lblAddress.text =  /vendor?.profile?.location?.name
        //lblRatingReviews.text = "\(/vendor?.totalRating) · \(/vendor?.reviewCount) \(/vendor?.reviewCount == 1 ? VCLiteral.REVIEW.localized : VCLiteral.REVIEWS.localized)"
        
        lblExtra1InfoTitle.text = VCLiteral.PATIENTS.localized
        lblExtra1Value.text = "\(/vendor?.patientCount)"
        lblExtra2InfoTitle.text = VCLiteral.EXPERIECE.localized
        lblExtra2Value.text = experience
        lblExtra3InfoTitle.text = VCLiteral.REVIEWS.localized
        lblExtra3Value.text = "\(/vendor?.reviewCount)"
        viewClients.isHidden = true
        
        tableView.parallaxHeader.view = headerView
        tableView.parallaxHeader.mode = .bottom
        tableView.parallaxHeader.height = 160//216
        tableView.parallaxHeader.minimumHeight = 0
        tableView.parallaxHeader.delegate = self
        
        tableViewInit()
        
        navView.alpha = 0.0
    }
    
    private func tableViewInit() {
        items = VD_HeaderFooter_Provider.getItems(vendor)
        
        dataSource = TableDataSource<VD_HeaderFooter_Provider, VD_Cell_Provider, VD_Modal>.init(.MultipleSection(items: items ?? []), tableView)
        
        dataSource?.configureHeaderFooter = { (section, item, view) in
            (view as? VendorDetailHeaderView)?.item = item
        }
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? VendorDetailCollectionTVCell)?.item = item
            (cell as? AboutCell)?.item = item
            (cell as? ReviewCell)?.item = item
        }
        
        dataSource?.addInfiniteScrolling = { [weak self] in
            if self?.after != nil {
                self?.getReviewsAPI()
            }
        }
    }
    
    private func getVendorDetailAPI() {
        EP_Home.vendorDetail(id: String(/vendor?.id)).request(success: { [weak self] (responseData) in
            self?.vendor = responseData as? User
            self?.items = VD_HeaderFooter_Provider.getItems(self?.vendor)
            
            self?.lblServiceDetails.text = /self?.vendor?.services?.first?.price?.getFormattedPrice() + /self?.getUnit(/Int(/self?.vendor?.services?.first?.unit_price))

            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .FullReload)
            self?.playLineAnimation()
            self?.getReviewsAPI()
        }) { (error) in
            
        }
    }
    
    private func getReviewsAPI() {
        EP_Home.getReviews(vendorId: String(/vendor?.id), after: nil).request(success: { [weak self] (responseData) in
            let resposne = responseData as? ReviewsData
            self?.after = resposne?.after
            if /resposne?.review_list?.count > 0 {
                let reviewSection = VD_HeaderFooter_Provider.getReviewsSection(self?.vendor, reviews: resposne?.review_list)
                if /self?.items?.last?.items?.first?.property?.identifier == ReviewCell.identfier { //Reviews Exist
                    let reviews = (self?.items?.last?.items ?? []) + (reviewSection.items ?? [])
                    self?.items?.last?.items = reviews
                    self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .ReloadSectionAt(indexSet: IndexSet(integer: /self?.items?.count - 1), animation: .automatic))
                } else {
                    self?.items?.append(reviewSection)
                    self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .InsertSection(indexSet: IndexSet(integer: /self?.items?.count - 1), animation: .bottom))
                }
            }
            self?.dataSource?.stopInfiniteLoading(/resposne?.review_list?.count == 0 ? .NoContentAnyMore : .FinishLoading)
            self?.stopLineAnimation()
        }) { [weak self] (_) in
            self?.stopLineAnimation()
        }
    }
}

//MARK:- MXParralaxHeaderDelegate
extension VendorDetailVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        switch parallaxHeader.progress {
        case CGFloat(0.0)...CGFloat(1.0):
            headerView.alpha = parallaxHeader.progress
            navView.alpha = 1.0 - parallaxHeader.progress
        default:
            break
        }
    }
}
extension VendorDetailVC {
    func getUnit(_ seconds: Int) -> String {
        if seconds == 60 {
            return "/minute"
        } else if seconds == 1 {
            return "/second"
        } else if seconds < 60 {
            return "/ \(seconds) seconds"
        } else if seconds >= 3600 {
            return "/ \(seconds / 3600) hour"
        } else {
            return "/ \(seconds / 60) minute"
        }
    }
}

