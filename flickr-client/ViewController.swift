//
//  ViewController.swift
//  flickr-client
//
//  Created by Blintsov Sergey on 30/08/2018.
//  Copyright © 2018 Blintsov Sergey. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var fullScreenImage: UIImageView!
    @IBOutlet weak var returnBackButton: UIButton!
    @IBOutlet weak var sortByDateButton: UIButton!
    @IBOutlet weak var sortByNameButton: UIButton!
    
    var publicFeedDictionary: [NSDictionary] = []
    var urlOfFetchedPhoto = Array(repeating: "", count: 20)
    var titleOfFetchedPhoto = Array(repeating: "", count: 20)
    var tagOfFetchedPhoto = Array(repeating: "", count: 20)
    var dateOfFetchedPhoto = Array(repeating: "", count: 20)
    
    var isPushedSortByName = false
    var isPushedSortByDate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextField()
        
        fullScreenImage.isHidden = true
        returnBackButton.isHidden = true
        
        getPublicFeed()
        while publicFeedDictionary == [] {
            continue
        }
        fetchPhotos(publicFeedDictionary)
        fetchTitles(publicFeedDictionary)
        fetchTags(publicFeedDictionary)
        fetchDate(publicFeedDictionary)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pushedSortByNameButton(_ sender: Any) {
        isPushedSortByName = true
        if(isPushedSortByDate == true) {
            isPushedSortByDate = false
        }
        collectionView?.reloadData()
    }
    
    @IBAction func pushedSortByDateButton(_ sender: Any) {
        isPushedSortByDate = true
        if(isPushedSortByName == true) {
            isPushedSortByName = false
        }
        collectionView?.reloadData()
    }
    
    func initializeTextField() {
        textField.delegate = self
        textField.keyboardType = UIKeyboardType.default
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField.text != nil {
            publicFeedDictionary = []
            getPublicFeed(textField.text!)
            while publicFeedDictionary == [] {
                continue
            }
            fetchPhotos(publicFeedDictionary)
            fetchTitles(publicFeedDictionary)
            fetchTags(publicFeedDictionary)
            fetchDate(publicFeedDictionary)
            collectionView?.reloadData()
            return true
        }
        return true
    }
    
    @IBAction func hideKeyboardWhenEditingEnd(_ sender: Any) {
        view.endEditing(true)
    }
    
    func sortByName(_ titleOfFetchedPhoto: [String]) -> [Int] {
        var sortedTitles: [String] = []
        sortedTitles = titleOfFetchedPhoto
        sortedTitles.sort{$0<$1}
        
        var isHave = Array(repeating: false, count: dateOfFetchedPhoto.count)
        var indArr = Array(repeating: 0, count: sortedTitles.count)
        
        for a in 0...titleOfFetchedPhoto.count-1 {
            for b in 0...sortedTitles.count-1 {
                if isHave[b] == true {
                    continue
                }
                if sortedTitles[a] == titleOfFetchedPhoto[b] {
                    indArr[a] = b
                    isHave[b] = true
                    break
                }
            }
        }
        return indArr
    }
    
    func sortByDate(_ dateOfFetchedPhoto: [String]) -> [Int] {
        var sortedDates: [String] = []
        sortedDates = dateOfFetchedPhoto
        sortedDates.sort{$0>$1}
        
        var isHave = Array(repeating: false, count: dateOfFetchedPhoto.count)
        var indArr = Array(repeating: 0, count: sortedDates.count)

        for a in 0...dateOfFetchedPhoto.count-1 {
            for b in 0...sortedDates.count-1 {
                if isHave[b] == true {
                    continue
                }
                if (sortedDates[a] == dateOfFetchedPhoto[b]) {
                    indArr[a] = b
                    isHave[b] = true
                    break
                }
            }
        }
        return indArr
    }
    
    @IBAction func pressedReturnBackButton(_ sender: Any) {
        collectionView.isHidden = false
        sortByDateButton.isHidden = false
        sortByNameButton.isHidden = false
        textField.isHidden = false
        
        fullScreenImage.isHidden = true
        returnBackButton.isHidden = true
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        fullScreenImage.image = tappedImage.image
        
        collectionView.isHidden = true
        sortByDateButton.isHidden = true
        sortByNameButton.isHidden = true
        textField.isHidden = true
        
        fullScreenImage.isHidden = false
        returnBackButton.isHidden = false
    }
    
    func fetchDate(_ publicFeedDictionary: [NSDictionary]) {
        for i in 0...publicFeedDictionary.count-1 {
            dateOfFetchedPhoto[i] = stringFromAny(publicFeedDictionary[i]["date_taken"])
            dateOfFetchedPhoto[i] = String(dateOfFetchedPhoto[i].dropLast(15))
        }
    }
    
    func fetchTags(_ publicFeedDictionary: [NSDictionary]) {
        for i in 0...publicFeedDictionary.count-1 {
            tagOfFetchedPhoto[i] = stringFromAny(publicFeedDictionary[i]["tags"])
        }
    }
    
    func fetchTitles(_ publicFeedDictionary: [NSDictionary]) {
        for i in 0...publicFeedDictionary.count-1 {
            titleOfFetchedPhoto[i] = stringFromAny(publicFeedDictionary[i]["title"])
        }
    }
    
    func fetchPhotos(_ publicFeedDictionary: [NSDictionary]) {
        for i in 0...publicFeedDictionary.count-1 {
            urlOfFetchedPhoto[i] = stringFromAny(publicFeedDictionary[i]["media"])
            urlOfFetchedPhoto[i] = String(urlOfFetchedPhoto[i].dropLast(4))
            urlOfFetchedPhoto[i] = String(urlOfFetchedPhoto[i].dropFirst(11))
        }
    }
    
    func getPublicFeed() {
        let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error when run request = \(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode not equal 200, statusCode is \(httpStatus.statusCode)")
                print("Response = \(String(describing: response))")
            }
            
            guard let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? NSDictionary,
                let items = dict["items"] as? [NSDictionary]
            else { return }
            
            self.publicFeedDictionary = items
        }
        
        task.resume()
    }
    
    func getPublicFeed(_ searchedTags: String) {
        var tag = searchedTags
        tag = tag.replaceWhitespaces()
        let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(tag)")!
        print(url)
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error when run request = \(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode not equal 200, statusCode is \(httpStatus.statusCode)")
                print("Response = \(String(describing: response))")
            }
            
            guard let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? NSDictionary,
                let items = dict["items"] as? [NSDictionary]
            else { return }
            
            self.publicFeedDictionary = items
        }
        
        task.resume()
    }
    
}

//Extension for downloading image via url
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0 {
            return true
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return publicFeedDictionary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        if isPushedSortByDate == true {
            var indArr = sortByDate(dateOfFetchedPhoto)
            
            cell.myImage.downloaded(from: urlOfFetchedPhoto[indArr[indexPath.item]])
            
            cell.title.text = titleOfFetchedPhoto[indArr[indexPath.item]]
            
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.gray.cgColor
            
            cell.myImage.layer.borderWidth = 1.0
            cell.myImage.layer.borderColor = UIColor.gray.cgColor
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            cell.myImage.isUserInteractionEnabled = true
            cell.myImage.addGestureRecognizer(tapGestureRecognizer)
            
            
            if tagOfFetchedPhoto[indexPath.item] != "" {
                cell.tagPhoto.text = tagOfFetchedPhoto[indArr[indexPath.item]]
            } else {
                cell.tagPhoto.text = "No tags"
            }
            
            cell.datePhoto.text = dateOfFetchedPhoto[indArr[indexPath.item]]
            isPushedSortByName = false
            return cell
        }
        
        if isPushedSortByName == true {
            var indArr = sortByName(titleOfFetchedPhoto)
            cell.myImage.downloaded(from: urlOfFetchedPhoto[indArr[indexPath.item]])
            
            cell.title.text = titleOfFetchedPhoto[indArr[indexPath.item]]
            
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.gray.cgColor
            
            cell.myImage.layer.borderWidth = 1.0
            cell.myImage.layer.borderColor = UIColor.gray.cgColor
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            cell.myImage.isUserInteractionEnabled = true
            cell.myImage.addGestureRecognizer(tapGestureRecognizer)
            
            
            if tagOfFetchedPhoto[indexPath.item] != "" {
                cell.tagPhoto.text = tagOfFetchedPhoto[indArr[indexPath.item]]
            } else {
                cell.tagPhoto.text = "No tags"
            }
            
            cell.datePhoto.text = dateOfFetchedPhoto[indArr[indexPath.item]]
            isPushedSortByDate = false
            return cell
        }
        
    
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        
        cell.myImage.downloaded(from: urlOfFetchedPhoto[indexPath.item])
        cell.myImage.layer.borderWidth = 1.0
        cell.myImage.layer.borderColor = UIColor.gray.cgColor
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.myImage.isUserInteractionEnabled = true
        cell.myImage.addGestureRecognizer(tapGestureRecognizer)
        
        cell.title.text = titleOfFetchedPhoto[indexPath.item]
        
        if tagOfFetchedPhoto[indexPath.item] != "" {
            cell.tagPhoto.text = tagOfFetchedPhoto[indexPath.item]
        } else {
            cell.tagPhoto.text = "No tags"
        }
        
        cell.datePhoto.text = dateOfFetchedPhoto[indexPath.item]
        
        return cell
    }
    
    // Convert Any type to String
    func stringFromAny(_ value:Any?) -> String {
        if let nonNil = value, !(nonNil is NSNull) {
            return String(describing: nonNil)
        }
        return ""
    }
}

extension String {
    func replaceWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined(separator: "%20")
    }
}
