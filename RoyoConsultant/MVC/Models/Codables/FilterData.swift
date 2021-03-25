//
//  FilterData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 04/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class FilterData: Codable {
    var filters: [Filter]?
}

class Filter: Codable {
    var id: Int?
    var category_id: Int?
    var filter_name: String?
    var preference_name: String?
    var is_multi: CustomBool?
    var options: [FilterOption]?
    
    class func generateNewReferenceArray(filters: [Filter]) -> [Filter] {
        var items = [Filter]()
        filters.forEach { items.append(Filter.init(obj: $0)) }
        return items
    }
    
    init(obj: Filter?) {
        id = obj?.id
        category_id = obj?.category_id
        filter_name = obj?.filter_name
        preference_name = obj?.preference_name
        is_multi = obj?.is_multi
        var newOptions = [FilterOption]()
        obj?.options?.forEach { newOptions.append(FilterOption.init(obj: $0)) }
        options = newOptions
    }
}

class FilterOption: Codable {
    var id: Int?
    var option_name: String?
    var filter_type_id: Int?
    var isSelected: Bool?
    
    init(obj: FilterOption?) {
        id = obj?.id
        option_name = obj?.option_name
        filter_type_id = obj?.filter_type_id
        isSelected = obj?.isSelected
    }
}
