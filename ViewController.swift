//
//  ViewController.swift
//  CalorieRow
//
//  Created by Daniel Salas on 11/10/21.
//

import UIKit
import CoreData
import Charts

class ViewController: UIViewController {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items:[Person]?
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signBackInButton: UIButton!
    
    
    
    func entityIsEmpty()
    {
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")

        do {
            let result = try context.fetch(fetchRequest)
            if result.isEmpty {
                print("data not exist")
                let alert = UIAlertController(title: "No User Found", message: "It looks like no user has been found. Please make an account", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                      print("Handle Cancel Logic here")
                }))
                
                
                present(alert, animated: true)
                return
            } else {
                print("data exist")
                self.performSegue(withIdentifier: "signBackIn", sender: nil)
            }


        } catch {
            print(error)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.layer.cornerRadius = 22;
        signBackInButton.layer.cornerRadius = 22;
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func signBackIn(_ sender: Any) {
        
        entityIsEmpty()
        
    }
    

}

