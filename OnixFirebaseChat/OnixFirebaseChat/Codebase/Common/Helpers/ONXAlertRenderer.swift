//
//  ONXAlertRenderer.swift
//  OnixFirebaseChat
//
//  Created by Anton Dolzhenko on 02.12.16.
//  Copyright © 2016 Onix-systems. All rights reserved.
//

import UIKit

protocol ONXAlertRenderer {
    func displayMessage(_ title:String,msg:String)
    func displayError(_ error:NSError)
}

extension ONXAlertRenderer where Self: UIViewController {
    func displayError(_ error:NSError){
        displayMessage("Error!", msg: error.localizedDescription)
    }
    
    func displayMessage(_ title:String,msg:String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) -> Void in
            alertController.dismiss(animated: true, completion:nil)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
