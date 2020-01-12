//
//  onePhotoController.swift
//  MyVk
//
//  Created by kio on 12.10.2019.
//  Copyright © 2019 kio. All rights reserved.
//

import UIKit

class onePhotoController: UIViewController {
    
    var friend: UserVK?
    var indexСurrentView = 1
    
    @IBOutlet weak var onePhotoView: OnePhotoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onePhotoView.friend = friend
        onePhotoView.indexСurrentView = indexСurrentView
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
