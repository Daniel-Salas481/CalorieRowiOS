//
//  firstTimeSignIn.swift
//  CalorieRow
//
//  Created by Daniel Salas on 11/10/21.
//

import UIKit
import CoreData


class firstTimeSignIn: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items:[Person]?
    var calorieStart:[CaloriesLeft]?
    var calorieBegin:[CalorieIntake]?
    var foodItem:[FoodEaten]?
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var ProfilePicture: UIImageView!
    
    
    
    
    
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 22;
        createDataPicker()
        
        // Do any additional setup after loading the view.
    }
    
    func fetchPerson(){
        //fetching the data from the core data
        do{
            self.items = try context.fetch(Person.fetchRequest())
            
           
        }catch{
            print("an error has occured")
        }
        
    }
    
    func fetchCalories(){
        //fetching the data from the core data
        do{
            self.calorieStart = try context.fetch(CaloriesLeft.fetchRequest())
            
           
        }catch{
            print("an error has occured")
        }
        
    }
    
    
    func fetchCaloriesI(){
        //fetching the data from the core data
        do{
            self.calorieBegin = try context.fetch(CalorieIntake.fetchRequest())
            
           
        }catch{
            print("an error has occured")
        }
        
    }
    
    
    func fetchFood(){
        //fetching the data from the core data
        do{
            self.foodItem = try context.fetch(FoodEaten.fetchRequest())
            
           
        }catch{
            print("an error has occured")
        }
        
    }
    
    func createToolbar() -> UIToolbar{
        //toolbar
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit();
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
    }
    
    func createDataPicker(){
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        birthdayTextField.inputView = datePicker;
        birthdayTextField.inputAccessoryView = createToolbar();
    }
    
    @objc func donePressed(){
        let dateFormatter =  DateFormatter()
        dateFormatter.dateStyle = .medium;
        dateFormatter.timeStyle = .none;
        
        self.birthdayTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true);
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            ProfilePicture.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func imagePickButon(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        
        present(vc, animated: true)
    }
    
    
    
    
    
    @IBAction func submitDone(_ sender: Any) {
        //Creating the data
        let newPerson = Person(context: self.context)
        let newCalories = CaloriesLeft(context: self.context)
        let newStart = CalorieIntake(context: self.context)
        let ResetFood = FoodEaten(context: self.context)
        let resetAddress = WorkoutLocation(context: self.context)
        
        newPerson.firstname = firstNameField.text!
        newPerson.lastname = lastNameField.text!
        newPerson.birthday = birthdayTextField.text!
        newPerson.weight = Int64(weightField.text!)!
        
        //Reset the food
        ResetFood.foodName = "Nothing Added Yet"
        ResetFood.calories = 0.0
        
        //Reset Workout location
        resetAddress.address = "No Address selected yet"
        
        
        
        newCalories.caloriesLeft = 2000.00;
        newStart.calorieIntake = 0.0;
        
        
        //Save the data
        do{
        try self.context.save()
        }catch{
            print("an error has occured")
        }
        
        //Creating alert before we go to next View controller
        
        
        
        let alert = UIAlertController(title: "Success!", message: "Welcome \(newPerson.firstname!)! Lets get started! You will start off with 2000 calories everyday", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:
        {
            action in print("cool")
            self.performSegue(withIdentifier: "buttonthing", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            action in print("cool")
            print(":(")
        }))
        present(alert, animated: true)
        
        print("\(newPerson.firstname!) is added to core data")
        print("\(newPerson.lastname!) is added to core data")
        print("\(newPerson.birthday!) is added to core data")
        print("\(newPerson.weight) is added to core data")
        
        
        
       
}
}

