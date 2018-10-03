//
//  meal.swift
//  FoodSource
//
//  Created by Dina Deng on 4/24/18.
//  Copyright © 2018 DinaStudent. All rights reserved.
//

import Foundation

class Meal: NSObject{
    var title: String?
    var source_url: String?
    var image_url: String?
    var favorited: Bool?
    
    init(title: String, source_url: String, image_url: String, favorited: Bool) {
        super.init()
        self.set(title: title)
        self.set(image_url: image_url)
        self.set(source_url: source_url)
        self.set(favorited: favorited)
    }
    
    func getTitle() -> String{return title!}
    func set(title:String){self.title = title}
    
    func getImage_url() -> String{return image_url!}
    func set(image_url:String){self.image_url = image_url}
    
    func getSource_url() -> String{return source_url!}
    func set(source_url:String){self.source_url = source_url}
    
    func getFavorited() -> Bool{return favorited!}
    func set(favorited:Bool){self.favorited = favorited}
}
