//
//  PhotoCapturedViewController.swift
//  Note
//
//  Created by Thao Doan on 3/17/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class PhotoCapturedViewController: UIViewController {

    var image: UIImage?
    var titleDetails : UILabel?
    var textViewDetails : UITextView?
    
   func makeButton() -> UIBarButtonItem {
        return  UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
    }
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var displayPhoto: UIImageView!
    
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let existingNote = note { // set image and text UI for existing note
            displayPhoto.image = .imageFor(UIImage.originalImagePath(for: existingNote.guid!))
            textView.text = existingNote.text
            titleTextField.text = existingNote.title
        } else { // create new note, then set image from camera
            let context = CoreDataStack.shared.context
            let noteDescription = NSEntityDescription.entity(forEntityName: "Note", in: context)!
            note = NSManagedObject(entity: noteDescription, insertInto: context) as? Note
            displayPhoto.image = image
            
            // set guid for new note
            let randomString = NSUUID().uuidString
            note?.setValue(randomString, forKey: "guid")
        }
        
        self.navigationItem.rightBarButtonItem = makeButton()
//        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.7333333333, blue: 0.9411764706, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.737254902, green: 0.9215686275, blue: 0.2352941176, alpha: 1)
        
//        textView.backgroundColor = UIColor.randomFlat.lighten(byPercentage: 0.7)
        textView.backgroundColor = #colorLiteral(red: 1, green: 0.9294117647, blue: 0.3647058824, alpha: 1)
        textLabel.textColor = UIColor.randomFlat.darken(byPercentage: 0.9)
        titleTextField.backgroundColor = #colorLiteral(red: 0.4862745098, green: 0.7411764706, blue: 0.1176470588, alpha: 1)
    }
    
    @objc func doneButtonTapped() {
        
        // create note from user's text
    
        let context = CoreDataStack.shared.context
        note?.setValue(textView.text, forKey: "text")
        note?.setValue(titleTextField.text, forKey: "title")
        
        // get thumbnail in place for new note
        let thumbnailSize = CGSize.init(width: 600, height: 600)
        let thumbnailData = UIImageJPEGRepresentation(displayPhoto.image!.imageScaled(to: thumbnailSize), 0.9)
        
        // write to thumbnail path
        let documentDir = FileManager.default.documentsDirectory()
        let thumbnailPath = documentDir.appendingPathComponent("\(note!.guid!)-thumbnail.jpg")
        try? thumbnailData?.write(to: thumbnailPath)
        
        // get original image in place for new note
        let data = UIImageJPEGRepresentation(displayPhoto.image!, 0.9)
        
        // write to orignal photo path
        let photoPath = documentDir.appendingPathComponent("\(note!.guid!).jpg")
        try? data?.write(to: photoPath)
        
        // save Core Data
        try? context.save()
        
        // leave
        navigationController?.popToRootViewController(animated: true)
    }
   
}

