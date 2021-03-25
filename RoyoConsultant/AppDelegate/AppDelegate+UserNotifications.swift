//
//  AppDelegate+UserNotifications.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import Firebase

extension AppDelegate {
    internal func registerRemoteNotifications(_ app: UIApplication) {
        FirebaseApp.configure()

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization( options: authOptions,completionHandler: {_, _ in })
        app.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    internal func handleAutomaticRefreshData(_ model: RemotePush?) {
        switch model?.pushType ?? .UNKNOWN {
        case .CALL:
        break //PushKit handled
        case .CALL_CANCELED:
            DispatchQueue.main.async {
                self.pipViewCoordinator?.hide() { _ in
                    self.cleanUp()
                }
            }
            onGoingCallRequestId = nil
            providerDelegate?.endCall()
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
        case .CALL_RINGING, .CALL_ACCEPTED:
            //CASE NOT POSSIBLE BECAUSE CALL CAN BE INITIATED ONLY FROM VENDOR SIDE
            break
        case .REQUEST_ACCEPTED:
            if let apptsVC = ((UIApplication.topVC()?.tabBarController?.viewControllers)?[2] as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: AppointmentsVC.self)}) as? AppointmentsVC {
                apptsVC.reloadViaNotification()
            }
            Toast.shared.showMinimalView(title: /model?.aps?.alert?.body)
            
        case .REQUEST_COMPLETED,
             .CANCELED_REQUEST,
             .REQUEST_FAILED,
             .UPCOMING_APPOINTMENT,
                .START_SERVICE,
                .COMPLETED,
                .REACHED,
                .START,
                .CANCEL_SERVICE:
            
            UIApplication.topVC()?.tabBarController?.selectedIndex = 0
            
            if let apptsVC = ((UIApplication.topVC()?.tabBarController?.viewControllers)?[1] as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: AppointmentsVC.self)}) as? AppointmentsVC {
                apptsVC.reloadViaNotification()
                UIApplication.topVC()?.tabBarController?.selectedIndex = 1
            }
            if /UIApplication.topVC()?.isKind(of: RequestDetailsVC.self) && /(UIApplication.topVC() as? RequestDetailsVC)?.item?.id == /Int(/model?.request_id) {
                (UIApplication.topVC() as? RequestDetailsVC)?.getDetails()
            }
        case .chat:
            if /UIApplication.topVC()?.isKind(of: ChatVC.self) {
                return
            } else if let chatListingVC = ((UIApplication.topVC()?.tabBarController?.viewControllers)?[2] as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: ChatListingVC.self)}) as? ChatListingVC {
                chatListingVC.reloadViaNotification()
            }
            let message = String.init(format: VCLiteral.NEW_MESSAGE.localized, /model?.senderName, /model?.aps?.alert?.body)
            Toast.shared.showMinimalView(title: message)
        case .AMOUNT_DEDCUTED, .AMOUNT_RECEIVED, .BOOKING_RESERVED:
            if /UIApplication.topVC()?.isKind(of: WalletVC.self) {
                (UIApplication.topVC() as? WalletVC)?.reloadViaNotification()
            }
            Toast.shared.showMinimalView(title: /model?.aps?.alert?.body)
        case .BALANCE_ADDED:
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
            UIApplication.topVC()?.dismiss(animated: true, completion: {
                UIApplication.topVC()?.popTo(toControllerType: ConfirmBookingVC.self)
                UIApplication.topVC()?.popTo(toControllerType: WalletVC.self)
            })
        case .BALANCE_FAILED:
            UIApplication.topVC()?.dismissVC()
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
        case .CHAT_STARTED:
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
        case .UNKNOWN, .STARTED_REQUEST:
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
       
        }
    }
    
    internal func handleNotificationTap(_ model: RemotePush?) {
        switch model?.pushType ?? .UNKNOWN  {
        case .CALL:
        break //PushKit handled
        case .CALL_CANCELED:
            DispatchQueue.main.async {
                self.pipViewCoordinator?.hide() { _ in
                    self.cleanUp()
                }
            }
            onGoingCallRequestId = nil
            providerDelegate?.endCall()
        case .CALL_RINGING, .CALL_ACCEPTED:
            //CASE NOT POSSIBLE BECAUSE CALL CAN BE INITIATED ONLY FROM VENDOR SIDE
            break
        case .chat:
            if /UIApplication.topVC()?.isKind(of: ChatListingVC.self) {
                (UIApplication.topVC() as? ChatListingVC)?.reloadViaNotification()
            } else {
                UIApplication.topVC()?.tabBarController?.selectedIndex = 2
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    (UIApplication.topVC() as? ChatListingVC)?.reloadViaNotification()
                }
            }
        case .REQUEST_ACCEPTED:
            if let apptsVC = ((UIApplication.topVC()?.tabBarController?.viewControllers)?[2] as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: AppointmentsVC.self)}) as? AppointmentsVC {
                apptsVC.reloadViaNotification()
                UIApplication.topVC()?.tabBarController?.selectedIndex = 1
            }
        case .REQUEST_COMPLETED,
             .CANCELED_REQUEST,
             .REQUEST_FAILED,
             .CHAT_STARTED,
             .STARTED_REQUEST,
             .REACHED,
             .COMPLETED,
             .START,
             .START_SERVICE,
             .CANCEL_SERVICE,
             .UPCOMING_APPOINTMENT:
            UIApplication.topVC()?.tabBarController?.selectedIndex = 0

            if let apptsVC = ((UIApplication.topVC()?.tabBarController?.viewControllers)?[1] as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: AppointmentsVC.self)}) as? AppointmentsVC {
                apptsVC.reloadViaNotification()
                UIApplication.topVC()?.tabBarController?.selectedIndex = 1
            }
            if /UIApplication.topVC()?.isKind(of: RequestDetailsVC.self) && /(UIApplication.topVC() as? RequestDetailsVC)?.item?.id == /Int(/model?.request_id) {
                (UIApplication.topVC() as? RequestDetailsVC)?.getDetails()
            } else {
                let destVC = Storyboard<RequestDetailsVC>.Home.instantiateVC()
                destVC.requestID = /model?.request_id
                UIApplication.topVC()?.pushVC(destVC)
            }
            
        case .AMOUNT_DEDCUTED, .AMOUNT_RECEIVED, .BOOKING_RESERVED:
            if /UIApplication.topVC()?.isKind(of: WalletVC.self) {
                (UIApplication.topVC() as? WalletVC)?.reloadViaNotification()
            } else {
                UIApplication.topVC()?.pushVC(Storyboard<WalletVC>.Home.instantiateVC())
            }
        case .BALANCE_ADDED:
             UIApplication.topVC()?.dismiss(animated: true, completion: {
                 UIApplication.topVC()?.popTo(toControllerType: ConfirmBookingVC.self)
                 UIApplication.topVC()?.popTo(toControllerType: WalletVC.self)
             })
        case .BALANCE_FAILED:
            UIApplication.topVC()?.dismissVC()
        case .UNKNOWN:
            break
        }
    }
}

//MARK:- UNUserNotificationCenter Deelgates
extension AppDelegate: UNUserNotificationCenterDelegate {
    //MARK:- Notification Native UI Tapped
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let userInfo = response.notification.request.content.userInfo as? [String : Any] else { return }
        let notificationData = JSONHelper<RemotePush>().getCodableModel(data: userInfo)
        handleNotificationTap(notificationData)
    }
    
    //MARK:- Native notification just came up
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard let userInfo = notification.request.content.userInfo as? [String : Any] else { return }
        let notificationData = JSONHelper<RemotePush>().getCodableModel(data: userInfo)
        handleAutomaticRefreshData(notificationData)
    }
}

//MARK:- Firebase messaging delegate
extension AppDelegate: MessagingDelegate {
    internal func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        UserPreference.shared.firebaseToken = fcmToken
        
        if checkUserLoggedIn(showPopUp: false) {
            EP_Home.updateFCMId.request(success: { (_) in
                
            })
        }
    }
}
