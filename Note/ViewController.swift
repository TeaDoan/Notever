//
//  ViewController.swift
//  Note
//
//  Created by Thao Doan on 3/17/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraView: UIImageView!
    
    let userPickImage = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPickImage.delegate = self
        
        userPickImage.allowsEditing = false
        
        userPickImage.sourceType = .camera
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
//            cameraView.image = userPickedImage
            
            performSegue(withIdentifier: "showPhotos", sender: userPickedImage)
            
           
        }
        
       userPickImage.dismiss(animated: true, completion: nil)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showPhotos" {
            
            if let caputreVC = segue.destination as? PhotoCapturedViewController {
                
                if let image = sender as? UIImage {
                    
                    caputreVC.image = image
                }
                
                
            }
            
            
           
            
            
        }
        
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(userPickImage, animated: true, completion: nil)
    }
    
   
    

    
    }
    



