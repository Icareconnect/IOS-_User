//
//  AddMoneyVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class AddMoneyVC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblInputAmount: UILabel!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var btnAmount1: UIButton!
    @IBOutlet weak var btnAmount2: UIButton!
    @IBOutlet weak var btnAmount3: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerXIBForHeaderFooter(PaymentHeaderView.identfier)
        }
    }
    
    @IBOutlet weak var vwAmount: UIView!
    private var dataSource: TableDataSource<PaymentHeaderProvider, PaymentCellProvider, PaymentCellModel>?
    private var items: [PaymentHeaderProvider] = PaymentHeaderProvider.getInitialItems()
    var interMediateData: RegisterCatModel?
    var bookingData: ConfirmBookingData?
    
    var isManaging: Bool?
    //MARK: - 
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        tableViewInit()
        getCardsAPI()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Proceed to payment
            break
        case 2: //Amount 1
            tfAmount.text = "\(AddMoneyAmounts.Amount1.rawValue)"
            updatePriceInsideCell(price: /tfAmount.text)
        case 3: //Amount 2
            tfAmount.text = "\(AddMoneyAmounts.Amount2.rawValue)"
            updatePriceInsideCell(price: /tfAmount.text)
        case 4: //Amount 3
            tfAmount.text = "\(AddMoneyAmounts.Amount3.rawValue)"
            updatePriceInsideCell(price: /tfAmount.text)
        default:
            break
        }
    }
    
    @IBAction func tfTxtChangeAction(_ sender: UITextField) {
        updatePriceInsideCell(price: /sender.text)
    }
}

//MARK:- VCFuncs
extension AddMoneyVC {
    
    private func updatePriceInsideCell(price: String) {
        if let selectedSectionIndex: Int = items.firstIndex(where: {/$0.headerProperty?.model?.isSelected}) {
            items[selectedSectionIndex].items?.first?.property?.model?.priceToPay = price.trimmingCharacters(in: .whitespacesAndNewlines)
            dataSource?.updateAndReload(for: .MultipleSection(items: items), .Reload(indexPaths: [IndexPath.init(row: 0, section: selectedSectionIndex)], animation: .none))
        }
    }
    
    private func getCardsAPI() {
        EP_Home.cards.request(success: { [weak self] (responseData) in
            let cards = (responseData as? CardsData)?.cards
            
            self?.items = PaymentHeaderProvider.getInitialItems()
            self?.items = PaymentHeaderProvider.getCardItems(cards) + (self?.items ?? [])
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .FullReload)
        }) { (error) in
            
        }
    }
    
    private func tableViewInit() {
        
        tableView.contentInset.top = 16.0
        
        dataSource = TableDataSource<PaymentHeaderProvider, PaymentCellProvider, PaymentCellModel>.init(.MultipleSection(items: items), tableView)
        
        dataSource?.configureHeaderFooter = { (section, item, view) in
            (view as? PaymentHeaderView)?.item = item
            (view as? PaymentHeaderView)?.didSelectHeader = { [weak self] (headerModel) in
                self?.handleHeaderTap(headerModel, section: section)
            }
        }
        
        dataSource?.configureCell = { [weak self] (cell, item, indexPath) in
            
            (cell as? PayWithExistingCardCell)?.isManaging = /self?.isManaging
            (cell as? PayWithExistingCardCell)?.item = item
            (cell as? PayWithExistingCardCell)?.cardDeleted = {
                self?.items.remove(at: indexPath.section)
                self?.getCardsAPI()
                
                self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .DeleteSection(indexSet: IndexSet.init(integer: indexPath.section), animation: .automatic))
            }
            (cell as? PayWithExistingCardCell)?.pay = {
                self?.paymentApi(item, button: (cell as? PayWithExistingCardCell)?.btnPay ?? SKLottieButton())
            }
            (cell as? PayWithNewCardCell)?.item = item
            (cell as? PayWithNewCardCell)?.cardAdded = {
                self?.getCardsAPI()
            }
        }
    }
    
    private func paymentApi(_ item: PaymentCellProvider?, button: SKLottieButton) {
        button.playAnimation()
        
//        let dates = interMediateData?.startDate.flatMap({$0.toString(DateFormat.custom("yyyy-MM-dd"), timeZone: .local)})
                    
        let dates = interMediateData?.startDate.flatMap({$0})
               
        var datesStr = [String]()
        for date in dates ?? [] {
            datesStr.append(date.toString(DateFormat.custom("yyyy-MM-dd"), timeZone: .local))
        }
        
        EP_Home.completeRequest(consultant_id: interMediateData?.consultant_id, dates: datesStr.joined(separator: ","), schedule_type: .schedule, request_type: "multiple", first_name: interMediateData?.name, last_name: interMediateData?.name, lat: "\(/interMediateData?.address?.latitude)", long: "\(/interMediateData?.address?.longitude)", service_for: interMediateData?.requestingFor, home_care_req: interMediateData?.selectedServices, reason_for_service: interMediateData?.ros, service_address: interMediateData?.address?.address, end_date: nil, end_time: interMediateData?.endTime?.toString(DateFormat.custom("HH:mm"), timeZone: .local), card_id: "\(/item?.property?.model?.id)", start_time: interMediateData?.startTime?.toString(DateFormat.custom("HH:mm"), timeZone: .local), request_step: "create", filter_id: nil, service_id: "1", duties: interMediateData?.selectedServices, phone_number: interMediateData?.phone_number, country_code: interMediateData?.country_code).request(success: { [weak self] (responseData) in
            
            button.stop()
            let response = responseData as? StripeData

            let destVC = Storyboard<RequestProcessVC>.Home.instantiateVC()
            destVC.modalPresentationStyle = .overFullScreen
            destVC.interMediateData = self?.interMediateData
            destVC.transactionResponse = response
            destVC.didSuccess = { (response) in
                self?.popTo(toControllerType: HomeVC.self)
            }
            self?.presentVC(destVC)
            
        }) { (_) in
            button.stop()
        }
    }
    
    
    private func handleHeaderTap(_ model: PaymentHeaderModel?, section: Int?) {
        if /model?.isSelected { return }
        
        items.forEach({$0.headerProperty?.model?.isSelected = false})
        items[/section].headerProperty?.model?.isSelected = true
        
        if let sectionIndexOpened: Int = self.items.firstIndex(where: {/$0.items?.count != 0 }) {
            items[sectionIndexOpened].items = []
            dataSource?.updateAndReload(for: .MultipleSection(items: items), .DeleteRowsAt(indexPaths: [IndexPath(row: 0, section: sectionIndexOpened)], animation: .none))
        }
        
        let type = model?.type ?? .CreditCard
        switch type {
        case .CreditCard, .DebitCard:
            items[/section].items = [PaymentCellProvider.init((PayWithNewCardCell.identfier, UITableView.automaticDimension, PaymentCellModel.init(type, /tfAmount.text?.trimmingCharacters(in: .whitespacesAndNewlines), _id: nil)), nil, nil)]
            dataSource?.updateAndReload(for: .MultipleSection(items: items), .AddRowsAt(indexPaths: [IndexPath(row: 0, section: /section)], animation: .automatic, moveToLastIndex: false))
        case .GooglePay, .BhimUPI:
            items.forEach({$0.headerProperty?.model?.isSelected = false})
            dataSource?.updateAndReload(for: .MultipleSection(items: items), .FullReload)
        case .WithCard(_):
            items[/section].items = [PaymentCellProvider.init((PayWithExistingCardCell.identfier, UITableView.automaticDimension, PaymentCellModel.init(type, /tfAmount.text?.trimmingCharacters(in: .whitespacesAndNewlines), _id: /model?.id)), nil, nil)]
            dataSource?.updateAndReload(for: .MultipleSection(items: items), .AddRowsAt(indexPaths: [IndexPath(row: 0, section: /section)], animation: .automatic, moveToLastIndex: false))
        }
    }
    
    private func localizedTextSetup() {
        tfAmount.becomeFirstResponder()
        lblTitle.text = VCLiteral.PAYMENT_INFO.localized
        lblInputAmount.text = VCLiteral.AMOUNT.localized
        lblCurrency.text = UserPreference.shared.getCurrencyAbbr()
        btnAmount1.setTitle(AddMoneyAmounts.Amount1.formattedText, for: .normal)
        btnAmount2.setTitle(AddMoneyAmounts.Amount2.formattedText, for: .normal)
        btnAmount3.setTitle(AddMoneyAmounts.Amount3.formattedText, for: .normal)
        
        setupData()
    }
    
    public func setupData() {
        tfAmount.text = /bookingData?.grand_total?.getFormattedPrice()
        tfAmount.isUserInteractionEnabled = false
        updatePriceInsideCell(price: "\(/bookingData?.grand_total)")

        if /isManaging {
            vwAmount.isHidden = true
        }
    }
}
