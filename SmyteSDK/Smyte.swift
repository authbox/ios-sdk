//
//  Smyte.swift
//  Smyte
//

import Foundation

let rootURL = "https://api.smyte.com/v2"
let initURL = rootURL + "/mobile_ping"
let uniqueID = "com.smyte.unique.id"

public class Smyte : NSObject {
    public class func initialize(clientId : String, sessionId: String, deviceId: String?) {
        var dId = deviceId
        
        //no id passed in
        if dId == nil {
            //make one, and store in NSUserDefaults
            dId = UserDefaults.standard.string(forKey: uniqueID)
            
            if dId == nil {
                //make UDID and set it
                dId = UUID().uuidString
                UserDefaults.standard.set(dId, forKey: uniqueID)
                UserDefaults.standard.synchronize()
            }
        }
        
        let dict = ["session_id" : sessionId, "device_id" : dId!, "client_key" : clientId]
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let url = URL(string: initURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request) { (data, request, error) in
            if let d = data {
                let response = String(data: d, encoding: String.Encoding.utf8)
                print(response!)
            }
        }
        task.resume()
        
    }
    
    
}
