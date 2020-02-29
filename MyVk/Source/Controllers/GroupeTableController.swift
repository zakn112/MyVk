//
//  GroupeTableController.swift
//  MyVk
//
//  Created by kio on 29/09/2019.
//  Copyright © 2019 kio. All rights reserved.
//

import UIKit
import RealmSwift

class GroupeTableController: UITableViewController {
    
    private let groupService = GroupsAdapter()
    private let groupViewModelFactory = GroupViewModelFactory()
    
    var groupVKs = [GroupVK]()
    private var groupVKViewModels = [GroupVKViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupService.getGroups(){ [weak self] groupVKs in
            guard let self = self else { return }

            self.groupVKs = groupVKs
            self.groupVKViewModels = self.groupViewModelFactory.constructViewModels(from: groupVKs)
            self.tableView.reloadData()
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return groupVKViewModels.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupeCell", for: indexPath) as! GroupTableViewCell
        
        cell.groupName.text = groupVKViewModels[indexPath.row].name
        cell.groupeAvatar.image = groupVKViewModels[indexPath.row].groupeAvatar
        
        return cell
    }
    
    
    
    @IBAction func returnToGroups(unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "allGroupeCell" {
            guard let allGroupsTableController = unwindSegue.source as? AllGroupsTableController else { return }
            guard let indexPath = allGroupsTableController.tableView.indexPathForSelectedRow else { return }
            
            let groupe = allGroupsTableController.groupVKs[indexPath.row]
//            if !groupeVKs!.contains(where: { $0.name == groupe.name }) {
//                groupeVKs.append(allGroupsTableController.groupeVKs[indexPath.row])
//                tableView.insertRows(at: [IndexPath(row: groupeVKs!.count - 1, section: 0)], with: .fade)
//            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            groupeVKs.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
    }
    
    
}
