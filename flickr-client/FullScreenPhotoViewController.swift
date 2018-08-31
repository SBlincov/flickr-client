//
//  FullScreenPhotoViewController.swift
//  flickr-client
//
//  Created by Blintsov Sergey on 01/09/2018.
//  Copyright © 2018 Sergey Blintsov. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: ViewController {
    @IBOutlet weak var fullScreenPhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        fullScreenPhoto.image = ViewController.pushedPhoto?.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


