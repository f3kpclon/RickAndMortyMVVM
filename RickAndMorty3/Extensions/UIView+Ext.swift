//
//  UIView+Ext.swift
//  RickAndMorty3
//
//  Created by Felix Alexander Sotelo Quezada on 26-04-22.
//

import Foundation
import UIKit

extension UIView {
    func addSubViews(_ views: UIView...)  {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
}
