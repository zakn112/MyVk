//
//  FileStorage.swift
//  MyVk
//
//  Created by Андрей Закусов on 19.11.2019.
//  Copyright © 2019 Закусов Андрей. All rights reserved.
//

import Foundation


class FileStorage {
    static let shared = FileStorage()
    private init(){}
    
    func saveFile(webUrl: String, fileName: String, folder: String? = nil){
        let fm = FileManager.default
        var docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        if folder != nil {
            docsurl = docsurl.appendingPathComponent("\(folder!)/")
            try! fm.createDirectory(at: docsurl, withIntermediateDirectories: true, attributes: nil)
        }
        
        let url = URL(string: webUrl)
        if let data = try? Data(contentsOf: url!)
        {
            
            let urlLocal = docsurl.appendingPathComponent(fileName)
            try! data.write(to: urlLocal)
            
        }
    }
}
