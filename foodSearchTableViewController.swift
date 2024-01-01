//
//  foodSearchTableViewController.swift
//  CalorieRow
//
//  Created by Daniel Salas on 11/12/21.
//

import UIKit
import CoreData

var result: Result?
var foodEat:[FoodEaten]?
var calorieL:[CaloriesLeft]?
var calorieI:[CalorieIntake]?

//Obtaining and structuring our API here
struct Root {
    let totalHits: Int
}

struct foodNutrients{
    //Calories
    let nutrientName: String
    let value: Double
}


struct food{
    //let fdcId: Int
    let description: String
    let fdn:[foodNutrients]
}

struct foods
{
    let fds : [food]
}

extension foods: Decodable
{
    private enum Key: String, CodingKey
    {
        case fds = "foods"
    }
    
    init (from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: Key.self)
        self.fds = try container.decode([food].self, forKey: .fds)
    }
}

extension food: Decodable
{
    private enum Key: String, CodingKey
    {
        
        case description = "description"
        case fdn = "foodNutrients"
    }
    
    init (from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: Key.self)
        self.description = try container.decode(String.self, forKey: .description)
        self.fdn = try container.decode([foodNutrients].self, forKey: .fdn)
    }
}

extension foodNutrients: Decodable
{
    private enum Key: String, CodingKey
    {
        case nutrientName = "nutrientName"
        case value = "value"
    }
    
    init (from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: Key.self)
        self.nutrientName = try container.decode(String.self, forKey: .nutrientName)
        self.value = try container.decode(Double.self, forKey: .value)
    }
}

extension Root: Decodable
{
    private enum Key: String, CodingKey
    {
        case totalHits = "totalHits"
        case foodNutrients = "foodNutrients"
    }
    
    init (from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: Key.self)
        self.totalHits = try container.decode(Int.self, forKey: .totalHits)
       
    }
}

var CalorieStruct = [Result]()





class foodSearchTableViewController: UITableViewController, UISearchBarDelegate{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func fetchCaloriesLeft(){
        do{
            calorieL = try context.fetch(CaloriesLeft.fetchRequest())
        }catch{
            print("an error has occured ")
        }
    }

    func fetchCalorieIntake(){
        do{
            calorieI = try context.fetch(CalorieIntake.fetchRequest())
        }catch{
            print("an error has occured ")
        }
    }

    //for testing. We are going to add the API after this.
    var filterData = result?.data
    let api_key = "vvS1NrESxlYGwE8qdZ269X6SwYPnZE63yMvFxQiC"
    let query = "apple"
    let data_type = "Survey (FNDDS)"

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        fetchCaloriesLeft()
        fetchCalorieIntake()
        let caloric = calorieL?.last
        let caloricI = calorieI?.last
        
        print("\(caloric!.caloriesLeft)")
        print("\(caloricI!.calorieIntake)")
        tableView.reloadData()

    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (result == nil)
        {
            return 0
        }
        return result!.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel!.text = result!.data[indexPath.row].foodName + " (Cals:" + String(result!.data[indexPath.row].calories) + ")"
        
        return cell
    }
    
   
  var holder = ""
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        let calorL = calorieL?.last
        let calorI = calorieI?.last
        print("Calories Left Before: \(calorL!.caloriesLeft)" )
        print("Calories Intake Before: \(calorI!.calorieIntake)" )
        if(calorL!.caloriesLeft < result!.data[indexPath.row].calories)
        {
            //go here if we've reached the limit
            let tooMuchAlert = UIAlertController(title: "Went Over Calorie Limit", message: "Adding this food would go over your calorie Limit. Please wait till tommorow", preferredStyle: .alert)
            tooMuchAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { (action: UIAlertAction!) in
                self.performSegue(withIdentifier: "nuts", sender: nil)
        }))
            
            present(tooMuchAlert, animated: true)
        }else{
            
            let alert = UIAlertController(title: "Food Choice", message: "\(result!.data[indexPath.row].foodName) has \(result!.data[indexPath.row].calories) Calories. Do you want to add that to your intake today?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:
            {
                action in print("cool")
                
                
                calorL?.caloriesLeft = calorL!.caloriesLeft - result!.data[indexPath.row].calories
                calorI?.calorieIntake = calorI!.calorieIntake + result!.data[indexPath.row].calories
                
                print("Calories Left After: \(calorL!.caloriesLeft)" )
                print("Calories Intake After: \(calorI!.calorieIntake)" )
                
                let newFood = FoodEaten(context: self.context)
                
                newFood.foodName = result!.data[indexPath.row].foodName
                newFood.calories = result!.data[indexPath.row].calories
                print("Added: \(newFood.foodName!)")
                print("Added: \(newFood.calories)")
                self.holder = newFood.foodName!
                
                do{
                try self.context.save()
                }catch{
                    print("an error has occured")
                }
                
                self.performSegue(withIdentifier: "nuts", sender: nil)
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
            }))
            
            
            present(alert, animated: true)

        }
        
        
        
                
    }
    
    
    //var temp:String = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "nuts"){
    
            let dashboardView = segue.destination as! dashBoardViewController
            dashboardView.lastFoodUpdate()
    
            
        }
    }
    
    
    
    func unwindToTable(   sender: UIStoryboardSegue){
        
        
    }
    
    //NOTE: Search Bar Config
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        
        
        guard let text = searchBar.text, !text.isEmpty else{
            return
        }
        
        
        let escapedString = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let url_str = "https://api.nal.usda.gov/fdc/v1/foods/search?query=\(escapedString)&pageSize=30&api_key=vvS1NrESxlYGwE8qdZ269X6SwYPnZE63yMvFxQiC"
        let url = URL(string: url_str)!
        let request = URLRequest(url: url)
        let session = URLSession.shared

        session.dataTask(with: request)
        {
            data, response, error  in
            guard let data = data else { return }

            
            
            
            do
            {
               //let roots = try JSONDecoder().decode(Root.self, from: data)
        
                let foodNut = try JSONDecoder().decode(foods.self, from: data)
                result = Result(data:[])
                for food in foodNut.fds{
                    var c: Double = 0
                    for val in food.fdn{
                        if val.nutrientName == "Energy"
                        {
                            c = val.value
                            break
                        }
                    }
                    
                    var rs : ResultItem = ResultItem(foodName: food.description, calories: c)
                    result?.data.append(rs)
                    
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }catch
        {
                print (error)
        }
            
        
            
            print(result?.data.first?.foodName)

        }.resume()
        
        
        if text == ""{

            
        }else{

        }
    }
}
