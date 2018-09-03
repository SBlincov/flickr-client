//
//  SortedByDateViewController.swift
//  flickr-client
//
//  Created by Blintsov Sergey on 03/09/2018.
//  Copyright © 2018 Sergey Blintsov. All rights reserved.
//

import UIKit

class SortedByDateViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @objc override func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        ViewController.pushedPhoto = tappedImage
        performSegue(withIdentifier: "FullScreenPhoto", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return publicFeedDictionary.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        var indArr1 = sortByDate(dateOfFetchedPhoto, urlOfFetchedPhoto)
        //print(titleOfFetchedPhoto)
        cell.myImage.downloaded(from: urlOfFetchedPhoto[indArr1[indexPath.item]])
        
        cell.title.text = titleOfFetchedPhoto[indArr1[indexPath.item]]
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        
        cell.myImage.layer.borderWidth = 1.0
        cell.myImage.layer.borderColor = UIColor.gray.cgColor
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.myImage.isUserInteractionEnabled = true
        cell.myImage.addGestureRecognizer(tapGestureRecognizer)
        
        
        if tagOfFetchedPhoto[indexPath.item] != "" {
            cell.tagPhoto.text = tagOfFetchedPhoto[indArr1[indexPath.item]]
        } else {
            cell.tagPhoto.text = "No tags"
        }
        
        cell.datePhoto.text = dateOfFetchedPhoto[indArr1[indexPath.item]]
        
        return cell
    }
}
