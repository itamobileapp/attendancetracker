//
//  Utils.swift
//  SwiftMobileApp
//
//  Created by Sankar Ramanathan on 8/29/21.
//

import Foundation
class Utils {
    
    static let serviceRootUrl = "SERVICE_ROOT_URL"
    static let userLogin = "userlogin"
    static let branchInfo = "branchinfo"
    static let gradeInfo = "gradeinfo"
    static let sectionInfo = "sectioninfo"
    static let studentInfo = "studentinfo"
    static let submitAttendance = "submitattendance"
    static let SUCCESSFULLY_UPDATED = #""1""#
    static let SUCCESSFULLY_SUBMITTED = #""1""#

    
    public static func getServiceUrl() -> String {
        var nsDictionary: NSDictionary?
         if let path = Bundle.main.path(forResource: "Collection", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
            for (key, value) in nsDictionary! {
                let k = Swift.String(describing: key)
                if (k == "SERVICE_ROOT_URL") {
                    let v = Swift.String(describing:value)
                    return v
               }
           }
        }
        return ""
    }
    
    
    public static func createHttpRequest(dict: Dictionary<String?, String?>?, trailingUrl: String, method: String) -> URLRequest {
        let completeUrl = getServiceUrl() + trailingUrl
        let url = URL(string:completeUrl)!
        var request = URLRequest(url:url, cachePolicy: .reloadIgnoringCacheData)
        request.httpMethod = method
        if (dict != nil) {
            for (key, value) in dict! {
                request.setValue(value, forHTTPHeaderField: key!)
               }
        }
        return request
    }
    
    
    public static func sendPostRequest(request: URLRequest, completion: @escaping (String, Error?) -> Void)  {
        var resp = ""
        
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) {data,response,error in
            if let error = error {
                resp = "Error while fetching data: \(Swift.String(describing: error))"
                print(resp)
                DispatchQueue.main.async() {
                    completion("-1", error)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                       (200...299).contains(httpResponse.statusCode) else {
                resp = "Error with the response, unexpected status code: \(Swift.String(describing: response))"
                print(resp)
                DispatchQueue.main.async() {
                    completion("-1", nil)
                }
                return
             }
            
              if let data = data {
                resp = Swift.String (data: data, encoding: .utf8)!
                resp = String(resp.filter { !" \n\t\r".contains($0) })
                DispatchQueue.main.async() {
                    completion(resp, nil)
                }
            }
        }
        task.resume()
    }
    
    public static func sendGetRequestSingle(request: URLRequest, completion: @escaping (Dictionary<String, String>, Error?) -> Void)  {
        var resp = ""
        
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) {data,response,error in
            if let error = error {
                resp = "Error while fetching data: \(Swift.String(describing: error))"
                print(resp)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                       (200...299).contains(httpResponse.statusCode) else {
                resp = "Error with the response, unexpected status code: \(Swift.String(describing: response))"
                print(resp)
                return
             }

            
              if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dict = json as? [String: String] {
                        //print(dict)
                        DispatchQueue.main.async() {
                            completion(dict, nil)
                        }
                    }
                }
                catch {
                    print ("Error")
                }
            }
        }
        task.resume()
    }
    
    public static func sendGetRequestMultiple(request: URLRequest, completion: @escaping (Dictionary<String, [String]>, Error?) -> Void)  {
        var resp = ""
        
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) {data,response,error in
            if let error = error {
                resp = "Error while fetching data: \(Swift.String(describing: error))"
                print(resp)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                       (200...299).contains(httpResponse.statusCode) else {
                resp = "Error with the response, unexpected status code: \(Swift.String(describing: response))"
                print(resp)
                return
             }

            
              if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dict = json as? [String: [String]] {
                        //print(dict)
                        DispatchQueue.main.async() {
                            completion(dict, nil)
                        }
                    }
                }
                catch {
                    print ("Error")
                }
            }
        }
        task.resume()
    }
    
    public static func getId(matchingName:String, arr: [String]) -> String {
        for name in arr {
            let components = name.components(separatedBy: ":")
            if (components[1] == matchingName) {
                return (components[0])
            }
        }
        return "-1"
    }
    


}
