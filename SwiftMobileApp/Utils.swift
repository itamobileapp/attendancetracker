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
    
    
    public static func createHttpPostRequest(dict: Dictionary<String?, String?>, trailingUrl: String) -> URLRequest {
        let completeUrl = getServiceUrl() + trailingUrl
        let url = URL(string:completeUrl)!
        var request = URLRequest(url:url, cachePolicy: .reloadIgnoringCacheData)
        request.httpMethod = "POST"
        //request.setValue("t", forHTTPHeaderField: "email")
        //request.setValue("t", forHTTPHeaderField: "password");

        for (key, value) in dict {
            request.setValue(value, forHTTPHeaderField: key!)
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
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                       (200...299).contains(httpResponse.statusCode) else {
                resp = "Error with the response, unexpected status code: \(Swift.String(describing: response))"
                print(resp)
                return
             }
            
            //if let mimetype = httpResponse.mimeType, mimetype == "application/json",
              if let data = data {
                resp = Swift.String (data: data, encoding: .utf8)!
                DispatchQueue.main.async() {
                                    completion(resp, nil)
                }
            }
        }
        task.resume()
    }
}
