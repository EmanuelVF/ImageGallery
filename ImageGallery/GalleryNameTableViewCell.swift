//
//  GalleryNameTableViewCell.swift
//  ImageGallery
//
//  Created by Emanuel on 11/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

class GalleryNameTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            nameTextField.delegate = self
//            let tap = UITapGestureRecognizer(target: self, action: #selector(startEditing))
//            tap.numberOfTapsRequired = 2
//            nameTextField.addGestureRecognizer(tap)
        }
    }
    
    func startEditing(){
        nameTextField.isUserInteractionEnabled = true
//        nameTextField.isEnabled = true
        nameTextField.becomeFirstResponder()
    }
    
    var resignationHandler : (()->Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.isUserInteractionEnabled = false
//        nameTextField.isEnabled = false
        nameTextField.resignFirstResponder()
        return true
    }
}
