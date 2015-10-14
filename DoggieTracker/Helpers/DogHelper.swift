//
//  DogHelper.swift
//  DoggieTracker
//
//  Created by STEVE HUYNH on 10/10/15.
//  Copyright © 2015 SLH. All rights reserved.
//

import UIKit
import Alamofire


class DogHelper {
    
    
    func parseDog(dogsJSON: [AnyObject]) -> [Dog] {
        var dogs = [Dog]()
        for dog in dogsJSON  {
            let name = dog.objectForKey?("name") as! String
            let photoURL = dog.objectForKey("photoURL") as! String
            
            let newDog = Dog(name:name, photoURL: photoURL, rating : 5)!
            dogs += [newDog]
        }
        print("My dogs")
        print(dogs)
        return dogs
    }

}