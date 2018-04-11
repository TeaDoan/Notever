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
import ChameleonFramework


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate{
// notes is an object which is an array of Note
    var notes = [Note]()
    
    let context = CoreDataStack.shared.context
    let userPickImage = UIImagePickerController()
    let searchController = UISearchController(searchResultsController: nil)
   

//
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        let request = NSFetchRequest<Note>(entityName:"Note")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: CoreDataStack.shared.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self 
        return frc
    }()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        userPickImage.delegate = self
        
        userPickImage.allowsEditing = false
        
        userPickImage.sourceType = .camera
        
        tableView.separatorStyle = .singleLine
        
        try? fetchedResultsController.performFetch()
        
         self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9450980392, green: 0.168627451, blue: 0.4196078431, alpha: 1)
        
        
        
        
        
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
      self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9450980392, green: 0.168627451, blue: 0.4196078431, alpha: 1)
        
         loadNoteItem()
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showPhotos", sender: notes[indexPath.row])
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showPhotos"{
//            let viewController:PhotoCapturedViewController = segue.destination as! PhotoCapturedViewController
////            viewController.image = sender as! Note
//            viewController.textViewDetails = sender as? UITextView
//            viewController.titleDetails = sender as? UILabel
//
//        }
//    }


    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
//            cameraView.image = userPickedImage
            
            performSegue(withIdentifier: "showPhotos", sender: userPickedImage)
        
        }
        
        userPickImage.dismiss(animated: true, completion: nil)
    }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "showPhotos" {
                
                if let captureVC = segue.destination as? PhotoCapturedViewController {
                    
                    if let image = sender as? UIImage { // image -> new note
                        captureVC.image = image
                        
                    } else if let note = sender as? Note { // existing note
                        captureVC.note = note
                    }
                }
            }
        }
    

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(userPickImage, animated: true, completion: nil)
    }
    

   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! DisplayNoteTableViewCell
        let note = fetchedResultsController.object(at: indexPath)
        
        cell.photoView.image = UIImage.imageFor(UIImage.thumbnailPath(for: note.guid!))
        
        cell.noteContentLabel.text = note.text
        cell.titleLabel.text = note.title
        cell.layoutMargins = UIEdgeInsets.zero // remove table cell separator margin
        cell.contentView.layoutMargins.left = 30 // set up left margin to 30
        cell.contentView.backgroundColor = .clear
        
//        UIImage.imageFor(note.guid)!
        
//        cell.photoView?.image = imageWithImage(image: UIImage.imageFor(note.guid), scaledToSize: cell.photoView?.bounds.size ?? .zero)
        
//        cell.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)

//        cell.backgroundColor = UIColor.randomFlat.lighten(byPercentage: 0.9)
//
//        cell.noteContentLabel.textColor = UIColor.randomFlat.darken(byPercentage: 1.0)
//
//        cell.titleLabel.textColor = UIColor.randomFlat.darken(byPercentage: 0.5)
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
   
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        let eventArrayItem = notes[indexPath.row]

        if editingStyle == .delete {

            context.delete(eventArrayItem)

            do {
                try context.save()

              tableView.reloadData()

            } catch let error as NSError {

                print("Error While Deleting Note: \(error.userInfo)")
            }
        }
        
        loadNoteItem()

    }


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

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let searchText = searchBar.text  else  {return}
        var predicate : NSPredicate?
        
         if searchText.count != 0 {
            
            predicate = NSPredicate(format: "title CONTAINS[Cd] %@",searchText,searchText)
        }
        fetchedResultsController.fetchRequest.predicate = predicate
        try? fetchedResultsController.performFetch()
        
       tableView.reloadData()
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .move: return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

//extension UIImage {
//    func fixOrientation() -> UIImage {
//        if self.imageOrientation == UIImageOrientation.up {
//            return self
//        }
//        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
//        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
//        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
//            UIGraphicsEndImageContext()
//            return normalizedImage
//        } else {
//            return self
//        }
//    }
//}












