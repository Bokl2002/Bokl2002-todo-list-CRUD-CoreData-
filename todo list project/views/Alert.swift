//
//  Alert.swift
//  todo list project
//
//  Created by Abdullah Elbokl on 09/09/2022.
//

import Foundation
import UIKit
import CDAlertView

class Alert: UIViewController{
    var VC: UIViewController!

    static func addEditAlert(isEdit: Bool){
        
        var alert = CDAlertView(title: "Done", message: "Todo added", type: .success)
        if isEdit{
            alert = CDAlertView(title: "Done", message: "Todo edited", type: .success)
        }
        
        let action = CDAlertViewAction(title: "Go to main"){_ in
            if isEdit{
                VC.navigationController?.popViewController(animated: true)
            }else{
                self.tabBarController?.selectedIndex = 0
            }
            return true
        }
        alert.add(action: action)
        let doneAction = CDAlertViewAction(title: "Done"){_ in
            self.cleaR()
            return true
        }
        alert.add(action: doneAction)
        alert.show()
    }
    func receiveVC(){
        NotificationCenter.default.addObserver(self, selector: Selector("vc"), name: NSNotification.Name("editVC"), object: nil)
    }
    @objc func vc(noti: Notification){
        if let temp = noti.userInfo?["VC"] as? UIViewController{
            VC = temp
        }
    }
    
}
