//
//  VendorDetailModels.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 19/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class VD_HeaderFooter_Provider: HeaderFooterModelProvider {
    
    typealias CellModelType = VD_Cell_Provider
    
    typealias HeaderModelType = VD_Header_Modal
    
    typealias FooterModelType = Any
    
    var headerProperty: (identifier: String?, height: CGFloat?, model: VD_Header_Modal?)?
    
    var footerProperty: (identifier: String?, height: CGFloat?, model: Any?)?
    
    var items: [VD_Cell_Provider]?
    
    required init(_ _header: (identifier: String?, height: CGFloat?, model: VD_Header_Modal?)?, _ _footer: (identifier: String?, height: CGFloat?, model: Any?)?, _ _items: [VD_Cell_Provider]?) {
        headerProperty = _header
        footerProperty = _footer
        items = _items
    }
    
    class func getItems(_ vendor: User?) -> [VD_HeaderFooter_Provider] {
        var items = [VD_HeaderFooter_Provider]()
        
//        if /vendor?.services?.count != 0 {
//            
//            let widthOfBtn = (UIScreen.main.bounds.width - 48.0) / 2.0
//            let heightOfBtn = widthOfBtn * 0.39024
//            
//            let collectionTopSpace: CGFloat = 16.0
//            let collectionBottomSpace: CGFloat = 16.0
//            let interItemSpacing: CGFloat = 16.0
//            let numberOfDualRows = round((CGFloat(/vendor?.services?.count) / 2.0) + 0.1)
//            let heightOfTVCell = (numberOfDualRows * heightOfBtn) + (interItemSpacing * (numberOfDualRows - 1.0)) + collectionTopSpace + collectionBottomSpace
//            
//            items.append(VD_HeaderFooter_Provider.init(nil, nil, [VD_Cell_Provider.init((VendorDetailCollectionTVCell.identfier, heightOfTVCell, VD_Modal.init(vendor?.services, nil, nil, _vendor: vendor)), nil, nil)]))
//        }
        
        items.append(VD_HeaderFooter_Provider.init((VendorDetailHeaderView.identfier, 40.0, VD_Header_Modal.init(VCLiteral.ABOUT.localized, nil)), nil, [VD_Cell_Provider.init((AboutCell.identfier, UITableView.automaticDimension, VD_Modal.init(nil, vendor?.profile?.bio, nil, _vendor: vendor)), nil, nil)]))
        
        var workArr = [Preference]()
        var personalInterestArr = [Preference]()
        var covidArr = [Preference]()
        var servicesArr = [Preference]()

        for item in vendor?.master_preferences ?? [] {
            
            switch /item.preference_type {
            case "work_environment":
                workArr.append(item)
            case "personal_interest":
                personalInterestArr.append(item)
            case "covid":
                covidArr.append(item)
            case "duty":
                servicesArr.append(item)
            default:
                break
            }
        }
        if workArr.count > 0 {
            if let options = workArr[0].options {
                let filterTitle = options.map({ /$0.option_name })
                
                items.append(VD_HeaderFooter_Provider.init((VendorDetailHeaderView.identfier, 40.0, VD_Header_Modal.init(VCLiteral.WorkEnvironmentCondition.localized, nil)), nil, [VD_Cell_Provider.init((AboutCell.identfier, UITableView.automaticDimension, VD_Modal.init(nil, filterTitle.joined(separator: ", "), nil, _vendor: vendor)), nil, nil)]))
                
            }
        }
        
        if let filters = vendor?.filters, filters.count > 0 {
            if let options = filters[0].options {
                let filterTitle = (options.filter({ /$0.isSelected }).compactMap( { $0.option_name } ))

                items.append(VD_HeaderFooter_Provider.init((VendorDetailHeaderView.identfier, 40.0, VD_Header_Modal.init("Expertise", nil)), nil, [VD_Cell_Provider.init((AboutCell.identfier, UITableView.automaticDimension, VD_Modal.init(nil, filterTitle.joined(separator: ", "), nil, _vendor: vendor)), nil, nil)]))
                
            }
        }
                
        if personalInterestArr.count > 0 {
            if let options = personalInterestArr[0].options {
                let filterTitle = options.map({ /$0.option_name })
                
                items.append(VD_HeaderFooter_Provider.init((VendorDetailHeaderView.identfier, 40.0, VD_Header_Modal.init(VCLiteral.PersoanlInterest.localized, nil)), nil, [VD_Cell_Provider.init((AboutCell.identfier, UITableView.automaticDimension, VD_Modal.init(nil, filterTitle.joined(separator: ", "), nil, _vendor: vendor)), nil, nil)]))
                
            }
        }
        
//        if servicesArr.count > 0 {
//            if let options = servicesArr[0].options {
//                let filterTitle = options.map({ /$0.option_name })
//
//                items.append(VD_HeaderFooter_Provider.init((VendorDetailHeaderView.identfier, 40.0, VD_Header_Modal.init(VCLiteral.ProvidableServices.localized, nil)), nil, [VD_Cell_Provider.init((AboutCell.identfier, UITableView.automaticDimension, VD_Modal.init(nil, filterTitle.joined(separator: ", "), nil, _vendor: vendor)), nil, nil)]))
//
//            }
//        }
        
//        var covidStrArr = [String]()
//        for item in covidArr {
//
//            if let options = item.options {
//                let filterTitle = options.map({ /$0.option_name })
//
//                covidStrArr.append("\(/item.preference_name)\n\(filterTitle.joined(separator: ", "))\n\n")
//            }
//        }
//
//        items.append(VD_HeaderFooter_Provider.init((VendorDetailHeaderView.identfier, 40.0, VD_Header_Modal.init(VCLiteral.Covid.localized, nil)), nil, [VD_Cell_Provider.init((AboutCell.identfier, UITableView.automaticDimension, VD_Modal.init(nil, covidStrArr.joined(separator: ""), nil, _vendor: vendor)), nil, nil)]))
        
        return items
    }
    
    class func getReviewsSection(_ vendor: User?, reviews: [Review]?) -> VD_HeaderFooter_Provider {
        var cellItems = [VD_Cell_Provider]()
        reviews?.forEach {
            cellItems.append(VD_Cell_Provider.init((ReviewCell.identfier, UITableView.automaticDimension, VD_Modal.init(nil, nil, $0, _vendor: vendor)), nil, nil))
        }
        
        let section = VD_HeaderFooter_Provider.init((VendorDetailHeaderView.identfier, 40.0, VD_Header_Modal.init(VCLiteral.REVIEWS.localized, vendor?.totalRating)), nil, cellItems)
        
        return section
    }
    
}

class VD_Cell_Provider: CellModelProvider {
    
    typealias CellModelType = VD_Modal
    
    var property: (identifier: String, height: CGFloat, model: VD_Modal?)?
    
    var leadingSwipeConfig: SKSwipeActionConfig?
    
    var trailingSwipeConfig: SKSwipeActionConfig?
    
    required init(_ _property: (identifier: String, height: CGFloat, model: VD_Modal?)?, _ _leadingSwipe: SKSwipeActionConfig?, _ _trailingSwipe: SKSwipeActionConfig?) {
        property = _property
        leadingSwipeConfig = _leadingSwipe
        trailingSwipeConfig = _trailingSwipe
    }
    
}

class VD_Modal {
    var subscriptions: [Service]?
    var about: String?
    var review: Review?
    var vendor: User?
    
    init(_ _subs: [Service]?, _ _about: String?, _ _review: Review?, _vendor: User?) {
        subscriptions = _subs
        about = _about
        review = _review
        vendor = _vendor
    }
}

class VD_Header_Modal {
    var title: String?
    var rating: Double?
    
    init(_ _title: String?, _ _rating: Double?) {
        title = _title
        rating = _rating
    }
}
