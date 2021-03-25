//
//  RequestProcessVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 15/09/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class RequestProcessVC: BaseVC {
    
    @IBOutlet weak var btn: SKLottieButton!
    @IBOutlet weak var lblText: UILabel!
    
    var interMediateData: RegisterCatModel?
    var didSuccess: ((_ response: AutoAllocateData?) -> Void)?
    var transactionResponse: StripeData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn.setAnimationType(.BtnAppTintLoader)
        btn.playAnimation()
        
        lblText.text = VCLiteral.COMPLETING_PAYMENT.localized
        apiRequestCheck()
    }
    
    private func apiRequestCheck() {
        EP_Home.requestCheck(transaction_id: transactionResponse?.transaction_id).request(success: { [weak self] (response) in
            
            let data = response as? RequestCreatedData
            
            if /data?.isRequestCreated {
                self?.btn.stop()

                self?.dismiss(animated: true, completion: {
                    self?.didSuccess?(response as? AutoAllocateData)
                    Toast.shared.showAlert(type: .success, message: VCLiteral.APPOINTMENT_CREATED.localized)
                })
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self?.apiRequestCheck()
                }
            }
        }) { [weak self] (error) in
            self?.btn.stop()
        }
    }
    
}
