//
//  ImageGalleryViewController.swift
//  ImageGallery
//
//  Created by Emanuel on 01/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var gallery : Int? = nil{
        didSet{
            imagesCollectionView?.reloadData()
            flowLayout?.invalidateLayout()
        }
    }

    @IBOutlet weak var imagesCollectionView: UICollectionView!{
        didSet{
            imagesCollectionView.dataSource = self
            imagesCollectionView.delegate = self
            imagesCollectionView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: self,
                action: #selector(zoomGallery)))
        }
    }
    
    // MARK: Zoom process
    
    var scale: CGFloat = 1  {
        didSet {
            flowLayout?.invalidateLayout()
        }
    }
    
    @objc func zoomGallery (gesture : UIPinchGestureRecognizer){
        switch gesture.state {
        case .changed:
            scale *= gesture.scale
            gesture.scale = 1.0
        default:
            break
        }
    }
    
    // MARK: Collection View Items
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let index = gallery {
            //TO DO: Check if there are photos ni the section
            print("\(index)")
            return ImageGallery.Gallery[index].count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        print("Preparo celda")
        flowLayout?.invalidateLayout()
        print("Stop autolayout en celda")
        if let imageCell = cell as? ImageCollectionViewCell{
            let keysArray = Array(ImageGallery.Gallery[gallery!].keys)
            imageCell.imageURL = keysArray[indexPath.item]
            imageCell.aspectRatio = CGFloat(ImageGallery.Gallery[gallery!][keysArray[indexPath.item]]!)
            
        }
        return cell
    }
    
    
    // MARK: Collection View Layout
    
    var flowLayout: UICollectionViewFlowLayout? {
        return imagesCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    var defaultWidth : CGFloat{
        return imagesCollectionView.bounds.width/2}
    
    var predefinedWidth : CGFloat {
        return defaultWidth * scale
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("Hago layout como un maestro")
        let width = predefinedWidth
        let keysArray = Array(ImageGallery.Gallery[gallery!].keys)
        let aspectRatio = CGFloat(ImageGallery.Gallery[gallery!][keysArray[indexPath.item]]!)
        return CGSize(width: width, height: width / aspectRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        print("pase por aqui \(flowLayout!.minimumLineSpacing)")
        return flowLayout!.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        print("pase por aqui tambien\(flowLayout!.minimumLineSpacing)")
        return flowLayout!.minimumLineSpacing
    }
    
    // MARK: Segue!!!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier:"DetailZoom", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "DetailZoom"{
            if let indexPath = (sender as? IndexPath)?.item{
                if let cvc = segue.destination.contents as? ImageZoomViewController{
                    let keysArray = Array(ImageGallery.Gallery[gallery!].keys)
                    cvc.imageURL = keysArray[indexPath]
                }
            }
        }
    }
}

