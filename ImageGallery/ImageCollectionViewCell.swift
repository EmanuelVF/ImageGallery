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
//            if imagePlace.window != nil{
                fetchImage()
                print("Fetch!")
//            }
        }
    }
    
    var aspectRatio : CGFloat = 1.0{
        didSet{
            setNeedsLayout()
        }
    }
   
    private var image: UIImage?{
        get {
            return imagePlace.image
        }
        set {
            imagePlace.image = newValue
            spinner.stopAnimating()
        }
    }
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private func fetchImage(){
            if let url = imageURL{
                spinner.startAnimating()
                DispatchQueue.global(qos:.userInitiated).async { [weak self] in  // This weak is added if self doesn't exist when the image is loaded. It is not related with memory cycles
                    let urlContents = try? Data(contentsOf: url) // ? is added to handle the throws. If I am interested in the error, then the try catch should be done
                    DispatchQueue.main.async {
                        if let imageData = urlContents, url == self?.imageURL{ // to keep updated url
                            self?.image = UIImage(data: imageData)
                            self?.aspectRatio = self!.image!.size.width/self!.image!.size.height
                            for index in ImageGallery.Gallery.indices{
                                for key in ImageGallery.Gallery[index].keys{
                                    if key == url{
                                        ImageGallery.Gallery[index][url] = Double(self!.aspectRatio)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
}
