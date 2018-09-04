//
//  ViewController.swift
//  flickr-client
//
//  Created by Blintsov Sergey on 30/08/2018.
//  Copyright © 2018 Blintsov Sergey. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    
    var isPushedSortByName = false
    var isPushedSortByDate = false
    
    static var pushedPhoto: UIImageView? = nil
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var fullScreenImage: UIImageView!
    @IBOutlet weak var returnBackButton: UIButton!
    @IBOutlet weak var sortByDateButton: UIButton!
    @IBOutlet weak var sortByNameButton: UIButton!
    
    @IBAction func pushedSortByNameButton(_ sender: Any) {
        isPushedSortByName = true
        if(isPushedSortByDate == true){
            isPushedSortByDate = false
        }
        collectionView?.reloadData()
    }
    
    @IBAction func pushedSortByDateButton(_ sender: Any) {
        isPushedSortByDate = true
        if(isPushedSortByName == true){
            isPushedSortByName = false
        }
        collectionView?.reloadData()
    }
    
    
    
    @IBAction func searchByTagButton(_ sender: Any) {
        publicFeedDictionary = []
        getPublicFeed(tag: "lol")
        while publicFeedDictionary == [] {
            continue
        }
        //print(publicFeedDictionary)
        fetchPhotos(publicFeedDictionary)
        fetchTitles(publicFeedDictionary)
        fetchTags(publicFeedDictionary)
        fetchDate(publicFeedDictionary)
        print(publicFeedDictionary)
        collectionView?.reloadData()
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        if textField.text != nil {
//            publicFeedDictionary = []
//            getPublicFeed(tag: textField.text!)
//            while publicFeedDictionary == [] {
//                continue
//            }
//            fetchPhotos(publicFeedDictionary)
//            fetchTitles(publicFeedDictionary)
//            fetchTags(publicFeedDictionary)
//            fetchDate(publicFeedDictionary)
//            collectionView?.reloadData()
//            return true
//        }
//        return true
//    }
    
    var publicFeedDictionary: [NSDictionary] = []
    var urlOfFetchedPhoto = Array(repeating: "", count: 20)
    var titleOfFetchedPhoto = Array(repeating: "", count: 20)
    var tagOfFetchedPhoto = Array(repeating: "", count: 20)
    var dateOfFetchedPhoto = Array(repeating: "", count: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullScreenImage.isHidden = true
        returnBackButton.isHidden = true
        
        initializeTextField()
        
        getPublicFeed()
        while publicFeedDictionary == [] {
            continue
        }
        fetchPhotos(publicFeedDictionary)
        fetchTitles(publicFeedDictionary)
        fetchTags(publicFeedDictionary)
        fetchDate(publicFeedDictionary)
        
    }
    
    func initializeTextField() {
        textField.delegate = self
        textField.keyboardType = UIKeyboardType.default
    }
    
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String)
        -> Bool {
        // We ignore any change that doesn't add characters to the text field.
        // These changes are things like character deletions and cuts, as well
        // as moving the insertion point.
        //
        // We still return true to allow the change to take place.
        if string.characters.count == 0 {
            return true
        }
        
        // Check to see if the text field's contents still fit the constraints
        // with the new content added to it.
        // If the contents still fit the constraints, allow the change
        // by returning true; otherwise disallow the change by returning false.
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return true
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
// END TEXTFIELD
    
    func sortByName(_ titleOfFetchedPhoto: [String]) -> [Int] {
        var sortedTitles: [String] = []
        sortedTitles = titleOfFetchedPhoto
        sortedTitles.sort{$0<$1}
        
        var isHave = Array(repeating: false, count: dateOfFetchedPhoto.count)
        var indArr = Array(repeating: 0, count: sortedTitles.count)
        
        for a in 0...titleOfFetchedPhoto.count-1{
            for b in 0...sortedTitles.count-1{
                if isHave[b] == true{
                    continue
                }
                if sortedTitles[a] == titleOfFetchedPhoto[b]{
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

        for a in 0...dateOfFetchedPhoto.count-1{
            for b in 0...sortedDates.count-1{
                if isHave[b] == true{
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
        ViewController.pushedPhoto = tappedImage
        //performSegue(withIdentifier: "FullScreenPhoto", sender: nil)
        fullScreenImage.image = ViewController.pushedPhoto?.image
        
        collectionView.isHidden = true
        sortByDateButton.isHidden = true
        sortByNameButton.isHidden = true
        textField.isHidden = true
        
        fullScreenImage.isHidden = false
        returnBackButton.isHidden = false
        
    }
    
    func fetchDate(_ publicFeedDictionary: [NSDictionary]) {
        for i in 0...publicFeedDictionary.count-1{
            dateOfFetchedPhoto[i] = stringFromAny(publicFeedDictionary[i]["date_taken"])
            dateOfFetchedPhoto[i] = String(dateOfFetchedPhoto[i].dropLast(15))
        }
    }
    
    func fetchTags(_ publicFeedDictionary: [NSDictionary]) {
        for i in 0...publicFeedDictionary.count-1{
            tagOfFetchedPhoto[i] = stringFromAny(publicFeedDictionary[i]["tags"])
        }
    }
    
    func fetchTitles(_ publicFeedDictionary: [NSDictionary]) {
        for i in 0...publicFeedDictionary.count-1{
            titleOfFetchedPhoto[i] = stringFromAny(publicFeedDictionary[i]["title"])
        }
    }
    
    func fetchPhotos(_ publicFeedDictionary: [NSDictionary]) {
        for i in 0...publicFeedDictionary.count-1{
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
    
    func getPublicFeed(tag: String) {
        let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(tag)")!
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
            //print(titleOfFetchedPhoto)
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
    
    func stringFromAny(_ value:Any?) -> String {
        if let nonNil = value, !(nonNil is NSNull) {
            return String(describing: nonNil)
        }
        return ""
    }
}
