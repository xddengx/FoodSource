//
//  RecipeCell.swift
//  FoodSource
//
//  Created by Dina Deng on 5/6/18.
//  Copyright © 2018 DinaStudent. All rights reserved.
//
/*
    Creates the cell style to display a star image button, which allows users to favorite recipes. This class gets which cell was favorited from the RecipeTableVC class and the list of favorited recipes is found in FavoritesList class. 
 */

import Foundation
import UIKit

class RecipeCell: UITableViewCell{
    
    var recipeVC: RecipeTableVC!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        let favoriteButton = UIButton(type: .system)
        favoriteButton.setImage(#imageLiteral(resourceName: "star.png"), for: .normal)
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        favoriteButton.addTarget(self, action: #selector(self.favorited(_:)), for: .touchUpInside)
        
        
        accessoryView = favoriteButton
    }
    
    @objc func favorited(_ sender: UIButton){        
        recipeVC?.favoriteCell(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
