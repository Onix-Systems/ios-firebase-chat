//
//  ONXFirebaseService.swift
//  OnixFirebaseChat
//
//  Created by Anton Dolzhenko on 02.12.16.
//  Copyright © 2016 Onix-systems. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuthUI
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI
import FirebaseTwitterAuthUI
import TwitterKit

final class ONXFirebaseService: NSObject {
    
    var subject:Variable<FIRAuth?> = Variable<FIRAuth?>(nil)
    private let disposeBag = DisposeBag()
    
    override init(){
        super.init()
        just(element: FUIAuth.defaultAuthUI()?.auth)
            .bindTo(subject)
            .addDisposableTo(disposeBag)
    }
    
    func configure(){
        Twitter.sharedInstance().start(withConsumerKey: Constants.TwitterCredentials.consumerKey, consumerSecret: Constants.TwitterCredentials.consumerSecret)
        FIRApp.configure()
    }
    
    var signInViewController:UIViewController? {
        get {
            if let ui = FUIAuth.defaultAuthUI() {
                ui.isSignInWithEmailHidden = true
                ui.tosurl = URL(string: "http://onix.ua")!
                ui.delegate = self
                ui.providers = [FUIFacebookAuth(permissions: ["public_profile"]),FUITwitterAuth(),FUIGoogleAuth()]
                return ui.authViewController()
            }
            return nil
        }
    }
    
    func logout(){
        do {
            try FUIAuth.defaultAuthUI()?.signOut()
            subject.value = nil
        } catch let error {
            print("error:\(error.localizedDescription)")
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
}

extension ONXFirebaseService: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            print("Error description:\(error.localizedDescription)")
        }
        self.subject.value = authUI.auth
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let picker = FUIAuthPickerViewController(authUI: authUI)
        return picker
    }
}
