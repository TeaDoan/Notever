//
//  PhotoCapturedViewController.swift
//  Note
//
//  Created by Thao Doan on 3/17/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import UIKit
import CoreData 

class PhotoCapturedViewController: UIViewController {

    
    var image: UIImage?
    
    func makeButton() -> UIBarButtonItem {
        return  UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
    }
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    
    @IBOutlet weak var displayPhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayPhoto.image = image
        self.navigationItem.rightBarButtonItem = makeButton()
        
    }
    
    @objc func doneButtonTapped() {
        let context = CoreDataStack.shared.context
        
        /// Create note entity
        let noteDescription = NSEntityDescription.entity(forEntityName: "Note", in: context)!
        let note = NSManagedObject(entity: noteDescription, insertInto: context)
        
        note.setValue(textView.text, forKey: "text")
//        note.setValue(UIImagePNGRepresentation(image!), forKey: "photo")
        
        try? context.save()
        
        navigationController?.popToRootViewController(animated: true)
    }
   
    
}
