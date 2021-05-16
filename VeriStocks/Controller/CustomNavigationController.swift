//
//  CustomNavigationController.swift
//  VeriStocks
//
//  Created by f4ni on 16.05.2021.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        UIApplication.shared.statusBarUIView?.backgroundColor = .red
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.navigationBar.backgroundColor = .red
        self.navigationBar.tintColor = .white
     
        return .lightContent
    }
}
