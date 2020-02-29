//
//  GroupsAdapter.swift
//  MyVk
//
//  Created by Андрей Закусов on 29.02.2020.
//  Copyright © 2020 Закусов Андрей. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class GroupsAdapter{
    private let vkAPI = VKAPI()
    private var tokenGroupeVKs: NotificationToken?
    
    func getGroups(completion: @escaping ([GroupVK]) -> Void)
    {
        
        
       let groupeVKs = DBRealm.shared.getGroupsList()
        self.tokenGroupeVKs = groupeVKs?.observe{  (changes: RealmCollectionChange) in
            
            switch changes {
            case .initial(let groupsRealm):
                var groups: [GroupVK] = []
                  for groupRealm in groupsRealm {
                      groups.append(self.groupVK(from: groupRealm))
                  }
                completion(groups)
            case .update(let groupsRealm, _, _, _):
                var groups: [GroupVK] = []
                for groupRealm in groupsRealm {
                    groups.append(self.groupVK(from: groupRealm))
                }
              completion(groups)
            case .error(let error):
                print(error)
            }
            
            
        }
        
        DispatchQueue.global().async {
            self.vkAPI.getGroupsList() { grousRealm in return}
        }
    }
    
    public func groupVK(from GroupRealm: GroupRealm) -> GroupVK {
        let groupVK = GroupVK()
        groupVK.name = GroupRealm.name
        groupVK.id = GroupRealm.id
        groupVK.photo_50_str = GroupRealm.photo_50_str
        groupVK.photo_50_str_local = GroupRealm.photo_50_str_local
        
        return groupVK
    }
}
