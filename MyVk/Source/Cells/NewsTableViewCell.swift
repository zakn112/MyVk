//
//  NewsTableViewCell.swift
//  MyVk
//
//  Created by kio on 05/10/2019.
//  Copyright © 2019 kio. All rights reserved.
//
import Foundation
import UIKit

class NewsTableViewCell: UITableViewCell {

    private var isShowMore = false
    var cellHeight: CGFloat?
    
    @IBOutlet weak var photoNews: UIImageView!
    
    @IBOutlet weak var viewNunber: UILabel!
    
    @IBOutlet weak var nameNews: UILabel!

    
    @IBOutlet weak var likeView: LikeView!
    
    @IBOutlet weak var autorName: UILabel!
    
    @IBOutlet weak var autorAvatar: AvatarView!
    
    @IBOutlet weak var NewsView: UIView!
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var newsNameLabelHeightConstrain: NSLayoutConstraint!
    
    override func prepareForReuse() {
        photoNews.image = nil
        photoNews.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 100)
        viewNunber.text = ""
        nameNews.text = ""
        autorName.text = ""
        autorAvatar.image = nil
        isShowMore = false
        newsNameLabelHeightConstrain.constant = 40
        
    }
    
    override func awakeFromNib() {
        NewsView.layer.masksToBounds = true
        NewsView.layer.borderColor = UIColor.gray.cgColor
        NewsView.layer.borderWidth = 1
        NewsView.layer.cornerRadius = 15
        newsNameLabelHeightConstrain.constant = 40
       
    }
    
    @IBAction func showMore(_ sender: Any) {
        
        if !isShowMore {
            let LabelSize = getLabelSize(text: nameNews.text!, font: nameNews.font)
            
            let margin = LabelSize.height - nameNews.frame.size.height
            
            self.cellHeight = self.frame.size.height + margin
            
            self.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
              
                self.showMoreButton.setTitle("show less", for: .normal)
                self.newsNameLabelHeightConstrain.constant += margin
                self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.size.width, height: self.cellHeight!))
                self.layoutIfNeeded()
            })
            
        } else{
            self.layoutIfNeeded()
            
            let margin = self.newsNameLabelHeightConstrain.constant - 40
            
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.showMoreButton.setTitle("show more", for: .normal)
                self.newsNameLabelHeightConstrain.constant = 40
                self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.size.width, height: self.frame.size.height - margin))
                self.layoutIfNeeded()
            })
        }
        
        isShowMore = !isShowMore
        
    }
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        // определяем максимальную ширину текста - это ширина ячейки минус отступы слева и справа
        let maxWidth = self.bounds.width
        // получаем размеры блока под надпись
        // используем максимальную ширину и максимально возможную высоту
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        // получаем прямоугольник под текст в этом блоке и уточняем шрифт
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        // получаем ширину блока, переводим ее в Double
        let width = Double(rect.size.width)
        // получаем высоту блока, переводим ее в Double
        let height = Double(rect.size.height)
        // получаем размер, при этом округляем значения до большего целого числа
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
}
