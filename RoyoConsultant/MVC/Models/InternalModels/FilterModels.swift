//
//  FilterModels.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 05/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class FilterHeaderProvider: HeaderFooterModelProvider {
    
    typealias CellModelType = FilterCellProvider
    
    typealias HeaderModelType = Filter
    
    typealias FooterModelType = Any
    
    var headerProperty: (identifier: String?, height: CGFloat?, model: Filter?)?
    
    var footerProperty: (identifier: String?, height: CGFloat?, model: Any?)?
    
    var items: [FilterCellProvider]?
    
    required init(_ _header: (identifier: String?, height: CGFloat?, model: Filter?)?, _ _footer: (identifier: String?, height: CGFloat?, model: Any?)?, _ _items: [FilterCellProvider]?) {
        headerProperty = _header
        footerProperty = _footer
        items = _items
    }
    
    class func getFilters(filters: [Filter]?) -> (filters: [FilterHeaderProvider], tableHeight: CGFloat) {
        
        var sections = [FilterHeaderProvider]()
        var tableHeight: CGFloat = 0.0
        
        filters?.forEach({
            let widthOfCell = (UIScreen.main.bounds.width - 80.0) / 2
            let collSizeProvider = CollectionSizeProvider.init(cellSize: CGSize.init(width: widthOfCell, height: 40.0), interItemSpacing: 16.0, lineSpacing: 0, edgeInsets: UIEdgeInsets.init(top: 0, left: 16.0, bottom: 8.0, right: 16.0))
            let tableCellHeight = collSizeProvider.getHeightOfTableViewCell(for: /$0.options?.count, gridCount: 2)
            let sectionHeight: CGFloat = 64.0
            tableHeight += (tableCellHeight + sectionHeight)
            let section = FilterHeaderProvider.init((FilterHeaderView.identfier, sectionHeight, $0), nil, [FilterCellProvider.init((FilterCollectionViewCell.identfier, tableCellHeight, FilterCustomModel.init($0, collSizeProvider)), nil, nil)])
            sections.append(section)
        })
        
        return (sections, tableHeight)
    }
}


class FilterCellProvider: CellModelProvider {
    
    typealias CellModelType = FilterCustomModel
    
    var property: (identifier: String, height: CGFloat, model: FilterCustomModel?)?
    
    var leadingSwipeConfig: SKSwipeActionConfig?
    
    var trailingSwipeConfig: SKSwipeActionConfig?
    
    required init(_ _property: (identifier: String, height: CGFloat, model: FilterCustomModel?)?, _ _leadingSwipe: SKSwipeActionConfig?, _ _trailingSwipe: SKSwipeActionConfig?) {
        property = _property
        leadingSwipeConfig = _leadingSwipe
        trailingSwipeConfig = _trailingSwipe
    }
}

class FilterCustomModel {
    var filter: Filter?
    var collSizeProvider: CollectionSizeProvider?
    
    init(_ _filter: Filter?, _ _collSizeProvider: CollectionSizeProvider?) {
        filter = _filter
        collSizeProvider = _collSizeProvider
    }
}
