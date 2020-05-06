//
//  ImageGalleryViewController.swift
//  ImageGallery
//
//  Created by Emanuel on 01/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDropDelegate, UICollectionViewDragDelegate {
    
    var gallery : Int? = nil{
        didSet{
            if gallery != nil{
                imagesCollectionView?.reloadData()
                flowLayout?.invalidateLayout()
            }
        }
    }

    @IBOutlet weak var imagesCollectionView: UICollectionView!{
        didSet{
            imagesCollectionView.dataSource = self
            imagesCollectionView.delegate = self
            imagesCollectionView.dropDelegate = self
            imagesCollectionView.dragDelegate = self
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
            return ImageGallery.Gallery[index].count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        flowLayout?.invalidateLayout()
        if let imageCell = cell as? ImageCollectionViewCell{
            imageCell.imageURL = ImageGallery.Gallery[gallery!][indexPath.item]
            imageCell.aspectRatio = CGFloat(ImageGallery.AspectRatios[gallery!][indexPath.item])
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
        let width = predefinedWidth
        let aspectRatio = CGFloat(ImageGallery.AspectRatios[gallery!][indexPath.item])
        return CGSize(width: width, height: width / aspectRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return flowLayout!.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return flowLayout!.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let lele = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(0), right: CGFloat(0))
        return lele
    }

    
    
    
    // MARK: Segue!!!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier:"DetailZoom", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "DetailZoom"{
            if let indexPath = (sender as? IndexPath)?.item{
                if let cvc = segue.destination.contents as? ImageZoomViewController{
                    cvc.imageURL = ImageGallery.Gallery[gallery!][indexPath]
                }
            }
        }
    }
    
    
    // MARK: Drag!!!
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem]{
        if let url = (imagesCollectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell)?.imageURL{
            let dragItem = UIDragItem(itemProvider: NSItemProvider(contentsOf: url)!)
            dragItem.localObject = url
            return [dragItem]
        }else{
            return []
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    // MARK: Drop!!!
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if gallery != nil{
                return (session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self) || session.canLoadObjects(ofClass: URL.self))
        }else{
            return false
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
      
        let destinationIndex = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items{
            if let sourceIndex = item.sourceIndexPath{ // to see if it is mine
                if let myimage = item.dragItem.localObject as? URL{
                    collectionView.performBatchUpdates({
                        ImageGallery.Gallery[self.gallery!].remove(at: sourceIndex.item)
                        ImageGallery.Gallery[self.gallery!].insert(myimage, at: destinationIndex.item)
                        ImageGallery.AspectRatios[self.gallery!].remove(at: sourceIndex.item)
                        ImageGallery.AspectRatios[self.gallery!].insert(1.0, at: destinationIndex.item)
                        collectionView.deleteItems(at: [sourceIndex])
                        collectionView.insertItems(at: [destinationIndex])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndex)
                }
            }else{
                let placeHolderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(
                    insertionIndexPath: destinationIndex,
                    reuseIdentifier: "DropPlaceHolderCell"))
                
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) {(provider,error) in
                    DispatchQueue.main.async {
                        if let myURL = provider as? URL{
                            placeHolderContext.commitInsertion(dataSourceUpdates: {insertionIndexPath in
                                ImageGallery.Gallery[self.gallery!].insert(myURL.imageURL, at: insertionIndexPath.item)
                                ImageGallery.AspectRatios[self.gallery!].insert(1.0, at: insertionIndexPath.item)
                            })
                        }else{
                            placeHolderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
}
