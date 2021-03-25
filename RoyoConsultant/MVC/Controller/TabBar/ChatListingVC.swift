//
//  HomeVC_Tab3ChatVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 14/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ChatListingVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<ChatThread>, DefaultCellModel<ChatThread>, ChatThread>?
    private var items: [ChatThread]?
    private var after: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = VCLiteral.CHAT.localized
        tableViewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SocketIOManager.shared.connect()
    }
    
    @IBAction func btnWalletAction(_ sender: UIButton) {
        pushVC(Storyboard<WalletVC>.Home.instantiateVC())
    }
    
}

//MARK:- VCFuncs
extension ChatListingVC {
    public func reloadViaNotification() {
        guard let _ = tableView  else {
            return
        }
        errorView.removeFromSuperview()
        getChatListingAPI(isRefreshing: true)
    }
    
    
    private func tableViewInit() {
        
        tableView.contentInset.top = 16.0
        
        dataSource = TableDataSource<DefaultHeaderFooterModel<ChatThread>, DefaultCellModel<ChatThread>, ChatThread>.init(.SingleListing(items: items ?? [], identifier: ChatThreadCell.identfier, height: UITableView.automaticDimension, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? ChatThreadCell)?.item = item
        }
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getChatListingAPI(isRefreshing: true)
        }
        
        dataSource?.addInfiniteScrolling = { [weak self] in
            if self?.after != nil {
                self?.getChatListingAPI(isRefreshing: false)
            }
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            let destVC = Storyboard<ChatVC>.Home.instantiateVC()
            destVC.thread = item?.property?.model
            self?.pushVC(destVC)
        }
        
        dataSource?.refreshProgrammatically()
    }
    
    private func getChatListingAPI(isRefreshing: Bool? = false) {
        EP_Home.chatListing(after: /isRefreshing ? nil : after).request(success: { [weak self] (responseData) in
            self?.items = (responseData as? ChatData)?.lists
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.items ?? []), .FullReload)
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            
            
            let response = responseData as? ChatData
            self?.after = response?.after
            if /isRefreshing {
                self?.items = response?.lists ?? []
            } else {
                self?.items = (self?.items ?? []) + (response?.lists ?? [])
            }
            /self?.items?.count == 0 ? self?.showVCPlaceholder(type: .NoChats, scrollView: self?.tableView) : ()
            self?.dataSource?.stopInfiniteLoading(response?.after == nil ? .NoContentAnyMore : .FinishLoading)
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.items ?? []), .FullReload)
            
        }) { [weak self] (error) in
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            if /self?.items?.count == 0 {
                self?.showErrorView(error: /error, scrollView: self?.tableView, tapped: {
                    self?.errorView.removeFromSuperview()
                    self?.dataSource?.refreshProgrammatically()
                })
            }
        }
    }
    
}
