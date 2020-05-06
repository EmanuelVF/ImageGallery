//
//  DemoURLs.swift
//  Cassini
//
//  Created by Emanuel on 24/04/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import Foundation

struct ImageGallery{
    
    static var galleryNames = ["Planets", "Cities", "Landscapes"]
    static var galleryNamesRemoved = ["Dogs", "Cats"]
    static var sectionNames = ["", "Recently Deleted"]
    
    static var Gallery = [
        [
            URL(string : "https://images.pexels.com/photos/87651/earth-blue-planet-globe-planet-87651.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500")! : 1.0/1.0 ,
            URL(string : "https://t3.ftcdn.net/jpg/01/25/18/72/240_F_125187219_eyhX3tJMrvf1z2SQh7t2JatuG5iPYB12.jpg")! : 1.0/1.0
        ],
        [
            URL(string : "https://images.pexels.com/photos/169647/pexels-photo-169647.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260")! : 1.0/1.0 ,
            URL(string : "https://images.pexels.com/photos/358485/pexels-photo-358485.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260")! : 1.0/1.0
        ],
        [
            URL(string : "https://images.pexels.com/photos/1619317/pexels-photo-1619317.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500")! : 1.0/1.0 ,
            URL(string : "https://images.pexels.com/photos/132037/pexels-photo-132037.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500")! : 1.0/1.0
        ]
    ]
    
    static var DeletedGallery = [
        [
            URL(string : "https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500")! : 1.0/1.0 ,
            URL(string : "https://images.pexels.com/photos/1633522/pexels-photo-1633522.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500")! : 1.0/1.0
        ],
        [
            URL(string : "https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500")! : 1.0/1.0 ,
            URL(string : "https://images.pexels.com/photos/104827/cat-pet-animal-domestic-104827.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500")! : 1.0/1.0
        ]
    ]
}
