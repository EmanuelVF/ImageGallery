//
//  ImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by Emanuel on 01/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imagePlace: UIImageView!
    
    var imageURL : URL?{
        didSet{
            image = nil
            fetchImage()
        }
    }
    
    var aspectRatio : CGFloat = 1.0{
        didSet{
            
        }
    }
   
    private var image: UIImage?{
        get {
            return imagePlace.image
        }
        set {
            imagePlace.image = newValue
            spinner.stopAnimating()
            imagePlace.sizeToFit()
        }
    }
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private func fetchImage(){
            if let url = imageURL{
                spinner.startAnimating()
                DispatchQueue.global(qos:.userInitiated).async { [weak self] in  // This weak is added if self doesn't exist when the image is loaded. It is not related with memory cycles
                    let urlContents = try? Data(contentsOf: url.imageURL) // ? is added to handle the throws. If I am interested in the error, then the try catch should be done
                    DispatchQueue.main.async {
                        if let imageData = urlContents, url == self?.imageURL{ // to keep updated url
                            self?.image = UIImage(data: imageData)
                            self?.aspectRatio = (self!.image?.size.width ?? 1)/(self!.image?.size.height ?? 1)
                            for index in ImageGallery.Gallery.indices{
                                for key in ImageGallery.Gallery[index].indices{
                                    if ImageGallery.Gallery[index][key] == url{
                                        ImageGallery.AspectRatios[index][key] = Double(self!.aspectRatio)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
}
