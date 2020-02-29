//
//  GroupViewModelFactory.swift
//  MyVk
//
//  Created by Андрей Закусов on 29.02.2020.
//  Copyright © 2020 Закусов Андрей. All rights reserved.
//

import Foundation
import UIKit

class GroupViewModelFactory {
    func constructViewModels(from groups: [GroupVK]) -> [GroupVKViewModel] {
        return groups.compactMap(self.viewModel)
    }
    
    private func viewModel(from group: GroupVK) -> GroupVKViewModel {
       let groupVKViewModel = GroupVKViewModel()
       let fm = FileManager.default
        let docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let  avatarPath = "\(docsurl.path)/\(group.photo_50_str_local)"
        
        groupVKViewModel.name = group.name
        groupVKViewModel.groupeAvatar = UIImage(contentsOfFile: avatarPath) ?? UIImage()
        return groupVKViewModel
    }
}
