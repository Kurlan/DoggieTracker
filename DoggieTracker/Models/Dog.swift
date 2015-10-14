//
//  Dog.swift
//  DoggieTracker
//
//  Created by STEVE HUYNH on 10/8/15.
//  Copyright © 2015 SLH. All rights reserved.
//

import UIKit
import Alamofire

class Dog{
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    var photoURL: String?
    var rating: Int
    
    // MARK: Initialization
    
    init?(name: String, photoURL: String?, rating: Int) {
        self.name = name
        self.rating = rating
        self.photoURL = photoURL
        
        if name.isEmpty || rating < 0 {
            return nil
        }
        
    }
    
//    init?(name: String, photo: UIImage?, rating: Int) {
//        self.name = name
//        self.photo = photo
//        self.rating = rating
//        
//        if name.isEmpty || rating < 0 {
//            return nil
//        }
//        
//    }
}