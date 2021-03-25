//
//  ConfirmBookingVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 09/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ConfirmBookingVC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblVendorExtraInfo: UILabel!
    @IBOutlet weak var lblBookingDetailsTitle: UILabel!
    @IBOutlet weak var lblAptDateTimeTitle: UILabel!
    @IBOutlet weak var lblAptDateTime: UILabel!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhoneNumberTitle: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var tfCoupon: UITextField!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var lblPriceDetailsTitle: UILabel!
    @IBOutlet weak var lblSubTotalTitle: UILabel!
    @IBOutlet weak var lblPromoAppliedTitle: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblPromoApplied: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var btnConfirm: SKLottieButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    public var vendor: User?
    public var service: Service?
    public var selectedDateTime: SelectedDateTime?
    public var requestId: String? //user for rescheduling
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        initialSetup()
        getConfirmRequestAPI()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Date and Time Edit
            let destVC = Storyboard<ChooseDateTimeVC>.Home.instantiateVC()
            destVC.service = service
            destVC.vendor = vendor
            destVC.selectedDateTime = selectedDateTime
            destVC.didSelecteDateTime = { [weak self] (dateTime) in
                self?.selectedDateTime = dateTime
                self?.getConfirmRequestAPI()
            }
            pushVC(destVC)
        case 2: //Apply Code
            view.endEditing(true)
            getConfirmRequestAPI()
        case 3: //Confirm Booking
            if /lblAptDateTime.text == "" {
                btnConfirm.vibrate()
                return
            }
            createRequestAPI()
        default:
            break
        }
    }
    
}

//MARK:- VCFuncs
extension ConfirmBookingVC {
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.CONFIRM_BOOKING.localized
        lblBookingDetailsTitle.text = VCLiteral.BOOKING_DETAILS.localized
        lblAptDateTimeTitle.text = VCLiteral.APPT_DATE_TIME.localized
        lblEmailTitle.text = VCLiteral.EMAIL_PLACEHOLDER.localized
        lblPhoneNumberTitle.text = VCLiteral.PHONE_NUMBER.localized
        tfCoupon.placeholder = VCLiteral.COUPON_PLACEHOLDER.localized
        btnApply.setTitle(VCLiteral.APPLY.localized, for: .normal)
        lblPriceDetailsTitle.text = VCLiteral.PRICE_DETAILS.localized
        lblSubTotalTitle.text = VCLiteral.SUB_TOTAL.localized
        lblPromoAppliedTitle.text = VCLiteral.PROMO_APPLIED.localized
        lblSubTotalTitle.text = VCLiteral.TOTAL.localized
        lblTerms.text = VCLiteral.TERMS_CONFIRM_BOOKING.localized
        btnConfirm.setTitle(VCLiteral.CONFIRM_BOOKING.localized, for: .normal)
        btnEdit.setTitle(VCLiteral.EDIT_SLOT.localized, for: .normal)
        lblAptDateTime.text = nil
        lblTotal.text = nil
        lblSubTotal.text = nil
        lblPromoApplied.text = nil
        btnEdit.isHidden = selectedDateTime == nil
    }
    
    private func initialSetup() {
        imgView.setImageNuke(/vendor?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
        lblName.text = /vendor?.name?.capitalizingFirstLetter()
        lblVendorExtraInfo.text = /vendor?.categoryData?.name?.capitalizingFirstLetter()
        lblEmail.text = /vendor?.email
        lblPhoneNumber.text = "\(/vendor?.country_code)-\(/vendor?.phone)"
    }
    
    private func getConfirmRequestAPI() {
        var date: String?
        var time: String?
        var scheduleType: ScheduleType = .instant
        if let selectedSlot = selectedDateTime {
            date = selectedSlot.selectedDate?.toString(DateFormat.custom("yyyy-MM-dd"), timeZone: .local)
            time = Date.init(fromString: /selectedSlot.selectedTime?.uppercased(), format: DateFormat.custom("hh:mm a")).toString(DateFormat.custom("HH:mm"), timeZone: .local)
            scheduleType = .schedule
        }
        playLineAnimation()
        EP_Home.confirmRequest(consultantId: String(/vendor?.id), date: date, time: time, serviceId: String(/service?.service_id), scheduleType: scheduleType, couponCode: tfCoupon.text, requestId: requestId).request(success: { [weak self] (responseData) in
            let response = responseData as? ConfirmBookingData
            self?.setConfirmRequestData(response)
            self?.stopLineAnimation()
        }) { [weak self] (_) in
            self?.tfCoupon.text = nil
            self?.stopLineAnimation()
        }
    }
    
    private func createRequestAPI() {
        btnConfirm.playAnimation()
        var date: String?
        var time: String?
        var scheduleType: ScheduleType = .instant
        if let selectedSlot = selectedDateTime {
            date = selectedSlot.selectedDate?.toString(DateFormat.custom("yyyy-MM-dd"), timeZone: .local)
            time = Date.init(fromString: /selectedSlot.selectedTime?.uppercased(), format: DateFormat.custom("hh:mm a")).toString(DateFormat.custom("HH:mm"), timeZone: .local)
            scheduleType = .schedule
        }
        
        EP_Home.createRequest(consultant_id: String(/vendor?.id), date: date, time: time, service_id: String(/service?.service_id), schedule_type: scheduleType, coupon_code: tfCoupon.text, request_id: requestId).request(success: { [weak self] (responseData) in
            self?.btnConfirm.stop()
            if /(responseData as? CreateRequestData)?.amountNotSufficient {
                self?.showInvalidBalanceAlert()
            } else {
                Toast.shared.showAlert(type: .success, message: VCLiteral.REQUEST_SENT_SUCCESS.localized)
                self?.popVC()
                UserPreference.shared.didAddedOrModifiedBooking = true
            }
        }) { [weak self] (error) in
            self?.btnConfirm.stop()
        }
    }
    
    private func showInvalidBalanceAlert() {
        let minimumAmount = /(200.0).getFormattedPrice()
        UIApplication.topVC()?.alertBox(title: VCLiteral.WALLET_ALERT.localized, message: String(format: VCLiteral.WALLET_ALERT_MESSAGE.localized, minimumAmount), btn1: VCLiteral.ADD_MONEY.localized, btn2: VCLiteral.CANCEL.localized, tapped1: {
            let destVC = Storyboard<AddMoneyVC>.Home.instantiateVC()
            self.pushVC(destVC)
        }, tapped2: nil)
    }
    
    private func setConfirmRequestData(_ data: ConfirmBookingData?) {
        lblSubTotal.text = /data?.total?.getFormattedPrice()
        lblTotal.text = /data?.grand_total?.getFormattedPrice()
        lblPromoApplied.text = (/data?.discount == 0.0 ? "" : "-") + /data?.discount?.getFormattedPrice()
        let date = /Date.init(fromString: /data?.book_slot_date, format: DateFormat.custom("yyyy-MM-dd")).toString(DateFormat.custom("E · d MMM yyyy"), timeZone: .local)
        let time = /Date.init(fromString: /data?.book_slot_time?.uppercased(), format: DateFormat.custom("hh:mm a")).toString(DateFormat.custom(" · hh:mm a"), timeZone: .local)
        lblAptDateTime.text = date + time
    }
}
