//
//  UIStack+Ext.swift
//  RickAndMorty3
//
//  Created by Felix Alexander Sotelo Quezada on 26-04-22.
//

import Foundation
import UIKit

extension UIStackView {
    func addStacks(_ views: UIStackView...)  {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(view)
        }
    }
}
