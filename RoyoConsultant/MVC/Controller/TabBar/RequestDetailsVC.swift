//
//  RequestDetailsVC.swift
//  RoyoConsultantVendor
//
//  Created by Chitresh Goyal on 23/12/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class RequestDetailsVC: BaseVC {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRequestType: UILabel!
    @IBOutlet weak var imgVIew: UIImageView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblbookingDates: UILabel!
    
    @IBOutlet weak var lblCovidDetails: UILabel!
    @IBOutlet weak var vwApproval: UIView!
    @IBOutlet weak var lblStatusDescription: UILabel!

    @IBOutlet weak var lblApprovedStatus: UILabel!
    
    @IBOutlet weak var vwFeedback: UIView!
    @IBOutlet weak var lblFeedbackDescription: UILabel!

    @IBOutlet weak var lblFeedbackStatus: UILabel!
    
    @IBOutlet weak var vwCovid: UIView!
    @IBOutlet weak var btnDecline: SKLottieButton!
    @IBOutlet weak var btnSeeMore: UIButton!

    @IBOutlet weak var btnAccept: SKLottieButton!
    //MARK: -
    var item: Requests?
    var reloadTable: (() -> Void)?
    var requestID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDetails()
    }
    
    func getDetails() {
        EP_Home.requestDetail(request_id: item?.id == nil ? /requestID : "\(/item?.id)").request(success: { [weak self] (responseData) in

            let request = responseData as? RequestDetailsData
            self?.item = request?.request_detail
            self?.setupData()
        }) { [weak self] (error) in
            self?.btnDecline.stop()
        }

    }
    
    @IBAction func actionButtons(_ sender: UIButton) {
        
        switch sender.tag {
        case 0: //BACK
            popVC()
        case 1: // MAP
            break
        case 2: //Decline Button
           
            switch /sender.title(for: .normal) {
            
            case VCLiteral.RATING.localized:
                let destVC = Storyboard<RateUsPopUpVC>.PopUp.instantiateVC()
                destVC.modalPresentationStyle = .overFullScreen
                destVC.request = item
                destVC.didStatusChanged = { [weak self] (status) in
                    self?.getDetails()
                }
                UIApplication.topVC()?.presentVC(destVC)
                
            default:
                UIApplication.topVC()?.alertBoxOKCancel(title: VCLiteral.CANCEL_REQUEST.localized, message: VCLiteral.CANCEL_REQUEST_ALERT.localized, tapped: { [weak self] in
                    
                    self?.btnDecline.setAnimationType(.BtnAppTintLoader)
                    self?.btnDecline.playAnimation()
                    EP_Home.cancelRequest(requestId: String(/self?.item?.id)).request(success: { [weak self] (responseData) in
                        self?.btnDecline.stop()
                        self?.item?.canCancel = false
                        self?.item?.status = .canceled
                        self?.getDetails()
                        self?.setupData()
                    }) { [weak self] (error) in
                        self?.btnDecline.stop()
                    }
                }, cancelTapped: nil)
                
            }
            
        case 3: // Accept
            
//            if item?.status == .pending {
//                manageRequest()
//            } else
//            if item?.status == .accept {
//                startRequestAlert()
//            } else
            
            if item?.status == .reached || item?.status == .start || item?.status == .inProgress {
                let destVC = Storyboard<TrackingVC>.Home.instantiateVC()
                destVC.request = item
                destVC.modalPresentationStyle = .fullScreen
                destVC.didStatusChanged = { [weak self] (status) in
                    self?.item?.status = status
                    self?.getDetails()

                    self?.setupData()
                    self?.reloadTable?()
                }
                self.presentVC(destVC)
            } else if item?.status ==  .start_service {
                let destVC = Storyboard<TrackStatusVC>.Home.instantiateVC()
                destVC.request = item
                destVC.modalPresentationStyle = .fullScreen
                
                self.presentVC(destVC)
            } else if item?.status == .completed {
                
                let destVC = Storyboard<ApprovePopUpVC>.PopUp.instantiateVC()
                destVC.request = item
                destVC.modalPresentationStyle = .fullScreen
                
                self.presentVC(destVC)
            }
        case 10:
            
            btnSeeMore.isSelected = !btnSeeMore.isSelected
            lblCovidDetails.numberOfLines = /btnSeeMore.isSelected ? 0 : 3
        default:
            break
        }
    }
    
//    private func manageRequest() {
//
//        btnAccept.setAnimationType(.BtnAppTintLoader)
//        btnAccept.playAnimation()
//        EP_Home.acceptRequest(requestId: String(/item?.id)).request(success: { [weak self] (responseData) in
//            self?.btnAccept.stop()
//
//            self?.item?.status = .accept
//            self?.setupData()
//        }) { [weak self] (error) in
//            self?.btnAccept.stop()
//        }
//    }
//    private func startRequestAlert() {
//        UIApplication.topVC()?.alertBox(title: VCLiteral.START_REQUEST.localized, message: VCLiteral.START_REQUEST_ALERT_DESC.localized, btn1: VCLiteral.Cancel.localized, btn2: VCLiteral.START.localized, tapped1: nil, tapped2: { [weak self] in
//            self?.startRequestFurtherProceed()
//        })
//    }
//
//    private func startRequestFurtherProceed() {
//        btnAccept.setAnimationType(.BtnAppTintLoader)
//        btnAccept.playAnimation()
//        let service = item
//
//        EP_Home.callStatus(requestID: String(/service?.id), status: .start).request(success: { [weak self] (response) in
//            self?.btnAccept.stop()
//
//        }) { [weak self] (_) in
//            self?.btnAccept.stop()
//        }
//    }
}
extension RequestDetailsVC {
    
    private func setupData() {
        
        let obj = item
        lblName.text = /obj?.to_user?.name
        lblRequestType.text = (/obj?.service_type).uppercased()
        if /obj?.status?.title.localized == VCLiteral.CANCELLED.localized {
            
            if /obj?.canceled_by?.id == /UserPreference.shared.data?.id {
                lblStatus.text = "CANCELLED"//obj?.status?.title.localized

            } else {
                lblStatus.text = "DECLINED"///obj?.status?.title.localized
            }
                
        } else {
            lblStatus.text = /obj?.status?.title.localized
        }
        imgVIew.setImageNuke(/obj?.to_user?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
        
        lblAddress.text = /obj?.extra_detail?.service_address
        lblDistance.text = /obj?.extra_detail?.distance
        lblTime.text = "\(/obj?.extra_detail?.start_time) - \(/obj?.extra_detail?.end_time)"
        
        var dutiesArr = [String]()
        for val in obj?.duties ?? [] {
            dutiesArr.append(/val.option_name)
        }
        lblRequestType.text = /dutiesArr.joined(separator: ", ")
        
        let dates = /obj?.extra_detail?.working_dates
        let datesArr = dates.components(separatedBy: ",")

        var localArr = [String]()
        for dateStr in datesArr {
            let utcDate1 = Date(fromString: dateStr, format: DateFormat.custom("yyyy-MM-dd"), timeZone: .local)
            localArr.append(utcDate1.toString(DateFormat.custom("dd MMM yyyy"), timeZone: .local))
        }
        
        lblbookingDates.text = localArr.joined(separator: " | ")
        lblStatus.textColor = obj?.status?.linkedColor.color
        
        vwFeedback.isHidden = true//!(/obj?.userIsApproved)
        lblFeedbackDescription.text = ""
        
        var covidArr = [Preference]()

        for item in obj?.from_user?.master_preferences ?? [] {

            switch /item.preference_type {
            case "covid":
                covidArr.append(item)

            default:
                break
            }
        }
        var covidStrArr = [String]()
        for item in covidArr {
            
            if let options = item.options {
                let filterTitle = options.map({ /$0.option_name })
                
                covidStrArr.append("\(/item.preference_name)\n\(filterTitle.joined(separator: ", "))\n\n")
            }
        }
        lblCovidDetails.text = covidStrArr.joined(separator: "")
        vwCovid.isHidden = true///covidStrArr.count == 0
        
        if obj?.rating != nil {
            vwFeedback.isHidden = false
            lblFeedbackStatus.text = "⭐ \(/obj?.rating)"
            lblFeedbackDescription.text = /obj?.comment
        }
        
        lblApprovedStatus.text = /obj?.user_status?.uppercased()
        lblStatusDescription.text = /obj?.user_comment
        vwApproval.isHidden = !(/obj?.userIsApproved)
        
        btnDecline.isHidden = !(/obj?.canCancel)
        btnDecline.setTitle(VCLiteral.CANCEL.localized, for: .normal)
        btnAccept.backgroundColor = ColorAsset.appTint.color

        switch obj?.status ?? .unknown {
        case .canceled, .failed:
            btnDecline.isHidden = true
            btnAccept.isHidden = true
        case .accept:
            btnDecline.isHidden = true
            btnAccept.isHidden = true
        case .pending:
            btnDecline.isHidden = false
            btnAccept.isHidden = true
            btnDecline.setTitle(VCLiteral.CANCEL_APPOINTMENT.localized, for: .normal)
        case .start, .inProgress, .reached:
            btnDecline.isHidden = true
            btnAccept.setTitle(VCLiteral.TRACK_STATUS.localized, for: .normal)
            btnAccept.backgroundColor = ColorAsset.appTint.color
        case .start_service:
            btnDecline.isHidden = true
            btnAccept.isHidden = false
            btnAccept.setTitle(VCLiteral.TRACK_STATUS.localized, for: .normal)
            btnAccept.backgroundColor = ColorAsset.appTint.color
        case .completed:
            
            btnAccept.isHidden = false
            btnAccept.setTitle(VCLiteral.APPROVE.localized, for: .normal)
            btnDecline.isHidden = false
            btnDecline.setTitle(VCLiteral.RATING.localized, for: .normal)

            if obj?.rating != nil {
                btnDecline.isHidden = true
            }
            if /obj?.userIsApproved {
                btnAccept.isHidden = true
            }
        default:
            btnAccept.isHidden = true
        }
    }
}
