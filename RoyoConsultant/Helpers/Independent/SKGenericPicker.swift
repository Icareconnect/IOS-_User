//
//  SKGenericPicker.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

import UIKit

protocol SKGenericPickerModelProtocol {
    
    associatedtype ModelType
    
    var title: String? { get set }
    var model: ModelType? { get set }
    
    init(_ _title: String?, _ _model: ModelType?)
}

class SKGenericPicker<T: SKGenericPickerModelProtocol>: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    typealias DidSelectItem = (_ item: T?) -> ()

    public var configureItem: DidSelectItem?
    private var items: [T]?
    
    public func updateItems(_ _items: [T]?) {
        items = _items
        reloadAllComponents()
    }
    
    init(frame: CGRect, items: [T]?, configureItem: @escaping DidSelectItem) {
        super.init(frame: frame)
        self.configureItem = configureItem
        self.items = items
        super.dataSource = self
        super.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return /items?.count
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items?[row].title
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let item = configureItem {
            if /items?.count != 0 {
                item(items?[row])
            }
        }
    }
}



