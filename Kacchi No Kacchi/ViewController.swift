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
    
    // CoreML classificationRequest
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: Kacchi_No_Kacchi_1().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                guard let results = request.results as? [VNClassificationObservation] else {
                    fatalError("Model failed to process image")
                }
                
                print(results)
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // deal with the edited image
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = userPickedImage
            
            // run inference
            runInference(on: userPickedImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func loadImageSource() {
        // check if camera is available
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            imagePicker.sourceType = .photoLibrary
            return
        }
    }
    
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

    @IBAction func cameraButtonPressed(_ sender: Any) {
        loadImageSource()
        present(imagePicker, animated: true, completion: nil)
    }
    
}

