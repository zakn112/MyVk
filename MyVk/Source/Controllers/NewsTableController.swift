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
    
    private let vkAPI = VKAPIProtocolProxy(vkAPI: VKAPI())
    
    func viewNextNews() {
        DispatchQueue.global().async {
            
            self.reloadData = true
            self.vkAPI.getNewsList(completion: { [weak self] (news, next_from) in
                DispatchQueue.main.async {
                    
                    guard let self = self else { return }
                    self.refreshControl?.endRefreshing()
                    let indexPaths = (self.news.count..<self.news.count + news.count).map{IndexPath(row: $0, section: 0)}
                    self.news += news
                    self.next_from = next_from
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                    self.reloadData = false
                    
                }
                }, start_from: self.next_from)
            
        }
    }
  
    fileprivate func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl?.tintColor = .blue
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    
    @objc func refreshNews() {
        self.refreshControl?.beginRefreshing()
        next_from = ""
        viewNextNews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       tableView.prefetchDataSource = self

        
        setupRefreshControl()
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
        cell.parentTable = self.tableView
        cell.newsVK = news[indexPath.row]
        cell.autorName.text = news[indexPath.row].autorName
        cell.nameNews.text = news[indexPath.row].name
        
        
        if let urlString = news[indexPath.row].photo_604 {
//            let url = URL(string: urlString)
//            cell.photoNews.kf.setImage(with: url)
            ImageServise.shared.getImage(imageView: cell.photoNews, url: urlString)
            
        }
       
        cell.likeView.likeNumber = news[indexPath.row].likesNumber
        cell.viewNunber.text = "Комментариев:\(news[indexPath.row].commentsNumber)"
        
        cell.setNewsLabelSize()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
               
        // Вычисляем высоту
        guard let aspectRatio = news[indexPath.row].aspectRatio else {
            return UITableView.automaticDimension
        }
        
        if let cellHeight = news[indexPath.row].cellHeightIsSowMore {
            return cellHeight
        }
        
        let tableWidth = tableView.bounds.width
        let cellHeight = tableWidth * aspectRatio + 130
        
        return cellHeight
        
    }
    
// Бесконечный скролинг можно реализовать так, можно через prefetchDataSource
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let contentHeight = scrollView.contentSize.height
//        let scrolY = scrollView.contentOffset.y
//
//        if !reloadData && scrolY > 0 && scrolY/contentHeight > 0.6 {
//          viewNextNews()
//        }
//    }
    
  
    
}

extension NewsTableController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxRow = indexPaths.map({ $0.row }).max() else { return }

        if maxRow > news.count - 3 {
          viewNextNews()
        }
    }
}
