//
//  GroupsTableController.swift
//  MyVk
//
//  Created by kio on 29/09/2019.
//  Copyright © 2019 kio. All rights reserved.
//

import UIKit

class AllGroupsTableController: UITableViewController, UISearchBarDelegate{
    
    
    @IBOutlet weak var SearchBarAllGroups: UISearchBar!
    
    var groupeVKs = [GroupsVK]()
    private let vkAPI = VKAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchBarAllGroups.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupeVKs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allGroupeCell", for: indexPath) as! GroupTableViewCell
        cell.groupName.text = groupeVKs[indexPath.row].name
        cell.groupeAvatar.image = groupeVKs[indexPath.row].photo
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            return
        }
        
        vkAPI.getSearchGroupsList(searchString: searchText) //строку поиска в интерфейс добавил позже
        { [weak self] groups in
            self?.groupeVKs = groups
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
}
