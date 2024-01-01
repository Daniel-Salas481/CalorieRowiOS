//
//  dashBoardViewController.swift
//  CalorieRow
//
//  Created by Daniel Salas on 11/10/21.
//

import UIKit
import Charts

class dashBoardViewController: UIViewController {

    //TODO:
    /*let the user add their profile picture*/
    
    //TODO:
    /*Design the dashboard on how you closesly to the UI walkthrough of your phase 1 plan*/
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items:[Person]?
    var foodItem:[FoodEaten]?
    var caloriesL:[CaloriesLeft]?
    var calorieI:[CalorieIntake]?
    var address:[WorkoutLocation]?
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var lastFoodLabel: UILabel!
    @IBOutlet weak var lastCalorieLabel: UILabel!
    @IBOutlet weak var latestWorkoutaddress: UILabel!
    
    var calorieLeftDataEntry = PieChartDataEntry(value: 0)
    var calorieIntakeDataEntry = PieChartDataEntry(value: 0)
    
    var numberOfDataEntries = [PieChartDataEntry]()
    
    
    func fetchPerson(){
        //fetching the data from the core data
        do{
            self.items = try context.fetch(Person.fetchRequest())
        }catch{
            print("an error has occured")
        }
        
    }
    
    
    func fetchLatestFood(){
        do{
            self.foodItem = try context.fetch(FoodEaten.fetchRequest())
        }catch{
            print("an error has occured ")
        }
    }
    
    func fetchCaloriesLeft(){
        do{
            self.caloriesL = try context.fetch(CaloriesLeft.fetchRequest())
        }catch{
            print("an error has occured ")
        }
    }
    
    func fetchCalorieIntake(){
        do{
            self.calorieI = try context.fetch(CalorieIntake.fetchRequest())
        }catch{
            print("an error has occured ")
        }
    }
    
    func fetchWorkoutAddress()
    {
        do{
            self.address = try context.fetch(WorkoutLocation.fetchRequest())
        }catch{
            print("an error has occured ")
        }
        
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPerson()
        fetchLatestFood()
        fetchCaloriesLeft()
        fetchCalorieIntake()
        fetchWorkoutAddress()
        let person = self.items?.last
        let foody = self.foodItem?.last
        let caloric = self.caloriesL?.last
        let caloricI = self.calorieI?.last
        let wAddress = self.address?.last
        
        
        userName.text = person?.firstname
        weightLabel.text = String(person!.weight)
        lastFoodLabel.text = foody?.foodName ?? "Nothing Added Yet"
        lastCalorieLabel.text = String(foody?.calories ?? 0)
        latestWorkoutaddress.text = wAddress?.address ?? "Nothing Added yet"
        pieChartView.chartDescription?.text = ""
        
        calorieLeftDataEntry.value = caloric!.caloriesLeft
       calorieLeftDataEntry.label = "Calories left"
        
        calorieIntakeDataEntry.value = caloricI!.calorieIntake
       calorieIntakeDataEntry.label = "Calories intake"
        
        numberOfDataEntries = [calorieLeftDataEntry, calorieIntakeDataEntry]
        
        // Do any additional setup after loading the view.
        
        updateChartData()
    }
    

    func updateChartData(){
        
        let chartDataSet = PieChartDataSet(entries: numberOfDataEntries, label: nil)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor(named: "cLeftColor"), UIColor(named:"cIntakeColor")]
        chartDataSet.colors = colors as! [NSUIColor]
        
        
        pieChartView.data = chartData
    }
  
    func lastFoodUpdate()
    {
        //Fix this later
        fetchLatestFood()
    }

}
