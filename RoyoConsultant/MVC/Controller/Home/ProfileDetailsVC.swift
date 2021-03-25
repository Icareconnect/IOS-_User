//
//  EditProfileVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 25/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SZTextView

class ProfileDetailsVC: BaseVC {
        
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblCovid: UILabel!

    private var image_URL: String?
    private var dob: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        initialDataSet()
        
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Update
            pushVC(Storyboard<EditProfileVC>.Home.instantiateVC())
        case 2: //updateWork
            let destVC = Storyboard<WorkEnvironmentVC>.LoginSignUp.instantiateVC()
            destVC.isEdit = true
            pushVC(destVC)
        case 3://Update Covid Environment
            let destVC = Storyboard<CovidFormVC>.LoginSignUp.instantiateVC()
            destVC.comingFrom = .WhileManaging
            pushVC(destVC)
        default:
            break
        }
    }
    
}

//MARK:- VCFuncs
extension ProfileDetailsVC {
    
    private func initialDataSet() {
        let user = UserPreference.shared.data
        lblPhone.text = user?.phone == nil ? "N/A" : (/user?.country_code + "-" + /user?.phone)
        lblEmail.text = /user?.email
      
        var workArr = [Preference]()
        var covidArr = [Preference]()

        for item in user?.master_preferences ?? [] {

            switch /item.preference_type {
            case "work_environment":
                workArr.append(item)
            case "covid":
                covidArr.append(item)

            default:
                break
            }
        }

        var workTitle = [String]()
        workArr.forEach { (work) in
            if let options = work.options {
                options.map({ /$0.option_name }).forEach { (op) in
                    workTitle.append(op)
                }
            }
        }
        
        
        var covidStrArr = [String]()
        for item in covidArr {
            
            if let options = item.options {
                let filterTitle = options.map({ /$0.option_name })
                
                covidStrArr.append("\(/item.preference_name)\n\(filterTitle.joined(separator: ", "))\n\n")
            }
        }
        lblCovid.text = covidStrArr.joined(separator: "")
        
        lblWork.text = workTitle.joined(separator: ", ")
        imgView.setImageNuke(/user?.profile_image, placeHolder: nil)
    }
}
