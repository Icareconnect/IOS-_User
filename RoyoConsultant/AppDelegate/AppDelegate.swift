//
//  AppDelegate.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 11/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import JitsiMeet
import PushKit
import FirebaseDynamicLinks
import Firebase
import GoogleMaps
import GooglePlaces
//
//test.codebrewlab@gmail.com
//p@ssw0rd@123

//7018937965

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    internal var pipViewCoordinator: PiPViewCoordinator?
    internal var jitsiMeetView: JitsiMeetView?
    internal var onGoingCallRequestId: String?
    internal let voipRegistry = PKPushRegistry.init(queue: .main)
    internal var providerDelegate: ProviderDelegate?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
            //Code written in SceneDelegate
        } else {
            setRootVC()
        }
        
        GMSServices.provideAPIKey(SDK.GooglePlaceKey.rawValue)
        GMSPlacesClient.provideAPIKey(SDK.GooglePlaceKey.rawValue)
        
        IQ_KeyboaarManagerSetup()
        registerRemoteNotifications(application)
        
        return true
    }
    
    //MARK:- Universal Links handling
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL {
            debugPrint("Universal Link: \(incomingURL)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                guard error == nil else {
                    debugPrint("Universal Link Error: \(/error?.localizedDescription)")
                    return
                }
                if let link = dynamicLink {
                    self.handleIncomingDynamicLink(link: link)
                }
            }
            return linkHandled
        }
        return false
    }
    
    //MARK:- URL Scheme handling
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            handleIncomingDynamicLink(link: dynamicLink)
            return true
        } else {
            return true
        }
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        appForegroundAction()
    }
}

//MARK:- Custom functions
extension AppDelegate {
    public func setRootVC() {
        
        if /UserPreference.shared.data?.phone != "" || /UserPreference.shared.data?.email != "" {
            
            window?.rootViewController = Storyboard<NavgationTabVC>.TabBar.instantiateVC()
            window?.makeKeyAndVisible()
            UIView.transition(with: window!, duration: 0.4, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            }, completion: { _ in })
        } else {
            window?.rootViewController = Storyboard<LoginSignUpNavVC>.PopUp.instantiateVC()
            window?.makeKeyAndVisible()
            UIView.transition(with: window!, duration: 0.4, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            }, completion: { _ in })
        }
    }
    
    public func appForegroundAction() {
        SocketIOManager.shared.connect()
        EP_Home.appversion(app: .UserApp, version: Bundle.main.versionDecimalScrapped).request(success: { [weak self] (responseData) in
            guard let updateType = (responseData as? AppData)?.update_type else {
                return
            }
            //            self?.handleAppUpDate(updateType: updateType)
        })
        
        EP_Home.pages.request(success: { (response) in
            UserPreference.shared.pages = response as? [Page]
        })
        
        EP_Home.getClientDetail(app: .UserApp).request(success: { (responeData) in
            
        })
    }
    
    func handleAppUpDate(updateType: AppUpdateType) {
        let appURL = "http://itunes.apple.com/app/id\(Configuration.getValue(for: .ROYO_CONSULTANT_APPLE_APP_ID))"
        switch updateType {
        case .NoUpdate:
            break
        case .MinorUpdate:
            UIApplication.topVC()?.alertBoxOKCancel(title: String.init(format: VCLiteral.UPDATE_TITLE.localized, "\(VCLiteral.APP_TITLE_PREFIX.localized) \(VCLiteral.APP_TITLE_SUFFIX.localized)"), message: VCLiteral.UPDATE_DESC.localized, tapped: {
                UIApplication.shared.open(URL.init(string: appURL)!, options: [:], completionHandler: nil)
            }, cancelTapped: nil)
        case .MajorUpdate:
            UIApplication.topVC()?.alertBox(title: String.init(format: VCLiteral.UPDATE_TITLE.localized, "\(VCLiteral.APP_TITLE_PREFIX.localized) \(VCLiteral.APP_TITLE_SUFFIX.localized)"), message: VCLiteral.UPDATE_DESC.localized, btn1: VCLiteral.OK.localized, btn2: nil, tapped1: {
                UIApplication.shared.open(URL.init(string: appURL)!, options: [:], completionHandler: nil)
            }, tapped2: nil)
        }
    }
    
    func handleIncomingDynamicLink(link: DynamicLink) {
        
        switch link.matchType {
        case .weak:
            return
        default:
            break
        }
        guard let url = link.url else {
            debugPrint("Dynamic link object has no url")
            return
        }
        debugPrint("Dynamic Link URL: \(url.absoluteString)")
        guard let components = URLComponents.init(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else {
            return
        }
        
        var dict = [String :Any]()
        
        for queryItem in queryItems {
            dict[/queryItem.name] = /queryItem.value
        }
        
    }
    
    func checkUserLoggedIn(showPopUp: Bool) -> Bool {
        if /UserPreference.shared.data?.token == "" {
            if showPopUp {
                let loginAlert = Storyboard<LoginPopUpVC>.PopUp.instantiateVC()
                loginAlert.modalPresentationStyle = .overFullScreen
                loginAlert.didDismiss = { (providerType, callBack) in
                    switch callBack {
                    case .BUTTON_TAPPED:
                        let destVC = Storyboard<LoginMobileVC>.LoginSignUp.instantiateVC()
                        destVC.providerType = .phone
                        UIApplication.topVC()?.pushVC(destVC)
                    case .DEFAULT:
                        break
                    case .TERMS_TAPPED:
                        let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
                        destVC.linkTitle = (Configuration.getValue(for: .ROYO_CONSULTANT_BASE_PATH) + APIConstants.termsConditions, VCLiteral.TERMS_AND_CONDITIONS.localized)
                        UIApplication.topVC()?.pushVC(destVC)
                    case .PRIVACY_TAPPED:
                        let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
                        destVC.linkTitle = (Configuration.getValue(for: .ROYO_CONSULTANT_BASE_PATH) + APIConstants.privacyPolicy, VCLiteral.PRIVACY.localized)
                        UIApplication.topVC()?.pushVC(destVC)
                    case .EMAIL_SIGNUP:
                        let destVC = Storyboard<SignUpVC>.LoginSignUp.instantiateVC()
                        UIApplication.topVC()?.pushVC(destVC)
                    }
                }
                UIApplication.topVC()?.presentVC(loginAlert)
            }
            return false
        } else {
            return true
        }
    }
    
    private func IQ_KeyboaarManagerSetup() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(IQView.self)
        IQKeyboardManager.shared.toolbarTintColor = ColorAsset.appTint.color
        
        IQKeyboardManager.shared.disabledToolbarClasses.append(LoginEmailVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(LoginMobileVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(VerificationVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(SignUpInterMediateVC.self)
        
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ChatVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(ChatVC.self)
        
    }
}
