//
//  RegisterNurseVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 03/09/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import FSCalendar
import SZTextView

class RegisterNurseVC: BaseVC {
    
    @IBOutlet weak var viewMain: UIView! {
        didSet {
            viewMain.roundCorners(with: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 24)
        }
    }
    @IBOutlet weak var calendarView: FSCalendar! {
        didSet {
            calendarView.scope = .week
            calendarView.appearance.separators = .interRows
            calendarView.scrollDirection = .horizontal
            calendarView.appearance.weekdayFont = Fonts.CamptonMedium.ofSize(14.0)
            calendarView.appearance.titleFont = Fonts.CamptonBook.ofSize(14.0)
            calendarView.allowsMultipleSelection = true
            calendarView.delegate = self
            calendarView.dataSource = self
        }
    }
    @IBOutlet weak var lblAppt: UILabel!
    @IBOutlet weak var lblMonthTitle: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var tfFrom: UITextField!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var tfTo: UITextField!
    @IBOutlet weak var tvReasonForService: SZTextView!
    @IBOutlet weak var btnBook: SKLottieButton!
    @IBOutlet weak var lblHeaderTitl: UILabel!
    
    var interMediateData: RegisterCatModel?
    var minimumStartDate: Date? = nil
    var minimumEndDate: Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        setupPicker()
    }
    func setupPicker() {
        
        tfFrom.inputView = SKDatePicker.init(frame: .zero, mode: .time, maxDate: nil, minDate: minimumStartDate, interval: /Int(/UserPreference.shared.clientDetail?.slot_duration), configureDate: { [weak self] (date) in
            self?.tfFrom.text = date.toString(DateFormat.custom("hh:mm a"), timeZone: .local)
            self?.interMediateData?.startTime = date
            let calendar = Calendar.current
            let finlDate = calendar.date(byAdding: .minute, value: /Int(/UserPreference.shared.clientDetail?.booking_delay) + 1, to: date)
            self?.tfTo.text = ""
            self?.interMediateData?.endTime = nil
            
            self?.minimumEndDate = finlDate ?? Date()
            self?.setupPicker()
            
        })
        
        tfTo.inputView = SKDatePicker.init(frame: .zero, mode: .time, maxDate:  nil, minDate: minimumEndDate, interval: /Int(/UserPreference.shared.clientDetail?.slot_duration),configureDate: { [weak self] (date) in
            self?.tfTo.text = date.toString(DateFormat.custom("hh:mm a"), timeZone: .local)
            self?.interMediateData?.endTime = date
            
        })
    }
    @IBAction func actionBack(_ sender: UIButton) {
        popVC()
    }
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Previos Month
            break
        case 1: //Next Month
            break
        case 2: //Book Appointment
            if calendarView.selectedDate == nil {
                Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.CALENDAR_DATE_ALERT.localized)
                btnBook.vibrate()
                return
            } else if /tfFrom.text == "" {
                Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.START_TIME_ALERT.localized)
                btnBook.vibrate()
                return
            } else if /tfTo.text == "" {
                Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.END_TIME_ALERT.localized)
                btnBook.vibrate()
                return
            }
//            else if /tvReasonForService.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
//                Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.ROS_ALERT.localized)
//                btnBook.vibrate()
//                return
//            }
            let dateDiff = findDateDiff(time1Str: /tfFrom.text, time2Str: /tfTo.text)
            let hours = dateDiff * /calendarView.selectedDates.count
            
            if hours < 4 {
                Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.BOOKING_HOURS_ERROR.localized)
                return
            }
            interMediateData?.startDate = calendarView.selectedDates
            interMediateData?.endDate = calendarView.selectedDates
            interMediateData?.ros = tvReasonForService.text
            
            let destVC = Storyboard<VendorListingVC>.Home.instantiateVC()
            destVC.interMediateData = interMediateData
            
            pushVC(destVC)
            
            
        //TODO:
        //            let destVC = Storyboard<RequestProcessVC>.Home.instantiateVC()
        //            destVC.modalPresentationStyle = .overFullScreen
        //            destVC.interMediateData = interMediateData
        //            destVC.didSuccess = { (response) in
        //                if let vendor = response?.doctor_data {
        //                    let destVC = Storyboard<AllocatedNursePopUpVC>.PopUp.instantiateVC()
        //                    destVC.modalPresentationStyle = .overFullScreen
        //                    destVC.vendor = vendor
        //                    destVC.didClosePopUp = {
        //                        self.popTo(toControllerType: HomeVC.self)
        //                    }
        //                    self.presentVC(destVC)
        //                } else {
        //                    self.alertWithDesc(desc: VCLiteral.NO_NURSE_FOUND.localized)
        //                }
        //            }
        //            presentVC(destVC)
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension RegisterNurseVC {
    private func localizedTextSetup() {
        lblAppt.text = VCLiteral.APPOINTMENTS.localized
        lblStartTime.text = VCLiteral.START_TIME.localized
        lblEndTime.text = VCLiteral.END_TIME.localized
        tfFrom.placeholder = VCLiteral.FROM.localized
        tfTo.placeholder = VCLiteral.TO.localized
        tvReasonForService.placeholder = VCLiteral.ROS.localized
        btnBook.setTitle(VCLiteral.BOOK_APPT.localized, for: .normal)
        lblHeaderTitl.text = VCLiteral.APPOINTMENT_DETAILS.localized
        
        lblMonthTitle.text = Date().toString(DateFormat.custom("MMM yyyy"), timeZone: .local)
        
        calendarView.reloadData()
    }
    
    
}
extension RegisterNurseVC: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let calendar = Calendar.current
        let finlDate = calendar.date(byAdding: .day, value: 1, to: date) ?? Date()
        
        if finlDate.compare(Date()) == .orderedAscending {
            return false
        } else {
            return true
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        validatesDates(true, selectedDate: date)
        
    }
    private func validatesDates(_ isSelect: Bool, selectedDate: Date?) {
        var containsToday = false
        calendarView.selectedDates.forEach { (date) in
            if date.toString(DateFormat.custom("dd MMM yyyy"), timeZone: .local) == Date().toString(DateFormat.custom("dd MMM yyyy"), timeZone: .local) {
                containsToday = true
                
                if isSelect && /selectedDate?.toString(DateFormat.custom("dd MMM yyyy"), timeZone: .local) == Date().toString(DateFormat.custom("dd MMM yyyy"), timeZone: .local) {
                    
                    self.tfTo.text = ""
                    self.interMediateData?.endTime = nil
                    self.tfFrom.text = ""
                    self.interMediateData?.startTime = nil
                    self.view.endEditing(true)
                }
            }
        }
        if (containsToday) {
            let calendar = Calendar.current
            let finlDate = calendar.date(byAdding: .hour, value: /Int(/UserPreference.shared.clientDetail?.booking_delay), to: Date())
            
            minimumStartDate = finlDate ?? Date()
        } else {
            minimumStartDate = nil
        }
        setupPicker()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        validatesDates(false, selectedDate: date)
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        lblMonthTitle.text = calendar.currentPage.shortMonthToString() + " \(calendar.currentPage.year())"
    }
}
extension RegisterNurseVC {
    
    func findDateDiff(time1Str: String, time2Str: String) -> Int {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "hh:mm a"

        guard let time1 = timeformatter.date(from: time1Str),
            let time2 = timeformatter.date(from: time2Str) else { return 0 }

        //You can directly use from here if you have two dates

        let interval = time2.timeIntervalSince(time1)
        let hour = /Int(interval / 3600)
        
        return hour
//        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
//        let intervalInt = Int(interval)
        
//        return "\(intervalInt < 0 ? "-" : "+") \(Int(hour)) Hours \(Int(minute)) Minutes"
    }
}
