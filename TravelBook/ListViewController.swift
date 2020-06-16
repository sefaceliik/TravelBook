//
//  ListViewController.swift
//  TravelBook
//
//  Created by Sefa Çelik on 6.05.2020.
//  Copyright © 2020 Sefa Celik. All rights reserved.
//

import CoreData
import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
     // UI
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var titleArray = [String]()
    var idArray = [UUID]()
    var chosenTitle = ""
    var chosenTitleID : UUID?
    
    // TableView configurations
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenTitle = titleArray[indexPath.row]
        //chosenTitleID = idArray[indexPath.row]
        performSegue(withIdentifier: "toViewContoller", sender: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))

        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"),object: nil)
    }
    
    @objc func getData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                self.titleArray.removeAll()
                self.idArray.removeAll()
                
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        self.titleArray.append(title)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArray.append(id)
                    }
                    
                    tableView.reloadData()
                }
            }
        } catch{
            print("Error")
        }
        
    }
    
    @objc func addButtonClicked(){
        chosenTitle = ""
        performSegue(withIdentifier: "toViewContoller", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewContoller" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.selectedTitle = chosenTitle
            destinationVC.selectedID = chosenTitleID
        }
    }
    
}
