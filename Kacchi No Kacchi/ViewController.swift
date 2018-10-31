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
    
    // MARK: - image picker
    let imagePicker = UIImagePickerController()
    
    // MARK: - CoreML classificationRequest
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: Kacchi_No_Kacchi_1().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                guard let results = request.results as? [VNClassificationObservation] else {
                    fatalError("Model failed to process image")
                }
                
                // process results
                self!.processClassificationResults(results: results)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // imagePicker properties
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    // MARK: - ImagePicker delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // deal with the edited image
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = userPickedImage
            
            // run inference
            runInference(on: userPickedImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Load image source
    func loadImageSource() {
        // check if camera is available
        // else load from photo library
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            imagePicker.sourceType = .photoLibrary
            return
        }
    }
    
    // MARK: - Classification methods
    func runInference(on image: UIImage) {
        guard let binaryImage = CIImage(image: image) else {
            fatalError("Couldn't convert image to binary")
        }
        classify(image: binaryImage)
    }
    
    func classify(image: CIImage) {
        let handler = VNImageRequestHandler(ciImage: image)
        try! handler.perform([classificationRequest])
    }
    
    // MARK: - Result processing
    func processClassificationResults(results: [VNClassificationObservation]) {
        // the first result is the dominant result from classification
        var navBarTitle = ""
        
        if let firstResult = results.first {
            if firstResult.identifier.contains("kacchi") {
                // set title to Kacchi
                navBarTitle = "কাচ্চি"
            } else {
                // set title to No-Kacchi
                navBarTitle = "নু-কাচ্চি"
            }
        } else {
            navBarTitle = "কইতারি না এইডা কি!"
        }
        
        updateNavbarTitle(with: navBarTitle)
    }
    
    // MARK: - Update UI
    func updateNavbarTitle(with title: String) {
        self.navigationItem.title = title
    }

    // MARK: - Event handlers
    @IBAction func cameraButtonPressed(_ sender: Any) {
        loadImageSource()
        present(imagePicker, animated: true, completion: nil)
    }
    
}

