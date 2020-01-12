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
    
    var groupeVKs: Results<GroupsVK>?
    var tokenGroupeVKs: NotificationToken?
    
    private let vkAPI = VKAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {
            self.vkAPI.getGroupsList()
                { [weak self] groups in
                    //                DispatchQueue.main.async {
                    //                    self?.groupeVKs = DBRealm.shared.getGroupsList()
                    //                    self?.tableView.reloadData()
                    //                }
            }
        }
        
        self.groupeVKs = DBRealm.shared.getGroupsList()
        self.tokenGroupeVKs = groupeVKs?.observe{  (changes: RealmCollectionChange) in
            
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                           with: .automatic)
                self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                           with: .automatic)
                self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                           with: .automatic)
                self.tableView.endUpdates()
            case .error(let error):
                print(error)
            }
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groupeVKs == nil {
            return 0
        }
        else{
        return groupeVKs!.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupeCell", for: indexPath) as! GroupTableViewCell
        
        let fm = FileManager.default
        let docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let  avatarPath = "\(docsurl.path)/\(groupeVKs![indexPath.row].photo_50_str_local)"
        
        cell.groupName.text = groupeVKs![indexPath.row].name
        cell.groupeAvatar.image = UIImage(contentsOfFile: avatarPath)
        
        return cell
    }
    
    
    
    @IBAction func returnToGroups(unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "allGroupeCell" {
            guard let allGroupsTableController = unwindSegue.source as? AllGroupsTableController else { return }
            guard let indexPath = allGroupsTableController.tableView.indexPathForSelectedRow else { return }
            
            let groupe = allGroupsTableController.groupeVKs[indexPath.row]
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
