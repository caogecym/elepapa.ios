//
//  DataManager.swift
//  Latest Papas
//
//  Created by Dani Arnaout on 9/2/14.
//  Edited by Yuming Cao on 11/27/14.
//  Copyright (c) 2014 Ray Wenderlich All rights reserved.
//

import Foundation

let ElepapaURL = "http://elepapa.com/latest.json"

class DataManager {
    
  class func getLatestPapaDataFromElepapaWithSuccess(success: ((papaData: NSData!) -> Void)) {
      loadDataFromURL(NSURL(string: ElepapaURL)!, completion:{(data, error) -> Void in
          if let urlData = data {
              success(papaData: urlData)
          }
      })
  }
  
  class func getPapaDetailFromElepapaWithSuccess(papaId: Int, success: ((papaData: NSData!) -> Void)) {
      let url  = "http://elepapa.com/t/\(papaId).json"
      loadDataFromURL(NSURL(string: url)!, completion:{(data, error) -> Void in
          if let urlData = data {
              success(papaData: urlData)
          }
      })
  }
    
  class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
    var session = NSURLSession.sharedSession()
    
    // Use NSURLSession to get data from an NSURL
    let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
      if let responseError = error {
        completion(data: nil, error: responseError)
      } else if let httpResponse = response as? NSHTTPURLResponse {
        if httpResponse.statusCode != 200 {
          var statusError = NSError(domain:"com.elepapa", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
          completion(data: nil, error: statusError)
        } else {
          completion(data: data, error: nil)
        }
      }
    })
    
    loadDataTask.resume()
  }
}