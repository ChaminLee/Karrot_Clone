//
//  Data.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/21.
//

import Foundation

//struct UserData {
//
//    var prodData: [ProdData]
//
//    init(dictionary: [String:[String:Any]]) {
//        self.userID = dictionary["userID"] as? String ?? ""
//        self.userIcon = dictionary["userIcon"] as? String ?? ""
//        self.prodData = dictionary["prodData"] as? [ProdData] ?? []
//    }
//}

struct ProdData {
    var prodImage: String
    var prodTitle: String
    var location: String
    var uploadTime: Int
    var price: String
    
    var visitNum: Int
    var heartNum: Int
    var chatNum: Int
    var replyNum: Int
    
    var nego: Bool
    var mannerDegree: Float
    var category: String
    var prodDescription: String
    var userID: String
    var userIcon: String
    
    init(dictionary: [String : Any]) {
        self.prodImage = dictionary["prodImage"] as? String ?? ""
        self.prodTitle = dictionary["prodTitle"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.uploadTime = dictionary["uploadTime"] as? Int ?? 0
        self.price = dictionary["price"] as? String ?? ""
        self.visitNum = dictionary["visitNum"] as? Int ?? 0
        self.heartNum = dictionary["heartNum"] as? Int ?? 0
        self.chatNum = dictionary["chatNum"] as? Int ?? 0
        self.replyNum = dictionary["replyNum"] as? Int ?? 0
        self.nego = dictionary["nego"] as? Bool ?? false
        self.mannerDegree = dictionary["mannerDegree"] as? Float ?? 0
        self.category = dictionary["category"] as? String ?? ""
        self.prodDescription = dictionary["prodDescription"] as? String ?? ""
        self.userID = dictionary["userID"] as? String ?? ""
        self.userIcon = dictionary["userIcon"] as? String ?? ""
    }
}
