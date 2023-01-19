//
//  LoginAPIManager.swift
//  iOSMVVMArchitecture
//
//  Created by Amit Shukla on 14/01/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import Foundation
import UIKit

let token = "#Enter your token here"

public class UserService {
    
    // Fetch employee list
    func doLogin(with params:Parameters,
                 completion:@escaping (Result<User>) -> Void) {
        
        Router.data(Endpoints.user("login"), method: .post, parameters: params, encoder: JSONEncoding.default)
            .responseDecodable(decodingType: User.self) { (result) in
                switch result {
                case .Success(let user):
                    debugPrint("response = \(user)")
                    completion(.Success(user))
                case .Error(let error):
                    debugPrint("error = \(error.localizedDescription)")
                    completion(.Error(error))
                }
        }
    }

    // Upload file to server
    func uploadFile(_ image:UIImage, _ completion:@escaping (String?) -> Void) {

        Router.upload(Endpoints.user("avatar"),
                      filename: "avatar",
                      name: "avatar",
                      data: image.pngData(),
                      parameters: nil)
        .authenticate(token)
            .response { (result) in
                switch result {
                case .Success(let response):
                    if let dict = response as? Parameters,
                        let message = dict["message"] as? String {
                        print(message)
                        completion(message)
                    }
                case .Error(let error):
                    debugPrint("error = \(error.localizedDescription)")
                    completion(nil)
                }
        }
    }
}

