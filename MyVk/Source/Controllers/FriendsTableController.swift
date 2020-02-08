//
//  FriendsTableController.swift
//  MyVk
//
//  Created by kio on 29/09/2019.
//  Copyright © 2019 kio. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsTableController: UITableViewController, UISearchBarDelegate {


    @IBOutlet weak var searchBarFriends: UISearchBar!
    @IBOutlet var tableViewFriends: UITableView!
    
    var friendsVK: Results<UserVK>?
    
    var tokenFriendsVK: NotificationToken?
    
    private let vkAPI = VKAPI()
    
    private var sections = [String: (Int, [UserVK?])]()
 
    private func createSections(searchText: String = "") -> () {
        if friendsVK == nil {
            return
        }
        sections = [:]
        var i:Int = 0
        for friend in friendsVK! {
            guard searchText == "" || friend.name.lowercased().contains(searchText.lowercased()) else {
                continue
            }
            
            if var section = sections[String(friend.name.first!)] {
                section.1.append(friend)
                sections[String(friend.name.first!)] = section
            }else{
                sections[String(friend.name.first!)] = (i, [friend])
               i += 1
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PromiseVK.shared.getFriendListJSON()
            .then(on: DispatchQueue.global()){ (data, response) in
            PromiseVK.shared.parseFriendList(data: data, response: response)
        }.then{ (users) in
            PromiseVK.shared.saveFriendListDataBase(users: users)
        }.done(on: DispatchQueue.main){ (usersBase) in
            self.friendsVK = usersBase
            self.createSections()
            self.tableViewFriends.reloadData()
        }.catch{(error) in
            print(error)
        }
    
        
//        DispatchQueue.global().async {
//            self.vkAPI.getFriendsList() { [weak self] users in
// Обновление перенесено в обработку оповещения об из менении
//            DispatchQueue.main.async {
//                self?.friendsVK = DBRealm.shared.getFriendsList()
//                self?.createSections()
//                self?.tableViewFriends.reloadData()
//            }
//        }
//        }
        
        tableViewFriends.delegate = self
        tableViewFriends.dataSource = self
        searchBarFriends.delegate = self
        
       
        friendsVK = DBRealm.shared.getFriendsList()
//        self.tokenFriendsVK = friendsVK?.observe{  (changes: RealmCollectionChange) in
//            self.createSections()
//            self.tableViewFriends.reloadData()
//
//        }

        createSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        
        for sect in self.sections{
            if sect.value.0 == section{
                rowCount = sect.value.1.count
            }
        }
        return  rowCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendTableViewCell
        
        let fm = FileManager.default
        let docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        for sect in self.sections{
            if sect.value.0 == indexPath.section {
                cell.userName.text = sect.value.1[indexPath.row]?.name
                
                let  avatarPath = "\(docsurl.path)/\(sect.value.1[indexPath.row]?.photo_50_str_local ?? "")"
                
                cell.userAvatar.image = UIImage(contentsOfFile: avatarPath)
            }
        }
        
        		
        return cell
    }

      
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? FotoCollectionController,
            let index = tableView.indexPathForSelectedRow
            else {
                return
        }
        
        for sect in self.sections{
            if sect.value.0 == index.section {
                 detailViewController.friend = sect.value.1[index.row]
            }
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "FriendPhotosCollection" {
                if let index = tableView.indexPathForSelectedRow {
                    for sect in self.sections{
                        if sect.value.0 == index.section {
                            if let friend = sect.value.1[index.row] {
                                let newsController = NewsController(friend: friend)
                                newsController.modalTransitionStyle = .crossDissolve
                                present(newsController, animated: false)
                            }
                        }
                    }
                }
                
                //временно отключаем переход на коллекчию, для реализации просмотра списка фото через AsyncDisplayKit
                return false
                
            }
        }
        
        return true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var nameSection = ""
        
        for sect in self.sections{
            if sect.value.0 == section{
                nameSection = sect.key
            }
        }
        
        return nameSection
    }
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        createSections(searchText: searchText)
        tableViewFriends.reloadData()
    }
    
    func reloadFriends(){
        createSections()
        DispatchQueue.main.async {
            self.tableViewFriends.reloadData()
        }
    }
    
    
}
