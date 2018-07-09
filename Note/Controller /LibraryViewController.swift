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

private enum TSegue: String {
    case onboard = "onboard"
    case showPhotos = "showPhotos"
}
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let context = CoreDataStack.shared.context
    let userPickImage = UIImagePickerController()
    let searchController = UISearchController(searchResultsController: nil)
    
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
//        tableView.tableFooterView = UIView(frame: .zero)
        userPickImage.delegate = self
        userPickImage.allowsEditing = false
        userPickImage.sourceType = .camera
        tableView.separatorStyle = .singleLine
//        try? fetchedResultsController.performFetch()
        loadNoteItem()
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.737254902, green: 0.9215686275, blue: 0.2352941176, alpha: 1)
        // show onboarding on first launch
        let hasLaunchedKey = "appHasLaunched"
        if UserDefaults.standard.value(forKey: hasLaunchedKey) == nil {
            performSegue(withIdentifier: "onboard", sender: nil)
            UserDefaults.standard.set(false, forKey: hasLaunchedKey)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.737254902, green: 0.9215686275, blue: 0.2352941176, alpha: 1)
         loadNoteItem()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPhotos", sender: fetchedResultsController.object(at: indexPath))
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            performSegue(withIdentifier: "showPhotos", sender: userPickedImage)
        }
        userPickImage.dismiss(animated: true, completion: nil)
    }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard let tSegue = TSegue(rawValue: segue.identifier!) else { return }
            print("about to perform segue: \(tSegue.rawValue)")
            switch tSegue {
            case .showPhotos:
                let captureVC = segue.destination as! PhotoCapturedViewController
                if let image = sender as? UIImage {
                    captureVC.image = image // new note -> pass image
                } else if let note = sender as? Note {
                    captureVC.note = note // existing note -> pass note
                }
            case .onboard: break
                // you'd do any preparation before showing onboarding here
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
        cell.backgroundColor = UIColor.init(randomFlatColorOf: .dark, withAlpha: 0.5).lighten(byPercentage: 0.9)
        cell.noteContentLabel.textColor = UIColor.randomFlat.darken(byPercentage: 1.0)
        cell.titleLabel.textColor = UIColor.randomFlat.darken(byPercentage: 0.5)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        let eventArrayItem = fetchedResultsController.object(at:indexPath)
        if editingStyle == .delete {
            context.delete(eventArrayItem)
            do {
                try context.save()
               tableView.reloadData()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
        }
    }
    

    func loadNoteItem(){
        try? fetchedResultsController.performFetch()
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
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
}









