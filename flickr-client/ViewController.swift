//
//  ViewController.swift
//  flickr-client
//
//  Created by Blintsov Sergey on 30/08/2018.
//  Copyright © 2018 Blintsov Sergey. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var publicFeedDictionary: [NSDictionary] = []
    var arrWithUrl = Array(repeating: "", count: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPublicFeed()
        while publicFeedDictionary == [] {
            continue
        }
        //print(fetchPhoto(publicFeedDictionary))
        fetchPhoto(publicFeedDictionary)
        print(arrWithUrl)
        
    }
    
    func stringFromAny(_ value:Any?) -> String {
        if let nonNil = value, !(nonNil is NSNull) {
            return String(describing: nonNil)
        }
        return ""
    }
    
    func fetchPhoto(_ publicFeedDictionary: [NSDictionary]) {
        for i in 0...19{
            arrWithUrl[i] = stringFromAny(publicFeedDictionary[i]["media"])
            arrWithUrl[i] = String(arrWithUrl[i].dropLast(4))
            arrWithUrl[i] = String(arrWithUrl[i].dropFirst(11))
        }
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

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension ViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return publicFeedDictionary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.myImage.downloaded(from: arrWithUrl[indexPath.item])
        return cell
    }
}

