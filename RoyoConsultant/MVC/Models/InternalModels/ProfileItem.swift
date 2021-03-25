//
//  ProfileItem.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 02/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//


import UIKit

class ProfileItem {
    var title: VCLiteral?
    var image: UIImage?
    var page: Page?
    
    init(_ _title: VCLiteral, _ _image: UIImage?) {
        title = _title
        image = _image
    }
    
    init(_ _page: Page?, _image: UIImage?) {
        page = _page
        image = _image
    }
    
    class func getItems(pages: [Page]?) -> [ProfileItem] {
        
        var items = [ProfileItem.init(.HISTORY, #imageLiteral(resourceName: "ic_appointment")),
                     ProfileItem.init(.INVITE_PEOPLE, #imageLiteral(resourceName: "ic_invite_drawer"))]
        
        pages?.forEach({ items.append(ProfileItem.init($0, _image: #imageLiteral(resourceName: "ic_info")))})
        
        items.append(ProfileItem.init(.SAVED_CARDS, #imageLiteral(resourceName: "ic_invite_drawer")))
        return items + [/*ProfileItem.init(.PACAKAGES, #imageLiteral(resourceName: "ic_packages")),*/ ProfileItem.init(.LOGOUT, #imageLiteral(resourceName: "ic_logout"))]
    }
}
