//
//  WebService.swift
//
//  Created by Krunal on 18/07/20.
//  Copyright © 2020 Krunal. All rights reserved.



//API call function using session 
// import Foundation

// struct APIResponse<T: Codable>: Codable {
//     let data: T
// }

// func callAPI<T: Codable>(url: URL, payload: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
//     var request = URLRequest(url: url)
//     request.httpMethod = "POST"
//     request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//     request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
    
//     let session = URLSession.shared
//     let task = session.dataTask(with: request) { (data, response, error) in
//         if let error = error {
//             completion(.failure(error))
//             return
//         }
        
//         if let data = data {
//             let decoder = JSONDecoder()
//             do {
//                 let apiResponse = try decoder.decode(APIResponse<T>.self, from: data)
//                 completion(.success(apiResponse.data))
//             } catch {
//                 completion(.failure(error))
//             }
//         }
//     }
    
//     task.resume()
// }

// How to call api
// struct User: Codable {
//     let name: String
//     let email: String
// }

// let url = URL(string: "https://example.com/api/users")!
// let payload = ["name": "John Doe", "email": "john.doe@example.com"]

// callAPI(url: url, payload: payload) { (result: Result<User, Error>) in
//     switch result {
//     case .success(let user):
//         print("User: \(user.name), Email: \(user.email)")
//     case .failure(let error):
//         print("Error: \(error)")
//     }
// }



// import Foundation

// class APIManager {
//     static let shared = APIManager()
    
//     private init() {}
    
//     func callAPI<T: Codable>(endpoint: String, method: String = "GET", payload: [String: Any]? = nil, headers: [String: String]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
//         guard let url = URL(string: endpoint) else {
//             completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
//             return
//         }
        
//         var request = URLRequest(url: url)
//         request.httpMethod = method
//         headers?.forEach { key, value in
//             request.setValue(value, forHTTPHeaderField: key)
//         }
        
//         if let payload = payload {
//             let jsonData = try? JSONSerialization.data(withJSONObject: payload)
//             request.httpBody = jsonData
//         }
        
//         let session = URLSession.shared
//         let task = session.dataTask(with: request) { (data, response, error) in
//             if let error = error {
//                 completion(.failure(error))
//                 return
//             }
            
//             guard let data = data else {
//                 completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
//                 return
//             }
            
//             let decoder = JSONDecoder()
//             do {
//                 let response = try decoder.decode(T.self, from: data)
//                 completion(.success(response))
//             } catch {
//                 completion(.failure(error))
//             }
//         }
        
//         task.resume()
//     }
// }




// struct User: Codable {
//     let name: String
//     let email: String
// }

// APIManager.shared.callAPI(endpoint: "https://example.com/api/users/1") { (result: Result<User, Error>) in
//     switch result {
//     case .success(let user):
//         print("User: \(user.name), Email: \(user.email)")
//     case .failure(let error):
//         print("Error: \(error)")
//     }
// }


import UIKit
import SwiftyJSON
import Alamofire

//Swifty json ServiceResponse
typealias ServiceResponse = (JSON, Error?) -> Void

//Check internet connection
var isReachable: Bool {
    return NetworkReachabilityManager()!.isReachable
}

//MARK: - WebService
public class WebService {
    //Variable Declaration
    static var call: WebService = WebService()
    
    //MARK: - WebService Call
    func withPath(_ url: String, parameter: [String:Any] = [String: Any](), isWithLoading: Bool = true, imageKey: [String] = ["image"], imageString: [String] = [String](), videoKey: [String] = ["video"], videoData: [Data] = [Data](), audioKey: [String] = ["audio"], audioData: [Data] = [Data](), isNeedToken: Bool = true, methods: HTTPMethod = .post , completionHandler:@escaping ServiceResponse) {
        
        print("URL :- \(url)")
        print("Parameter :- \(parameter)")
        
        if isReachable {
            
            if isWithLoading {
                //showLoading()
            }
            
            var headers = HTTPHeaders()
            if isNeedToken {
//                headers = [
//                WebURL.tokenKey : WebURL.tokenValue

//                 ]
            }
            
            let testUrl = url
            if imageString.count > 0 || videoData.count > 0 || audioData.count > 0 {
                
            
                
                Alamofire.upload (
                    multipartFormData: { multipartFormData in
                        
                        for (key, value) in parameter {
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                        }
                        
                        for i in 0..<imageString.count {
                            
                            let imgData = imageString[i].convertBase64ToData()
                            multipartFormData.append(imgData, withName: imageKey[i], fileName: "file.jpeg", mimeType: "image/jpeg")
                            
                        }
                        
                        for i in 0..<videoData.count {
                            multipartFormData.append(videoData[i], withName: videoKey[i], fileName: "file.mp4", mimeType: "video/mp4")
                        }
                        
                        for i in 0..<audioData.count {
                            multipartFormData.append(audioData[i], withName: audioKey[i], fileName: "file.m4a", mimeType: "audio/m4a")
                        }
                },
                    to: url,
                    headers : headers,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { result in
                                
                                print(result)
                                print(result.result)
                                
                                if let httpError = result.result.error {
                                    
                                    print(NSString(data: result.data!, encoding: String.Encoding.utf8.rawValue)!)
                                    print(httpError._code)
                                    
                                    let response: [String: Any] = [
                                        "errorCode": httpError._code,
                                        "status": false,
                                        "message": "eror"
                                    ]
                                    
                                    let json = JSON(response)
                                    completionHandler(json, nil)
                                }
                                
                                if  result.result.isSuccess {
                                    if let response = result.result.value {
                                        let json = JSON(response)
                                        completionHandler(json, nil)
                                    }
                                }
                                
                                if isWithLoading {
                                    //self.hideLoading()
                                }
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                        }
                })
            }
            else
            {
                
                Alamofire.request(testUrl, method: methods ,parameters: parameter,headers: headers)
                    .responseJSON {  result in

                        print(result)
                        print(result.result)

                        if let httpError = result.result.error {
                            print(NSString(data: result.data!, encoding: String.Encoding.utf8.rawValue)!)
                            print(httpError._code)

                            let response: [String: Any] = [
                                "errorCode": httpError._code,
                                "StatusCode": result.response?.statusCode as Any,
                                "status": false,
                                "message": "ValidationMessage.somthingWrong"
                            ]
                            let json = JSON(response)
                            completionHandler(json,httpError)
                        }

                        if  result.result.isSuccess {
                            if let response = result.result.value {
                                let json = JSON(response)
                                completionHandler(json, nil)
                            }
                        }

                        if isWithLoading {
                            //self.hideLoading()
                        }
                }
            }
        }
        else {
            // self.showTostMessage(message: "ValidationMessage.internetNotAvailable")
        }
    }
    
    //TODO: - Upload Image Api
    func uploadImageApi(finalURL:String, imageName: String, imageData: UIImage, parameters: [String : Any], completion:((NSDictionary,String) -> ())?){
        
        //Final URL
        let finalUrl = URL(string:finalURL)
        
        let headers = HTTPHeaders()//[
//            WebURL.tokenKey : WebURL.tokenValue
//        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(imageData.jpegData(compressionQuality: 0.1)!, withName: imageName, fileName: "image.jpg", mimeType: "image/jpeg")
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, usingThreshold: UInt64.init(), to: finalUrl!, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let JSON:NSDictionary = response.result.value as? NSDictionary {
                        
                        if completion != nil {
                            
                            completion!(JSON , "")
                        }
                    }
                    
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                
            }
        }
    }
    //Convert Base 64 To Image
    
}
extension String {
    func convertBase64ToData() -> Data {
        
        let imageData = Data(base64Encoded: self, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return imageData
    }
}

//Block for throw response
typealias WSBlock = (_ json: NSDictionary?, _ flag: Int) -> ()
//typealias NewBlock = (_ json: NSDictionary, _ flag: Int) -> ()
typealias WSProgress = (Progress) -> ()?
typealias WSFileBlock = (_ path: String?, _ success: Bool) -> ()

struct WebURL {
    
    //Google place API key
    static let key = "AIzaSyDpzwZsFOP_cLvNxYj-jZR6Rn74FgTLJOk"
    
    //baceURL
    static let baceURL: String = "http://192.249.121.94/~phpmobile/onway/api/v1/" //"http://192.249.121.94/~mobile/citycab/api/v1/"
    
    //tokenKey
    static let tokenKey: String = "apikey"
    
    //Image
    static let uploadURL: String = " http://192.249.121.94/~mobile/citycab/public/upload/"
    
    //tokenValue
    static let tokenValue: String = "oKRsI6LcIUjw242zsVTRn0hCSe7U3C"
    
    //Register
    static let Register: String = WebURL.baceURL + "register"
    
    //Login
    static let Login: String = WebURL.baceURL + "login"
    
    //User-Device
    static let userDevice: String = WebURL.baceURL + "user-device"
    
    //ForgotPassword
    static let forgotPassword: String = WebURL.baceURL + "forgot-password"
    
    //VerifyOTP
    static let verifyOTP: String = WebURL.baceURL + "verify-otp"

    //resendOtp
    static let resendOtp: String = WebURL.baceURL + "resend-otp"
    
    // update profile
    static let updateprofile: String = WebURL.baceURL + "update-profile"
    
    //find Drivers
    static let  finddrivers: String = WebURL.baceURL + "find_drivers"
    
    //book ride
    static let  bookride: String = WebURL.baceURL + "book-ride"
    
    //avilable-vehicle-ride
    static let  avilablevehicleride: String = WebURL.baceURL + "avilable-vehicle-ride"
    
    //reset-password
    static let  resetpassword: String = WebURL.baceURL + "reset-password"
    //Get Profile
    static let getProfile: String = WebURL.baceURL + "get-profile"
    
    //Logout
    static let logout: String = WebURL.baceURL + "logout"
    
    //cancel trip
    static let canceltrip: String = WebURL.baceURL + "cancel-trip"
    
    //Social Login
    static let socialLogin: String = WebURL.baceURL + "social-login"
    
    //Create Rating
    static let createRating: String = WebURL.baceURL + "create-rating"
    
    //history
    static let history: String = WebURL.baceURL + "history"
    
    //Check VErsion
    static let checkAppVersion: String = WebURL.baceURL + "check-version"

    //googlePlaceApi
    static let googlePlaceApi = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    //googleDirectionApi
    static let googleDirectionApi = "https://maps.googleapis.com/maps/api/directions/json?"
    
}

