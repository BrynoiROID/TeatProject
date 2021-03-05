//
//  LoginVC.swift
//  TestProjectRxSWIFT
//
//  Created by iROID on 05/03/21.
//

import UIKit

import SkyFloatingLabelTextField

import RxSwift

import RxSwiftExt

import RxCocoa

import SwiftyJSON
class LoginVC: UIViewController {

@IBOutlet weak var textFieldEmail: SkyFloatingLabelTextField!

@IBOutlet weak var textFieldPassword: SkyFloatingLabelTextField!

@IBOutlet weak var buttonLogin: UIButton!

@IBOutlet weak var viewBackground: UIView!

let disposeBag = DisposeBag()

var viewModel = LoginViewModel()

public var data = PublishSubject<DataModel>()


//MARK:- UI Cycle
override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.initialSetupUI()
}
func loadnewView()  {
    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashBoardViewController") as? DashBoardViewController
    
    
    self.navigationController!.pushViewController(vc!, animated: true)
}
func initialSetupUI(){
    Helper.StatusBarColor(view: self.view)
    self.viewBackground.layer.cornerRadius = Helper.AppViewCornerRadius
    self.viewBackground.layer.masksToBounds = false
    self.viewBackground.layer.shadowColor = Helper.colorFromHexString(hex: "#5B5B5B").cgColor
    self.viewBackground.layer.shadowOffset = CGSize.zero
    self.viewBackground.layer.shadowOpacity = 0.7
    self.viewBackground.layer.shadowRadius = 10
    self.buttonLogin.layer.cornerRadius = Helper.AppButtonCornerRadius
    setupBinding()
}
//MARK:- Binding
func setupBinding() {
    viewModel.data.observe(on: MainScheduler.instance).bind(to: self.data).disposed(by: disposeBag)
}
//MARK:- Login Click Action
@IBAction func bttnLoginClick(_ sender: Any) {
    DispatchQueue.main.async {
        self.checkConnectivity()
    }
}

//MARK:- check internet and call api
func checkConnectivity() {
    if Helper.checkConnectivity() {
        if viewModel.isValid(email: textFieldEmail.text!, password: textFieldPassword.text!) {
            viewModel.LoginAPI(email : textFieldEmail.text!, password : textFieldPassword.text!){ [weak self] success, responseObject  in
                if success == 1
                {
                    guard let dict = responseObject as? NSDictionary else {
                        // ShowNotificationMessages.sharedInstance.warningView(message: "somethingwentwrong")
                        return
                    }
                    let responseJSON = JSON(dict)
                    let object1 = responseObject as? NSDictionary ?? [:]
                    
                    
                    let result = object1.object(forKey: "data") as! NSDictionary
                    if result.object(forKey: "user") != nil
                    {
                        DispatchQueue.main.async {
                            let user = result.object(forKey: "user") as! NSDictionary
                            //savingdata
                            self?.viewModel.savetoDb(username : user.object(forKey: "userName") as! String ,createddate: user.object(forKey: "created_at") as! String )
                            
                            self?.loadnewView()
                            
                        }
                    }else
                    {
                        DispatchQueue.main.async {
                            let message = object1.object(forKey: "error_message") as? String
                            
                            Helper.showAlert(message: message ?? "")
                        }
                    }
                    
                    
                    
                }
                
            }
        }
    } else {
        Helper.showAlert(message: "Not connected to internet")
    }
}
}


