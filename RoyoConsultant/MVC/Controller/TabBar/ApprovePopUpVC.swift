//
//  ApprovePopUpVC.swift
//  RoyoConsultant
//
//  Created by Chitresh Goyal on 06/01/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit
import SZTextView

class ApprovePopUpVC: BaseVC {
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var btnApprove: SKLottieButton!
    @IBOutlet weak var btnDecline: SKLottieButton!
    
    @IBOutlet weak var tvReview: SZTextView!
    @IBOutlet weak var tfHours: UITextField!
    
    public var request: Requests?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.unhideVisualEffectView()
        }
        
        EP_Home.requestDetail(request_id: "\(/request?.id)").request(success: { [weak self] (responseData) in
            
            let request = responseData as? RequestDetailsData
            self?.request = request?.request_detail
            self?.tfHours.text = "\(/Int(/self?.request?.total_hours))"
            
        }) { [weak self] (error) in
            self?.btnDecline.stop()
        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Cancel
            hideVisulEffectView()
        case 1: //Approve
            if /tvReview.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                btnApprove.vibrate()
                return
            }
            updateStatusApi("approved")
        case 2: //Decline
            if /tvReview.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                btnApprove.vibrate()
                return
            }
            if /tfHours.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                btnApprove.vibrate()
                Toast.shared.showAlert(type: .success, message: VCLiteral.PROVIDE_WORKING_HOURS.localized)

                return
            }
            updateStatusApi("declined")
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension ApprovePopUpVC {
    private func localizedTextSetup() {
        
        visualEffectView.alpha = 0
        visualEffectView.isHidden = true
        
        tvReview.placeholder = VCLiteral.REVIEW_PLACEHOLDER.localized
        tvReview.textContainerInset = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
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
                //CallBack
            })
        }
    }
    
    private func updateStatusApi(_ status: String) {
        
        if status == "declined" {
            btnApprove.playAnimation()
        } else  {
            btnApprove.playAnimation()
        }
        EP_Home.updateRequestApprovalStatus(valid_hours: /tfHours.text, status: status, requestId: String(/request?.id), comment: tvReview.text).request(success: { [weak self] (_) in
            if status == "declined" {
                self?.btnApprove.stop()
            } else  {
                self?.btnApprove.stop()
            }
            self?.hideVisulEffectView()
        }) { [weak self] (_) in
            if status == "declined" {
                self?.btnApprove.stop()
            } else  {
                self?.btnApprove.stop()
            }
            
        }
    }
}
