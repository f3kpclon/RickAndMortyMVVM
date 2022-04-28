//
//  UIHelper.swift
//  RickAndMorty
//
//  Created by Felix Alexander Sotelo Quezada on 05-04-21.
//

import UIKit

struct UIHelper {
   
    static func createSingleColumnFlowLayout(in view : UIView) -> UICollectionViewFlowLayout {
        
        let width = view.bounds.width
        let padding = CGFloat(12)
        
        
        let flowLayaout            = UICollectionViewFlowLayout()
        flowLayaout.sectionInset   = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayaout.itemSize       = CGSize(width: width, height: 150)

        return flowLayaout
    }
    static func createLayout() -> UICollectionViewLayout {
        // The item and group will share this size to allow for automatic sizing of the cell's height
        let padding :CGFloat = 12

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(300))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = padding
        section.contentInsets = .init(top: padding, leading: padding, bottom: padding, trailing: padding)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}
