//
//  DashBoardViewController.swift
//  TestProjectRxSWIFT
//
//  Created by Bryno Baby on 04/03/21.
//

import UIKit
import CoreData

class DashBoardViewController: UIViewController {
var people: [NSManagedObject] = []
let inputDateFormatter = DateFormatter()
let outputDateFormatter = DateFormatter()
@IBOutlet weak var username: UILabel!
@IBOutlet weak var dateLBL: UILabel!
var viewModel = LoginViewModel()


    override func viewDidLoad()  {
    super.viewDidLoad()
    // viewModel.fetchFromDb()
    inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    outputDateFormatter.dateFormat = "dd MMM yyyy  HH:mm:ss"
    guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      //2
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "User")
      
      //3
      do {
        people = try managedContext.fetch(fetchRequest)
        
        print(people[0])
        
        for item in people{

            let keys = Array(item.entity.attributesByName.keys)
            username.text = (item.dictionaryWithValues(forKeys: keys) as NSDictionary).value(forKey: "username") as? String
            
            
            let date1 = (item.dictionaryWithValues(forKeys: keys) as NSDictionary).value(forKey: "createddate") as? String ?? ""
            let inputDate = inputDateFormatter.date(from: date1)
            let outPutDateString = outputDateFormatter.string(from: inputDate!)
          dateLBL.text = outPutDateString
           break
        }
        
        
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    
    
    // Do any additional setup after loading the view.
}

@IBAction func bttnLoginClick(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
}
/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/

}
