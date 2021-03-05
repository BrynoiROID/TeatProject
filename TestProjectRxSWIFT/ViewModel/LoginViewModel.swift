    //
    //  LoginViewModel.swift
    //  TestProjectRxSWIFT
    //
    //  Created by iROID on 05/03/21.
    //
    import RxSwift

    import RxCocoa

    import UIKit

    import Alamofire

    import CoreData

    import SwiftyJSON


    class LoginViewModel  {
        public let data : PublishSubject<DataModel> = PublishSubject()
        public var userData: [NSManagedObject] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
           var context:NSManagedObjectContext!
        //MARK:- Validation function
        func isValid(email : String, password : String) -> Bool {
            if email == ""{
                Helper.showAlert(message: "Enter Your Registered Email")
            }else if !Helper.validateEmail(email){
                Helper.showAlert(message: "Email Not Valid")
            }else if password == ""{
                Helper.showAlert(message: "Password required")
            }else if password.count < 6{
                Helper.showAlert(message: "Password 6 digit required")
            } else {
            return true
            }
            return false
        }
      
        //MARK:- Login API Call
        
        public func LoginAPI(email : String, password : String ,
            taskCallback: @escaping (Int,
                                                                                                                                                                     AnyObject?) -> Void) {
            LoadingIndicatorView.show()
            let semaphore = DispatchSemaphore (value: 0)
           
            let dict = ["email": email, "password": password] as [String : String]

            let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: [])
            let decoded = String(data: jsonData, encoding: .utf8)!

            let postData = decoded.data(using: .utf8)
            var request = URLRequest(url: URL(string: "http://imaginato.mocklab.io/login")!,timeoutInterval: Double.infinity)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else
              {
                print(String(describing: error))
                return
              }
              print(String(data: data, encoding: .utf8)!)
                
                do {
                    let data1 = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    taskCallback(1,data1 as AnyObject)
                } catch {
                    print(error)
                }
                
                

             LoadingIndicatorView.hide()
              semaphore.signal()
            }
            
            task.resume()
            semaphore.wait()
        }
        func convertToDictionary(from text: String) throws -> [String: String] {
            guard let data = text.data(using: .utf8) else { return [:] }
            let anyResult: Any = try JSONSerialization.jsonObject(with: data, options: [])
            return anyResult as? [String: String] ?? [:]
        }
        
        //MARK:- Save to Db
       
        
        public func savetoDb(username : String,createddate: String) {
            //deleting old data
            self.fetchFromDb()
            
            
            //proceed to save
            context = appDelegate.persistentContainer.viewContext

                    let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
                    let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(username, forKeyPath: "username")
            newUser.setValue(createddate, forKeyPath: "createddate")
           

            print("Storing Data..")
            do {
                try context.save()
            } catch {
                print("Storing data Failed")
            }
            
            
          
        }
        
        //MARK:- Delete from Db
        public func fetchFromDb() {
            let managedContext =
              appDelegate.persistentContainer.viewContext
            let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
               let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
            do { try managedContext.execute(DelAllReqVar) }
               catch { print(error) }
        }
    }

