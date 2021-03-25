//
//  CountryStateCity.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class CountryStateCityData: Codable {
    private var state: [State]?
    private var city: [City]?
    
    func getStates() -> [PickerStateModel] {
        var array = [PickerStateModel]()
        state?.forEach{ array.append(PickerStateModel.init(/$0.name, $0))}
        return array
    }
    
    func getCities() -> [PickerCityModel] {
        var array = [PickerCityModel]()
        city?.forEach{ array.append(PickerCityModel.init($0.name, $0)) }
        return array
    }
}

class State: Codable {
    var id: Int?
    var name: String?
    
    init(_ _id: Int?, _ _name: String?) {
        id = _id
        name = _name
    }
}

class City: Codable {
    var id: Int?
    var name: String?
    
    init(_ _id: Int?, _ _name: String?) {
        id = _id
        name = _name
    }
}


class PickerCityModel: SKGenericPickerModelProtocol {
    
    typealias ModelType = City

    var title: String?
    
    var model: City?
    
    required init(_ _title: String?, _ _model: City?) {
        title = _title
        model = _model
    }
}

class PickerStateModel: SKGenericPickerModelProtocol {
    
    typealias ModelType = State

    var title: String?
    
    var model: State?
    
    required init(_ _title: String?, _ _model: State?) {
        title = _title
        model = _model
    }
}
