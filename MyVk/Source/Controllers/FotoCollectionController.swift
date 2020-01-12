//
//  FotoCollectionController.swift
//  MyVk
//
//  Created by kio on 29/09/2019.
//  Copyright © 2019 kio. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class FotoCollectionController: UICollectionViewController {
    
    var friend: UserVK?
    
    var photos: Results<PhotoVK>?
    var tokenPhotos: NotificationToken?
    
    var operation = OperationQueue()
    
    private let vkAPI = VKAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        
//        vkAPI.getPhotosFriend(friendID: friend!.id) { [weak self] photos in
//            DispatchQueue.main.async {
//                self?.photos = DBRealm.shared.getUserPhotos(user: self?.friend ?? UserVK())
//                self?.collectionView.reloadData()
//            }
//        }
        
        
        let getDataPhotoOperation = GetDataPhotoOperation(friendID: friend!.id)
        operation.addOperation(getDataPhotoOperation)

        let saveDataPhotoOperation = SaveDataPhotoOperation()
        saveDataPhotoOperation.addDependency(getDataPhotoOperation)
        OperationQueue.main.addOperation(saveDataPhotoOperation)
        
        let realm = try! Realm()
        
        self.photos = realm.objects(PhotoVK.self).filter("User == %@", self.friend ?? UserVK())
        
        self.tokenPhotos = photos?.observe { (changes: RealmCollectionChange) in
            
            switch changes {
            case .initial(let results):
                print(results)
                
            case let .update(results, deletions, insertions, modifications):
                print(results, deletions, insertions, modifications)
                
                if results.first?.User == self.friend {
                    self.photos = DBRealm.shared.getUserPhotos(user: self.friend ?? UserVK())
                    self.collectionView.reloadData()
                }
                
            case .error(let error):
                print(error)
            }

            
        }
    
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if photos == nil {
            return 0
        }
        else{
            return photos!.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
    
        let fm = FileManager.default
        let docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let  photoPath = "\(docsurl.path)/\(photos![indexPath.row].Path604Local)"
        
        // Configure the cell
        cell.photoView.image = UIImage(contentsOfFile: photoPath)
        cell.likeView.likeNumber = photos![indexPath.row].likeNumber
        cell.likeView.photo = photos![indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "onePhotoSegue", sender: nil)
    }
       
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "onePhotoSegue" {
        guard let destinationController = segue.destination as? onePhotoController, let index = collectionView.indexPathsForSelectedItems else { return }

        destinationController.friend = friend
       // destinationController.indexСurrentView = index.r
        
       }
   }
   
      
}
