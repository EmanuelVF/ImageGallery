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
    
    var galleryNames = ["Planets", "Cities", "Landscapes"]
    var galleryNamesRemoved = ["Dogs", "Cats"]
    var sectionNames = ["", "Recently Deleted"]

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of section
        return 2
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 0){
            return galleryNames.count
        }else{
            return galleryNamesRemoved.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)

        // Configure the cell...
        if indexPath.section == 0{
            cell.textLabel?.text = galleryNames[indexPath.row]
        }else{
            cell.textLabel?.text = galleryNamesRemoved[indexPath.row]
        }
        
        return cell
    }
   
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
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
                let item = galleryNames.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                galleryNamesRemoved.append(item)
                tableView.reloadData()
            }else{
                galleryNamesRemoved.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                if galleryNamesRemoved.count == 0{
//                    tableView.reloadSections(IndexSet(1))
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    @IBAction func addGallery(_ sender: UIBarButtonItem) {
        galleryNames.append("Untitled".madeUnique(withRespectTo: galleryNames))
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let swipe = UIContextualAction(style: .normal, title: "Undelete"){(action, sourceView, completionHandler) in
            let item = self.galleryNamesRemoved.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.galleryNames.append(item)
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
        print("seleccione seccion \(indexPath.section) fila \(indexPath.row)")
        if (indexPath.section != 1){
            performSegue(withIdentifier:"TableSegue", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "TableSegue"{
            print("mySegue")
        }
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
