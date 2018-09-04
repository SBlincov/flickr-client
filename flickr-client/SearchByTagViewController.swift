//
//  SearchByTagViewController.swift
//  flickr-client
//
//  Created by Blintsov Sergey on 03/09/2018.
//  Copyright © 2018 Sergey Blintsov. All rights reserved.
//

import UIKit

class SearchByTagViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        
        getPublicFeed(tag: "lol")
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
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return publicFeedDictionary.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell

        cell.myImage.downloaded(from: urlOfFetchedPhoto[indexPath.item])
        
        cell.title.text = titleOfFetchedPhoto[indexPath.item]
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        
        cell.myImage.layer.borderWidth = 1.0
        cell.myImage.layer.borderColor = UIColor.gray.cgColor
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.myImage.isUserInteractionEnabled = true
        cell.myImage.addGestureRecognizer(tapGestureRecognizer)
        
        
        if ViewController.tagOfFetchedPhoto[indexPath.item] != "" {
            cell.tagPhoto.text = ViewController.tagOfFetchedPhoto[indexPath.item]
        } else {
            cell.tagPhoto.text = "No tags"
        }
        
        cell.datePhoto.text = dateOfFetchedPhoto[indexPath.item]
        
        return cell
    }

}
