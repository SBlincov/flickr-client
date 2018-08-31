//
//  ViewController.swift
//  flickr-client
//
//  Created by Blintsov Sergey on 30/08/2018.
//  Copyright © 2018 Blintsov Sergey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var publicFeedDictionary: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPublicFeed()
    }
    
    func getPublicFeed() {
        let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error when run request = \(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode not equal 200, statusCode is \(httpStatus.statusCode)")
                print("Response = \(response)")
            }
            
            guard let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? NSDictionary,
                let items = dict["items"] as? [NSDictionary]
                else { return }
            
            self.publicFeedDictionary = items
        }
        
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

