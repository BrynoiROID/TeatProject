//
//  DataModel.swift
//  TestProjectRxSWIFT
//
//  Created by iROID on 05/03/21.
//

import Foundation

struct DataModel : Decodable {
    let status : Bool?
    let name : String?
    let email : String?
    let access_token : String?
    let token_type : String?
    let message : String?
    let pending_status : Bool?
}
