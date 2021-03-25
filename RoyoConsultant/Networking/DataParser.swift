//
//  DataParser.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//


import Foundation
import Moya

extension TargetType {
    
    func parseModel(data: Data) -> Any? {
        switch self {
        //EP_Login Endpoint
        case is EP_Login:
            let endpoint = self as! EP_Login
            switch endpoint {
            case .login(_, _, _, _, _),
                 .profileUpdate(_, _, _, _, _, _, _, _, _, _, _, _),
                 .register,
                 .updatePhone(_, _, _),
                 .updateWorkPreferences,
                 .updateInsuranceAndAddress(_, _, _, _, _, _, _, _):
                let response = JSONHelper<CommonModel<User>>().getCodableModel(data: data)?.data
                UserPreference.shared.data = response
                return response
            case .getMasterPreferences:
                return JSONHelper<CommonModel<PreferenceData>>().getCodableModel(data: data)?.data

            default:
                return nil
            }
        case is EP_Home:
            let endPoint = self as! EP_Home
            switch endPoint {
            case .categories(_, _):
                return JSONHelper<CommonModel<CategoryData>>().getCodableModel(data: data)?.data
            case .requests(_, _, _):
                return JSONHelper<CommonModel<RequestData>>().getCodableModel(data: data)?.data
            case .logout:
                UserPreference.shared.data = nil
                return nil
            case .vendorList(_, _, _, _, _), .vendorListNew:
                return JSONHelper<CommonModel<VendorData>>().getCodableModel(data: data)?.data
            case .vendorDetail(_):
                return JSONHelper<CommonModel<VendorDetailData>>().getCodableModel(data: data)?.data?.vendor_data
            case .banners:
                return JSONHelper<CommonModel<BannersData>>().getCodableModel(data: data)?.data
            case .chatListing(_):
                return JSONHelper<CommonModel<ChatData>>().getCodableModel(data: data)?.data
            case .chatMessages(_, _):
                return JSONHelper<CommonModel<MessagesData>>().getCodableModel(data: data)?.data
            case .uploadImage(_):
                return JSONHelper<CommonModel<ImageUploadData>>().getCodableModel(data: data)?.data
            case .transactionHistory(_, _):
                return JSONHelper<CommonModel<TransactionData>>().getCodableModel(data: data)?.data
            case .wallet:
                return JSONHelper<CommonModel<WalletBalance>>().getCodableModel(data: data)?.data
            case .addCard(_, _, _, _),
                 .cards:
                return JSONHelper<CommonModel<CardsData>>().getCodableModel(data: data)?.data
            case .createRequest:
                return JSONHelper<CommonModel<CreateRequestData>>().getCodableModel(data: data)?.data
            case .notifications(_):
                return JSONHelper<CommonModel<NotificationData>>().getCodableModel(data: data)?.data
            case .classes(_, _, _):
                return JSONHelper<CommonModel<ClassesData>>().getCodableModel(data: data)?.data
            case .services(_):
                return JSONHelper<CommonModel<ServicesData>>().getCodableModel(data: data)?.data
            case .getFilters:
                return JSONHelper<CommonModel<FilterData>>().getCodableModel(data: data)?.data
            case .getReviews(_, _):
                return JSONHelper<CommonModel<ReviewsData>>().getCodableModel(data: data)?.data
            case .coupons(_, _):
                return JSONHelper<CommonModel<CouponsData>>().getCodableModel(data: data)?.data
            case .confirmRequest, .createRequestNew:
                return JSONHelper<CommonModel<ConfirmBookingData>>().getCodableModel(data: data)?.data
            case .getSlots(_, _, _, _):
                return JSONHelper<CommonModel<SlotsData>>().getCodableModel(data: data)?.data
            case .appversion(_, _):
                let obj = JSONHelper<CommonModel<AppData>>().getCodableModel(data: data)?.data
                return obj
            case .getClientDetail(_):
                let obj = JSONHelper<CommonModel<ClientDetail>>().getCodableModel(data: data)?.data
                UserPreference.shared.clientDetail = obj
                return obj
            case .addMoney(_, _), .completeRequest:
                return JSONHelper<CommonModel<StripeData>>().getCodableModel(data: data)?.data
            case .pages:
                return JSONHelper<CommonModel<PagesData>>().getCodableModel(data: data)?.data?.pages
            case .getCountryStateCity(_, _, _):
                return JSONHelper<CommonModel<CountryStateCityData>>().getCodableModel(data: data)?.data
            case .packages(_, _, _, _),
                 .packageDetail(_),
                 .buyPackage(_):
                return JSONHelper<CommonModel<PackagesData>>().getCodableModel(data: data)?.data
            case .getFeeds(_, _, _),
                 .viewFeed(_):
                return JSONHelper<CommonModel<FeedsData>>().getCodableModel(data: data)?.data
            case .autoAllocate:
                return JSONHelper<CommonModel<AutoAllocateData>>().getCodableModel(data: data)?.data
            case .getMasterDuty:
                return JSONHelper<CommonModel<PreferenceData>>().getCodableModel(data: data)?.data
            case .requestCheck:
                return JSONHelper<CommonModel<RequestCreatedData>>().getCodableModel(data: data)?.data
            case .requestDetail:
                return JSONHelper<CommonModel<RequestDetailsData>>().getCodableModel(data: data)?.data
            case .getAddress:
                return JSONHelper<CommonModel<AddressData>>().getCodableModel(data: data)?.data

            default:
                return nil
            }
        default:
            return nil
        }
        
        
    }
}
