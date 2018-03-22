//
//  NoteViewController.swift
//  Note
//
//  Created by Thao Doan on 3/18/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{
   
    @IBOutlet weak var noteTableView: UITableView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
    
       return cell
    }

}

