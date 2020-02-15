//
//  FriendPhotosASTableController.swift
//  MyVk
//
//  Created by Андрей Закусов on 02.02.2020.
//  Copyright © 2020 Закусов Андрей. All rights reserved.
//

import Foundation
import RealmSwift
import AsyncDisplayKit

class NewsController: ASViewController<ASDisplayNode>, ASTableDelegate, ASTableDataSource {
  
    private var friend: UserVK?
    
    private var photos = [PhotoVK_]()
    
    private let vkAPI = VKAPI()
    
    // Создаем дополнительный интерфейс для обращения к корневой ноде
    var tableNode: ASTableNode {
        return node as! ASTableNode
    }
  
    init(friend: UserVK) {
       // Инициализируемся с таблицей в качестве корневого View / Node
       super.init(node: ASTableNode())
       // Привязываем к себе методы делегата и дата-сорса
       self.tableNode.delegate = self
       self.tableNode.dataSource = self
       // По желанию кастомизируем корневую таблицу
       self.tableNode.allowsSelection = false
        
       self.friend = friend
        
        
        
   }
  
   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        // Количество секций соответствует количеству загруженных новостей
        return photos.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let friend = friend {
            vkAPI.getPhotosFriend(friendID: friend.id) { [weak self] photos in
                DispatchQueue.main.async {
                   
                        self?.photos = photos
                        self?.tableNode.reloadData()
                    
                }
            }
            
            
//            if let photosVK = DBRealm.shared.getUserPhotos(user: friend) {
//                for photoVK in photosVK {
//                    photos.append(PhotoVK_(photoVK: photoVK))
//                }
//            }
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
  
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        guard photos.count > indexPath.section  else { return { ASCellNode() } }
        
        let source = photos[indexPath.section]
        switch indexPath.row {
        case 0:
            // Первая ячейка -- всегда заголовок. Возвращаем замыкание, создающее NewsHeaderNode
            let cellNodeBlock = { () -> ASCellNode in
                let node = PhotoTextNode(resource: source)
                return node
            }
            
            return cellNodeBlock
        case 1:
            // Первая ячейка -- всегда заголовок. Возвращаем замыкание, создающее NewsHeaderNode
            let cellNodeBlock = { () -> ASCellNode in
                let node = ImageNode(resource: source)
                return node
            }
            
            return cellNodeBlock
            
            
        default:
            return { ASCellNode() }
        }
    }

}

class ImageNode: ASCellNode {
   private let resource: PhotoVK_
   private let photoImageNode = ASNetworkImageNode()
  
   init(resource: PhotoVK_) {
       self.resource = resource
       // Аналогично предыдущей ячейке инициализируем ее через super-инициализатор
       super.init()
      // Донастраиваем внешний вид сабнод
       setupSubnodes()
   }
  
    private func setupSubnodes() {
        photoImageNode.url = URL(string: resource.Path604)
        photoImageNode.contentMode = .scaleAspectFill
        photoImageNode.shouldRenderProgressImages = true
        photoImageNode.borderColor = UIColor.gray.cgColor
        photoImageNode.borderWidth = 1
        photoImageNode.cornerRadius = 15
        addSubnode(photoImageNode)
    }
  
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let width = constrainedSize.max.width
        if resource.width == 0 {
            photoImageNode.style.preferredSize = CGSize(width: width, height: width)
        }else {
            photoImageNode.style.preferredSize = CGSize(width: width, height: width*resource.aspectRatio)
        }
        return ASWrapperLayoutSpec(layoutElement: photoImageNode)
    }
}

class PhotoTextNode: ASCellNode {
   //MARK: - Properties
   private let source: PhotoVK_
   private let dateNode = ASTextNode()
   private let textNode = ASTextNode()
    
   init(resource: PhotoVK_) {
         self.source = resource
         // Аналогично предыдущей ячейке инициализируем ее через super-инициализатор
         super.init()
        // Донастраиваем внешний вид сабнод
         setupSubnodes()
     }
      
    private func setupSubnodes() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        dateNode.attributedText = NSAttributedString(string: dateFormatter.string(from: source.date), attributes: [.font : UIFont.systemFont(ofSize: 20)])
        dateNode.backgroundColor = .clear
        addSubnode(dateNode)
        
        if source.text != "" {
            textNode.attributedText = NSAttributedString(string: source.text, attributes: [.font : UIFont.systemFont(ofSize: 20)])
            textNode.backgroundColor = .clear
            addSubnode(textNode)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
         // Центрировать текст поможет ASCenterLayoutSpec
         let dateNodeCenterSpec = ASCenterLayoutSpec(centeringOptions: .Y, sizingOptions: [], child: dateNode)
        
        let insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let textNodeCenterSpec = ASInsetLayoutSpec(insets: insets, child: textNode)
        
         // Корневой лейаут будет определять вертикальный стек
         let horizontalStackSpec = ASStackLayoutSpec()
         horizontalStackSpec.direction = .vertical
         // Его дочерними элементами будут спецификации, содержащие текст
         horizontalStackSpec.children = [dateNodeCenterSpec, textNodeCenterSpec]
         return horizontalStackSpec
     }
}

