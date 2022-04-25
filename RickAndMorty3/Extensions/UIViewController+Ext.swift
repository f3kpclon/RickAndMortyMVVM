//
//  UIViewController+Ext.swift
//  RickAndMorty3
//
//  Created by Felix Alexander Sotelo Quezada on 24-04-22.
//

import UIKit
extension UIViewController {
    func showAlertOnMainThread(title: String, message: String)  {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }
    }
}
