//
//  ViewController.swift
//  Note
//
//  Created by Thao Doan on 3/17/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import UIKit
import Vision
import CoreData


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate{

    var notes = [Note]()
    let context = CoreDataStack.shared.context
    let userPickImage = UIImagePickerController()
    
    
   
    
    @IBOutlet weak var tableView: UITableView!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        userPickImage.delegate = self
        
        userPickImage.allowsEditing = false
        
        userPickImage.sourceType = .camera
    
        tableView.separatorStyle = .singleLine
                
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNoteItem()
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
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! DisplayNoteTableViewCell
        
        let note = notes[indexPath.row]
        
//        cell.imageSavedView?.image = UIImage.imageFor(note.guid)
//        cell.textViewSaved.text = note.text
        
//        cell.imageView?.image = UIImage.imageFor(note.guid)
        cell.photoView.image = UIImage.imageFor(note.guid)
        cell.noteContentLabel.text = note.text
        cell.titleLabel.text = note.title
        
        cell.layoutMargins = UIEdgeInsets.zero // remove table cell separator margin
        cell.contentView.layoutMargins.left = 30 // set up left margin to 20
    
        cell.contentView.backgroundColor = .clear
        
        cell.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        
        
        
        
    
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    return notes.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//            if let cell = tableView.cellForRow(at: indexPath) as? DisplayNoteTableViewCell {
//            
//            tableView.beginUpdates()
//            tableView.endUpdates()
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
//    }

    
    
    
    func loadNoteItem(){
        
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        do {
           
            notes = try context.fetch(request)
            tableView.reloadData()
            
        } catch {
            
            print("Error fetching data from context\(error)")
        }
        
        
        
    }
    
    
    }
    



