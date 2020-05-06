//
//  ImageGalleryNamesTableViewController.swift
//  ImageGallery
//
//  Created by Emanuel on 01/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

class ImageGalleryNamesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)

        // Configure the cell...
        if indexPath.section == 0{
            cell.textLabel?.text = ImageGallery.galleryNames[indexPath.row]
        }else{
            cell.textLabel?.text = ImageGallery.galleryNamesRemoved[indexPath.row]
        }
        
        return cell
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
                tableView.deleteRows(at: [indexPath], with: .fade)
                ImageGallery.galleryNamesRemoved.append(item)
                ImageGallery.DeletedGallery.append(galleryItem)
                tableView.reloadData()
            }else{
                ImageGallery.galleryNamesRemoved.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                ImageGallery.DeletedGallery.remove(at: indexPath.row)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    @IBAction func addGallery(_ sender: UIBarButtonItem) {
        ImageGallery.galleryNames.append("Untitled".madeUnique(withRespectTo: ImageGallery.galleryNames))
        //add an empty thing
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let swipe = UIContextualAction(style: .normal, title: "Undelete"){(action, sourceView, completionHandler) in
            let item = ImageGallery.galleryNamesRemoved.remove(at: indexPath.row)
            let galleryItem = ImageGallery.DeletedGallery.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ImageGallery.galleryNames.append(item)
            ImageGallery.Gallery.append(galleryItem)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section != 1){
            performSegue(withIdentifier:"TableSegue", sender: indexPath)
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
        }
    }
}
