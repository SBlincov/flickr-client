//
//  SortedByNameViewController.swift
//  flickr-client
//
//  Created by Blintsov Sergey on 02/09/2018.
//  Copyright © 2018 Sergey Blintsov. All rights reserved.
//

import UIKit

class SortedByNameViewController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
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
            
            return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
