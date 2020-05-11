//
//  ImageGalleryNamesTableViewController.swift
//  ImageGallery
//
//  Created by Emanuel on 01/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

class ImageGalleryNamesTableViewController: UITableViewController, UISplitViewControllerDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay{
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? UINavigationController{
            if let fvc = (cvc.visibleViewController as? ImageGalleryViewController){
                if fvc.gallery == nil{
                    return true
                }
            }
        }
        return false
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of section
        return ImageGallery.sectionNames.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 0){
            return ImageGallery.galleryNames.count
        }else{
            return ImageGallery.galleryNamesRemoved.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        // Configure the cell...
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryNameCell", for: indexPath)
            if let inputCell = cell as? GalleryNameTableViewCell{
                let tap = UITapGestureRecognizer(target: self, action: #selector(startEditingText(sender:)))
                tap.numberOfTapsRequired = 2
                inputCell.addGestureRecognizer(tap)
                inputCell.nameTextField.text = ImageGallery.galleryNames[indexPath.item]
                inputCell.nameTextField.isUserInteractionEnabled = false
                inputCell.resignationHandler = { [weak self, unowned inputCell] in
                    if let text = inputCell.nameTextField.text{
                        ImageGallery.galleryNames[indexPath.item] = text
                    }
                    self?.tableView.reloadData()
                    self?.performSegue(withIdentifier:"TableSegue", sender: indexPath)
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
            cell.textLabel?.text = ImageGallery.galleryNamesRemoved[indexPath.row]
            return cell
        }
    }
    
    @objc func startEditingText(sender : UITapGestureRecognizer){
        if let myCell = sender.view as? GalleryNameTableViewCell{
            
            myCell.startEditing()
        }
    }
   
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ImageGallery.sectionNames[section]
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if indexPath.section == 0{
                let item = ImageGallery.galleryNames.remove(at: indexPath.row)
                let galleryItem = ImageGallery.Gallery.remove(at: indexPath.row)
                let aspecRatioItem = ImageGallery.AspectRatios.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                ImageGallery.galleryNamesRemoved.append(item)
                ImageGallery.DeletedGallery.append(galleryItem)
                ImageGallery.DeletedAspectRatios.append(aspecRatioItem)
                tableView.reloadData()
                //performSegue(withIdentifier:"DeleteSegue", sender: indexPath)
            }else{
                ImageGallery.galleryNamesRemoved.remove(at: indexPath.row)
                ImageGallery.DeletedAspectRatios.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                ImageGallery.DeletedGallery.remove(at: indexPath.row)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    @IBAction func addGallery(_ sender: UIBarButtonItem) {
        ImageGallery.galleryNames.append("Untitled".madeUnique(withRespectTo: ImageGallery.galleryNames))
        ImageGallery.Gallery.append([nil])
        ImageGallery.AspectRatios.append([1.0])
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let swipe = UIContextualAction(style: .normal, title: "Undelete"){(action, sourceView, completionHandler) in
            let item = ImageGallery.galleryNamesRemoved.remove(at: indexPath.row)
            let aspectItem = ImageGallery.DeletedAspectRatios.remove(at: indexPath.row)
            let galleryItem = ImageGallery.DeletedGallery.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ImageGallery.galleryNames.append(item)
            ImageGallery.Gallery.append(galleryItem)
            ImageGallery.AspectRatios.append(aspectItem)
            tableView.reloadData()
            completionHandler(true)
        }
        swipe.backgroundColor = UIColor.blue
        
        if indexPath.section == 1{
            let swipeLeadingAction = UISwipeActionsConfiguration(actions: [swipe])
            swipeLeadingAction.performsFirstActionWithFullSwipe = false
            return swipeLeadingAction
        }else{
            return nil
        }
    }
    
    var lastRow : Int? = nil
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section != 1){
            if indexPath.item != lastRow {
                performSegue(withIdentifier:"TableSegue", sender: indexPath)
                lastRow = indexPath.item
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "TableSegue"{
            if let indexPath = (sender as? IndexPath)?.row{
                if let cvc = segue.destination.contents as? ImageGalleryViewController{
                    cvc.gallery = indexPath
                    cvc.title = ImageGallery.galleryNames[indexPath]
                }
            }
        }else if segue.identifier  == "DeleteSegue"{
                if let cvc = segue.destination.contents as? ImageGalleryViewController{
                    cvc.gallery = nil
                    cvc.title = nil
                }
            }
    }
}
