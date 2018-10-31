//
//  ViewController.swift
//  Kacchi No Kacchi
//
//  Created by Shawon Ashraf on 10/31/18.
//  Copyright © 2018 Shawon Ashraf. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // imagePicker properties
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // deal with the edited image
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = userPickedImage
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func loadImagePicker() {
        // check if camera is available
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            imagePicker.sourceType = .photoLibrary
            return
        }
    }
    

    @IBAction func cameraButtonPressed(_ sender: Any) {
        loadImagePicker()
        present(imagePicker, animated: true, completion: nil)
    }
    
}

