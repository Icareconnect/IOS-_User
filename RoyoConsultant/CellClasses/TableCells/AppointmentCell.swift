//
//  AppointmentCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 15/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class AppointmentCell: UITableViewCell, ReusableCell {
    
    typealias T = DefaultCellModel<Requests>
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRequestType: UILabel!
    @IBOutlet weak var imgVIew: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnCancel: SKLottieButton!
    @IBOutlet weak var btnMulti: SKLottieButton!

    var didReloadCell: (() -> Void)?
    
    var item: DefaultCellModel<Requests>? {
        didSet {
            let obj = item?.property?.model
            lblName.text = /obj?.to_user?.name
            lblRequestType.text = (/obj?.service_type).uppercased()
            
            if /obj?.status?.title.localized == VCLiteral.CANCELLED.localized {
                
                if /obj?.canceled_by?.id == /UserPreference.shared.data?.id {
                    lblStatus.text = "CANCELLED"
                } else {
                    lblStatus.text = "DECLINED"
                }
            } else {
                lblStatus.text = /obj?.status?.title.localized
            }
            lblStatus.textColor = obj?.status?.linkedColor.color
            imgVIew.setImageNuke(/obj?.to_user?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
            let utcDate = Date(fromString: /obj?.bookingDateUTC, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"), timeZone: .utc)
            lblDate.text = utcDate.toString(DateFormat.custom("dd MMM yyyy · hh:mm a"), timeZone: .local)
            lblPrice.text = /obj?.price?.toDouble()?.getFormattedPrice()
            btnCancel.isHidden = !(/obj?.canCancel)
            btnCancel.setTitle(VCLiteral.CANCEL_APPOINTMENT.localized, for: .normal)
            btnCancel.setTitleColor(ColorAsset.requestStatusFailed.color, for: .normal)
            //            if /obj?.canReschedule {
            //                btnMulti.isHidden = false
            //                btnMulti.setTitle(VCLiteral.RESCHEDULE.localized, for: .normal)
            //            } else {
            
            switch obj?.status ?? .unknown {
            case .canceled, .failed:
                //                    btnMulti.isHidden = false
                //                    btnMulti.setTitle(VCLiteral.BOOKAGAIN.localized, for: .normal)
                btnCancel.isHidden = true
                btnMulti.isHidden = true
            case .completed:
                
                if /obj?.userIsApproved {
                    btnMulti.isHidden = true
                    
                } else {
                    btnMulti.isHidden = false
                    btnMulti.setTitle(VCLiteral.APPROVE.localized, for: .normal)
                    
                }
                btnCancel.isHidden = false
                btnCancel.setTitleColor(ColorAsset.appTint.color, for: .normal)

                if obj?.rating != nil {
                    btnCancel.setTitle("⭐ \(/obj?.rating)", for: .normal)
                    
                } else {
                    btnCancel.setTitle(VCLiteral.RATING.localized, for: .normal)
                }
            default:
                btnMulti.isHidden = true
            }
            
            //            }
        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch /sender.title(for: .normal) {
       
        case VCLiteral.RATING.localized:
            let destVC = Storyboard<RateUsPopUpVC>.PopUp.instantiateVC()
            destVC.modalPresentationStyle = .overFullScreen
            destVC.request = item?.property?.model
            UIApplication.topVC()?.presentVC(destVC)
        case VCLiteral.APPROVE.localized:
            let destVC = Storyboard<ApprovePopUpVC>.PopUp.instantiateVC()
            destVC.request = item?.property?.model
            destVC.modalPresentationStyle = .fullScreen
            UIApplication.topVC()?.presentVC(destVC)

        case VCLiteral.BOOKAGAIN.localized:
            let request = item?.property?.model
            let service = Service.init(serviceId: request?.service_id, categoryId: request?.to_user?.categoryData?.id)
            switch item?.property?.model?.schedule_type ?? .instant {
            case .instant:
                let destVC = Storyboard<ConfirmBookingVC>.Home.instantiateVC()
                destVC.vendor = request?.to_user
                destVC.service = service
                UIApplication.topVC()?.pushVC(destVC)
            case .schedule:
                let destVC = Storyboard<ChooseDateTimeVC>.Home.instantiateVC()
                destVC.vendor = request?.to_user
                destVC.service = service
                destVC.didSelecteDateTime = { (selectedDateTimeData) in
                    let confirmVC = Storyboard<ConfirmBookingVC>.Home.instantiateVC()
                    confirmVC.vendor = request?.to_user
                    confirmVC.service = service
                    confirmVC.selectedDateTime = selectedDateTimeData
                    UIApplication.topVC()?.pushVC(confirmVC)
                }
                UIApplication.topVC()?.pushVC(destVC)
            }
        case VCLiteral.RESCHEDULE.localized:
            let request = item?.property?.model
            let service = Service.init(serviceId: request?.service_id, categoryId: request?.to_user?.categoryData?.id)
            let destVC = Storyboard<ChooseDateTimeVC>.Home.instantiateVC()
            destVC.vendor = request?.to_user
            destVC.service = service
            destVC.didSelecteDateTime = { (selectedDateTimeData) in
                let confirmVC = Storyboard<ConfirmBookingVC>.Home.instantiateVC()
                confirmVC.vendor = request?.to_user
                confirmVC.service = service
                confirmVC.selectedDateTime = selectedDateTimeData
                confirmVC.requestId = String(/request?.id)
                UIApplication.topVC()?.pushVC(confirmVC)
            }
            UIApplication.topVC()?.pushVC(destVC)
        case VCLiteral.CANCEL_APPOINTMENT.localized:
            UIApplication.topVC()?.alertBoxOKCancel(title: VCLiteral.CANCEL_REQUEST.localized, message: VCLiteral.CANCEL_REQUEST_ALERT.localized, tapped: { [weak self] in
                self?.cancelRequestAPI()
            }, cancelTapped: nil)
        default:
            break
        }
    }
    
    private func cancelRequestAPI() {
        btnCancel.setAnimationType(.BtnAppTintLoader)
        btnCancel.playAnimation()
        EP_Home.cancelRequest(requestId: String(/item?.property?.model?.id)).request(success: { [weak self] (_) in
            self?.item?.property?.model?.status = .canceled
            self?.item?.property?.model?.canCancel = false
            self?.btnCancel.stop()
            self?.didReloadCell?()
        }) { [weak self] (_) in
            self?.btnCancel.stop()
        }
    }
    
}
