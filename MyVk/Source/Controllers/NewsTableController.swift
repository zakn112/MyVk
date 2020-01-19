//
//  NewsTableController.swift
//  MyVk
//
//  Created by kio on 05/10/2019.
//  Copyright © 2019 kio. All rights reserved.
//

import UIKit
import Kingfisher

class NewsTableController: UITableViewController {
    
    var news = [NewsVK]()
    var next_from = ""
    var reloadData = false
    private let vkAPI = VKAPI()
    
    func viewNextNews() {
        DispatchQueue.global().async {
            
            self.reloadData = true
            self.vkAPI.getNewsList(completion: { [weak self] (news, next_from) in
                DispatchQueue.main.async {
                    self?.news += news
                    self?.next_from = next_from
                    self?.tableView.reloadData()
                    self?.reloadData = false
                }
                }, start_from: self.next_from)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewNextNews()
        
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
    }

    // MARK: - Table view data source

     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        
        DispatchQueue.global().async {
            if let url = URL(string: self.news[indexPath.row].autorAvatar ?? "") {
                if let data = try? Data(contentsOf: url)
                {
                    DispatchQueue.main.async {
                    cell.autorAvatar.image = UIImage(data: data)
                    }
                }
            }
        }
        
        cell.autorName.text = news[indexPath.row].autorName
        cell.nameNews.text = news[indexPath.row].name
        
        
        if let urlString = news[indexPath.row].photo_604 {
//            let url = URL(string: urlString)
//            cell.photoNews.kf.setImage(with: url)
            let _ = ImageCacheVK(imageView: cell.photoNews, url: urlString)
            
        }
        cell.likeView.likeNumber = news[indexPath.row].likesNumber
        cell.viewNunber.text = "Комментариев:\(news[indexPath.row].commentsNumber)"
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let scrolY = scrollView.contentOffset.y
        
        if !reloadData && scrolY > 0 && scrolY/contentHeight > 0.6 {
          viewNextNews()
        }
        
    }
    
}
