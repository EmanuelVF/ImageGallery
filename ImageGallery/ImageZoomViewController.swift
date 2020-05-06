//
//  ImageZoomViewController.swift
//  ImageGallery
//
//  Created by Emanuel on 01/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

class ImageZoomViewController: UIViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var scrollViewHieght: NSLayoutConstraint!
    @IBOutlet weak var spinnerImage: UIActivityIndicatorView!
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    
    var imageURL : URL?{
        didSet{
            image = nil
            if view.window != nil{
                fetchImage()
            }
        }
    }
    
    private var image: UIImage?{
        get {
            return imageView.image
        }
        set {
            
            imageView.image = newValue
            imageView.sizeToFit()
            scrollImage?.contentSize = imageView.frame.size
            spinnerImage?.stopAnimating()
            
            scrollImage?.zoomScale = 1.0
            let size = newValue?.size ?? CGSize.zero
            imageView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollImage?.contentSize = size
            scrollViewHieght?.constant = size.height
            scrollViewWidth?.constant = size.width
//            if let dropZone = self.dropZone, size.width > 0, size.height > 0 {
//                scrollView?.zoomScale = max(dropZone.bounds.size.width / size.width, dropZone.bounds.size.height / size.height)
//            }
            
            
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewWidth.constant = scrollView.contentSize.width
        scrollViewHieght.constant = scrollView.contentSize.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil {
            fetchImage()
        }
    }
    var imageView = UIImageView()

    @IBOutlet weak var scrollImage: UIScrollView!{
        didSet{
            scrollImage.minimumZoomScale = 0.1
            scrollImage.maximumZoomScale = 5.0
            scrollImage.delegate = self
            scrollImage.addSubview(imageView)
            
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageView
        }
        
        private func fetchImage(){
            if let url = imageURL{
                spinnerImage.startAnimating()

                DispatchQueue.global(qos:.userInitiated).async { [weak self] in  // This weak is added if self doesn't exist when the image is loaded. It is not related with memory cycles
                    let urlContents = try? Data(contentsOf: url) // ? is added to handle the throws. If I am interested in the error, then the try catch should be done
                    DispatchQueue.main.async {
                        if let imageData = urlContents, url == self?.imageURL{ // to keep updated url
                            self?.image = UIImage(data: imageData)
                        }
                    }
                    
                }
                
            }
        }
}
