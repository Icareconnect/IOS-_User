//
//  WorkEnvironmentVC.swift
//  RoyoConsultantVendor
//
//  Created by Chitresh Goyal on 15/12/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class WorkEnvironmentVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!  {
        didSet {
            tableView.registerXIBForHeaderFooter(WorkHeaderView.identfier)
        }
    }
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnContinue: SKLottieButton!
    
    private var dataSource: TableDataSource<WorkHeaderProvider, WorkCellProvider, PreferenceOption>?
    private var categories = [WorkHeaderProvider]()
    
    private var preferenceId = String()
    public var isEdit: Bool?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblHeaderTitle.text = VCLiteral.WorkEnvironment.localized
        tableViewInit()
    }
    
    //MARK: - IBActions
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        //TODO:
        
        var prefs = [[String : Any]]()
        var isError = false
        
        categories.forEach({ (category) in
            let ids = category.headerProperty?.model?.options?.filter({/$0.isSelected}).compactMap({/$0.id}) ?? []
            if /category.headerProperty?.model?.is_required == 1 && /ids.count == 0 {
                isError = true

            }            
            let preference = ["option_ids": ids, "preference_id": "\(/category.headerProperty?.model?.id)"] as [String : Any]
            prefs.append(preference)
        })
        
        if isError {
            Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.WORK_ENVIRONMENT_ERROR.localized)
            
            return
        }
        
        var myJsonString = ""
        do {
            let data =  try JSONSerialization.data(withJSONObject: prefs, options: .prettyPrinted)
            myJsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            print(error.localizedDescription)
        }
        
        btnContinue.playAnimation()
        EP_Login.updateWorkPreferences(master_preferences: myJsonString).request(success: { [weak self] (response) in
            self?.view.isUserInteractionEnabled = true
            self?.btnContinue.stop()
            
            if !(/self?.isEdit) {
//                UIWindow.replaceRootVC(Storyboard<NavgationTabVC>.TabBar.instantiateVC())
                let destVC = Storyboard<CovidFormVC>.LoginSignUp.instantiateVC()
                self?.pushVC(destVC)

            } else {
                self?.popVC()
            }
        }) { [weak self] (error) in
            self?.view.isUserInteractionEnabled = true
            self?.btnContinue.stop()
        }
    }
}
extension WorkEnvironmentVC {
    
    private func setupViews() {
        
        var workArr = [Preference]()
        
        for item in UserPreference.shared.data?.master_preferences ?? [] {
            
            switch /item.preference_type {
            case "work_environment", "Hospital", "Service Location /Conditions":
                workArr.append(item)
            default:
                break
            }
        }
        //        self.categories.forEach({ (category) in
        //            category.isSelected = workArr.first?.options?.contains(where: {/$0.id == /category.id})
        //        })
        //
        //
        //        dataSource?.updateAndReload(for: .SingleListing(items: categories ), .FullReload)
        //        dataSource?.stopInfiniteLoading(.FinishLoading)
        
    }
    
    private func tableViewInit() {
        
        dataSource = TableDataSource<WorkHeaderProvider, WorkCellProvider, PreferenceOption>.init(.MultipleSection(items: categories), tableView)
        
        dataSource?.configureHeaderFooter = { (section, item, view) in
            (view as? WorkHeaderView)?.item = item
            (view as? WorkHeaderView)?.didTapSelectAll = { [weak self] in
                item.headerProperty?.model?.isSelectedAll = !(/item.headerProperty?.model?.isSelectedAll)
                
                if /item.headerProperty?.model?.isSelectedAll {
                    self?.categories[section].items?.forEach({ (category) in
                        category.property?.model?.isSelected = true
                    })
                } else {
                    self?.categories[section].items?.forEach({ (category) in                        category.property?.model?.isSelected = false
                    })
                }
                self?.tableView.reloadData()
                
            }
        }
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? WorkCell)?.item = item
        }
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getMasterPreferences()
        }
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            
            let items = self?.categories[indexPath.section].items?[indexPath.row]
            items?.property?.model?.isSelected = !(/items?.property?.model?.isSelected)
            
            self?.tableView.reloadData()
        }
        dataSource?.refreshProgrammatically()
    }
    
    
    private func getMasterPreferences() {
        EP_Login.getMasterPreferences(type: "All", preference_type: "work_environment").request(success: { [weak self] (responseData) in
            
            let docTypes = (responseData as? PreferenceData)?.preferences
            self?.setupViews()
            var workArr = [Preference]()
            
            for item in UserPreference.shared.data?.master_preferences ?? [] {
                
                switch /item.preference_type {
                case "work_environment":
                    workArr.append(item)
                default:
                    break
                }
            }
            docTypes?.forEach({ (pref) in
                pref.options?.forEach({ (option) in
                    workArr.forEach({ (prefre) in
                        
                        let arr = prefre.options?.filter({/$0.id == /option.id})
                        if /arr?.count > 0 {
                            option.isSelected = /arr?.first?.isSelected
                        }
                    })
                })
            })
            self?.categories = WorkHeaderProvider.getSectionWiseData(docTypes)
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.categories ?? []), .FullReload)
            
        }) { [weak self] (error) in
            
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            self?.stopLineAnimation()
            if /self?.categories.count == 0 {
                self?.showErrorView(error: /error, scrollView: self?.tableView, tapped: {
                    self?.errorView.removeFromSuperview()
                    self?.dataSource?.refreshProgrammatically()
                })
            }
        }
    }
}
