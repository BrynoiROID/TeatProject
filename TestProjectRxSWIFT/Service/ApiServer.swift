    //
    //  ApiServer.swift
    //  TestProjectRxSWIFT
    //
    //  Created by iROID on 05/03/21.
    //

    import Foundation

    import RxSwift

    import Alamofire

    class ApiServer {
        
        static let sharedApiInstance = ApiServer()
          
        func PostAPI(url:String, params:Parameters,completion: @escaping (Result<DataModel,Error>) -> ()) {
                LoadingIndicatorView.show()
                 AF.request(url, method: .post, parameters: params,encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
                     LoadingIndicatorView.hide()
                    if response.response?.statusCode == 200 {
                        guard let data = response.data else {return}
                        do {
                        let modeldata = try JSONDecoder().decode(DataModel.self, from: data)
                        completion(.success(modeldata))
                        } catch let err {
                            completion(.failure(err))
                        }
                    } else {
                        if response.response?.statusCode == 404{
                            Helper.showAlert(message: "Page Not Found!")
                        }else{
                            Helper.showAlert(message: "Somthing Went Wrong!")
                        }
                    
                    }
                }
            }
    }
