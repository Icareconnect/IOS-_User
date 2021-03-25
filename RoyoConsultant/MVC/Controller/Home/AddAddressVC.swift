//
//  AddAddressVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 14/09/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import JVFloatLabeledTextField
import TagListView

class AddAddressVC: UIViewController {
    
    @IBOutlet weak var lblAddAddress: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblSelectDeliveryAddress: UILabel!
    @IBOutlet weak var lblCurrentLocation: UILabel!
    @IBOutlet weak var tfLocation: JVFloatLabeledTextField!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var tfAddress: JVFloatLabeledTextField!
    @IBOutlet weak var btnAdd: SKLottieButton!
    
    @IBOutlet weak var btnHospital: UIButton!
    @IBOutlet weak var btnPrivateHome: UIButton!
    @IBOutlet weak var btnNursingHome: UIButton!
    @IBOutlet weak var btnCommunityCare: UIButton!
    @IBOutlet weak var btnLongTerm: UIButton!
    
    @IBOutlet var addressListVw: TagListView!
    
    var address: LocationManagerData?
    var didSelected: ((_ addess: LocationManagerData?) -> Void)?
    private var resultsViewController: GMSAutocompleteResultsViewController?
    private var searchController: UISearchController?
    private var saveAs: String?
    private var saveAsPreference: Any?
    
    private var selectedTagsArr = NSMutableArray()// = [PreferenceOption]()
    private var workArr = [Preference]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateAddress(latLng: address ?? LocationManager.shared.locationData)
        moveToCurrentLcoation()
        localizedTextSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for item in UserPreference.shared.data?.master_preferences ?? [] {
            
            switch /item.preference_type {
            case "work_environment":
                workArr.append(item)
            default:
                break
            }
        }
        setUpWorkLocation()
    }
    
    
    func setUpWorkLocation() {
        
        addressListVw.removeAllTags()
        addressListVw.textFont = Fonts.CamptonBook.ofSize(14)
        addressListVw.delegate = self
        
        if let workList = workArr.first?.options {
            for index in 0..<workList.count {
                
                if let value = workList[index] as? PreferenceOption {
                    
                    let tagView = addressListVw.addTag(/value.option_name)
                    tagView.tagBackgroundColor = ColorAsset.backgroundColor.color
                    tagView.textColor = ColorAsset.txtGrey.color
                    tagView.selectedTextColor = ColorAsset.txtWhite.color
                    tagView.highlightedBackgroundColor = ColorAsset.appTint.color
                    
                    tagView.layer.borderWidth = 1.0
                    //                    tagView.borderColor = ColorAsset.txtLightGrey.color
                    tagView.selectedBorderColor = ColorAsset.appTint.color
                    tagView.tag = index
                    
                    if selectedTagsArr.contains(value) {
                        tagView.isSelected = true
                    } else {
                        tagView.isSelected = false
                    }
                }
            }
        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Add
            
            btnAdd.playAnimation()
            if saveAs == nil {
                btnAdd.vibrate()
                Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.SAVE_ADDRESS_TYPE.localized)
                return
            }
            
            EP_Home.saveAddress(address_name: /tfLocation.text, save_as: saveAs, lat: "\(/address?.latitude)", long: "\(/address?.longitude)", house_no: /tfAddress.text, save_as_preference: saveAsPreference).request { [weak self] (response) in
                self?.btnAdd.stop()
                
                if /self?.tfAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    self?.address?.address = "\(/self?.saveAs)\n(\(/self?.tfAddress.text))\n\(/self?.tfLocation.text)"
                    self?.didSelected?(self?.address)
                    self?.popVC()
                } else {
                    self?.address?.address = "\(/self?.saveAs)\n\(/self?.tfLocation.text)"
                    self?.didSelected?(self?.address)
                    self?.popVC()
                }
            } error: { [weak self] (error) in
                self?.btnAdd.stop()
            }
        case 2:
            addPlacePicker()
        default:
            break
        }
    }
    
    @IBAction func btnActionSaveAs(_ sender: UIButton) {
        
        saveAs = /sender.titleLabel?.text
        
        btnHospital.isSelected = false
        btnPrivateHome.isSelected = false
        btnNursingHome.isSelected = false
        btnCommunityCare.isSelected = false
        btnLongTerm.isSelected = false
        
        btnPrivateHome.borderColor = ColorAsset.txtLightGrey.color
        btnHospital.borderColor = ColorAsset.txtLightGrey.color
        btnNursingHome.borderColor = ColorAsset.txtLightGrey.color
        btnCommunityCare.borderColor = ColorAsset.txtLightGrey.color
        btnLongTerm.borderColor = ColorAsset.txtLightGrey.color
        
        btnPrivateHome.backgroundColor = UIColor.clear
        btnHospital.backgroundColor = UIColor.clear
        btnNursingHome.backgroundColor = UIColor.clear
        btnCommunityCare.backgroundColor = UIColor.clear
        btnLongTerm.backgroundColor = UIColor.clear
        
        switch sender.tag {
        case 0://PrivateHome
            btnPrivateHome.isSelected = true
            btnPrivateHome.borderColor = ColorAsset.appTint.color
            btnPrivateHome.backgroundColor = ColorAsset.appTint.color
            
        case 1://Hospital
            btnHospital.isSelected = true
            btnHospital.borderColor = ColorAsset.appTint.color
            btnHospital.backgroundColor = ColorAsset.appTint.color
            
        case 2://Nursing Home
            btnNursingHome.isSelected = true
            btnNursingHome.borderColor = ColorAsset.appTint.color
            btnNursingHome.backgroundColor = ColorAsset.appTint.color
            
        case 3://Community Care
            btnCommunityCare.isSelected = true
            btnCommunityCare.borderColor = ColorAsset.appTint.color
            btnCommunityCare.backgroundColor = ColorAsset.appTint.color
            
        case 4://Long Term Care
            btnLongTerm.isSelected = true
            btnLongTerm.borderColor = ColorAsset.appTint.color
            btnLongTerm.backgroundColor = ColorAsset.appTint.color
            
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension AddAddressVC {
    private func localizedTextSetup() {
        lblAddAddress.text = VCLiteral.SERVICE_ADDRESS.localized
        lblSelectDeliveryAddress.text = VCLiteral.SELECT_DELIVERY_ADDRESS.localized
        lblCurrentLocation.text = VCLiteral.CURRENT_LOCATION.localized
        tfLocation.placeholder = VCLiteral.LOCATION.localized
        tfLocation.isUserInteractionEnabled = false
        btnChange.setTitle(VCLiteral.CHANGE.localized, for: .normal)
        tfAddress.placeholder = VCLiteral.ADDRESS_EXTRA_INFO.localized
        btnAdd.setTitle(VCLiteral.ADD_ADDRESS.localized, for: .normal)
    }
    
    private func moveToCurrentLcoation() {
        let camera = GMSCameraPosition.camera(withLatitude: LocationManager.shared.locationData.latitude,
                                              longitude: LocationManager.shared.locationData.longitude,
                                              zoom: 16)
        mapView.camera = camera
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        
    }
    
    //MARK:- Get Address String from latitude longitude
    private func generateAddress(latLng: LocationManagerData?) {
        let location = CLLocation.init(latitude: /latLng?.latitude, longitude: /latLng?.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placeMarks, error) in
            
            if /placeMarks?.count > 0 {
                let pm = placeMarks![0]
                var addressString : String = ""
                
                if pm.name != nil {
                    addressString = addressString + pm.name! + ", "
                }
                
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                self?.tfLocation.text = addressString
                
                //                print(addressString)
            }
            //            self?.tfLocation.text = /placeMarks?.first?.name
            self?.address = latLng
            self?.address?.locationName = /placeMarks?.first?.name
        }
    }
    
    
    private func addPlacePicker() {
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        resultsViewController?.primaryTextColor = ColorAsset.txtDark.color
        
        // Sets the background of results - second line
        resultsViewController?.secondaryTextColor = ColorAsset.txtDark.color
        
        if #available(iOS 13.0, *) {
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark  {
                resultsViewController?.primaryTextColor = UIColor.white
                resultsViewController?.secondaryTextColor = UIColor.lightGray
                resultsViewController?.tableCellSeparatorColor = UIColor.lightGray
                resultsViewController?.tableCellBackgroundColor = UIColor.darkGray
            } else {
                resultsViewController?.primaryTextColor = UIColor.black
                resultsViewController?.secondaryTextColor = UIColor.lightGray
                resultsViewController?.tableCellSeparatorColor = UIColor.lightGray
                resultsViewController?.tableCellBackgroundColor = UIColor.white
            }
        }
        
        present(searchController ?? UISearchController(), animated: true, completion: nil)
    }
}

//MARK:- GMSMapView Delegate
extension AddAddressVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let latitude = mapView.getCenterCoordinate().latitude
        let longitude = mapView.getCenterCoordinate().longitude
        generateAddress(latLng: LocationManagerData.init(latitude: latitude, longitude: longitude, isLocationAllowed: true))
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        moveToCurrentLcoation()
        return true
    }
}


extension GMSMapView {
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        let centerPoint = center
        let centerCoordinate = projection.coordinate(for: centerPoint)
        return centerCoordinate
    }
    
    func getTopCenterCoordinate() -> CLLocationCoordinate2D {
        // to get coordinate from CGPoint of your map
        let topCenterCoor = convert(CGPoint(x: frame.size.width / 2.0, y: 0), from: self)
        let point = projection.coordinate(for: topCenterCoor)
        return point
    }
    
    func getRadius() -> CLLocationDistance {
        
        let centerCoordinate = getCenterCoordinate()
        // init center location from center coordinate
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterCoordinate = getTopCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
        
        return round(radius)
    }
}

extension AddAddressVC: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        tfLocation.text = /place.name == "" ? /place.formattedAddress : " \(/place.name)" + /place.formattedAddress
        searchController?.searchBar.text = place.formattedAddress
        //        currentLat = "\(/place.coordinate.latitude)"
        //        currentLong = "\(/place.coordinate.longitude)"
        
        self.address?.latitude = /place.coordinate.latitude
        self.address?.longitude = /place.coordinate.longitude
        
        self.address?.locationName = place.formattedAddress
        let camera = GMSCameraPosition.camera(withLatitude: /place.coordinate.latitude,
                                              longitude: /place.coordinate.longitude,
                                              zoom: 16)
        mapView.camera = camera
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        
    }
}
extension AddAddressVC: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        
        if let dict = workArr.first?.options?[tagView.tag] {
            
            selectedTagsArr = NSMutableArray()
            selectedTagsArr.add(dict)
            saveAs = /dict.option_name
            saveAsPreference = JSONHelper<PreferenceOption>().toDictionary(model: dict)
            
            setUpWorkLocation()
        }
    }
}
