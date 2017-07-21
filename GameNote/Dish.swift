//
//  Dish.swift
//  GameNote
//
//  Created by 劉進泰 on 2017/6/26.
//  Copyright © 2017年 劉進泰. All rights reserved.
//

import Foundation
import Firebase

class Dish:NSObject, NSCoding {
    private var _dishRef:DatabaseReference!
    
    //MARK: Types
    struct PropertyKey {
        static let key:String = "key"
        static let dictionary:String = "dictionary"
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory:URL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("dishs")
    
    private var _dishKey:String!
    private var _dishName:String!
    private var _dishDifficulty:String!
    private var _dishMaterial:[String]!
    private var _materialAmount:[Int]!
    private var _dictionary:Dictionary<String, AnyObject>!
    
    var dishKey:String {
        return _dishKey
    }
    
    var dishName:String {
        return _dishName
    }
    
    var dishDifficulty:String {
        return _dishDifficulty
    }
    
    var dishMaterial:[String] {
        return _dishMaterial
    }
    
    var materialAmount:[Int] {
        return _materialAmount
    }
    
    var dictionary:Dictionary<String, AnyObject> {
        return _dictionary
    }
    
    init(key:String, dictionary:Dictionary<String, AnyObject>) {
        self._dishKey = key
        self._dictionary = dictionary
        
        if let dishName = dictionary["名稱"] as? String {
            self._dishName = dishName
        }
        
        if let dishDifficulty = dictionary["難度"] as? String {
            self._dishDifficulty = dishDifficulty
        }
        
        if let dishMaterial = dictionary["材料"] as? [String] {
            self._dishMaterial = dishMaterial
        }
        
        if let materialAmount = dictionary["材料數量"] as? [Int] {
            self._materialAmount = materialAmount
        }
        
        self._dishRef = Database.database().reference().child("料理").child(key)
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dishKey, forKey: PropertyKey.key)
        aCoder.encode(dictionary, forKey: PropertyKey.dictionary)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let key = aDecoder.decodeObject(forKey: PropertyKey.key) as? String else {
            print("解碼 key 失敗！")
            return nil
        }
        
        guard let dictionary = aDecoder.decodeObject(forKey: PropertyKey.dictionary) as? Dictionary<String, AnyObject> else {
            print("解碼 dictionary 失敗！")
            return nil
        }
        
        self.init(key: key, dictionary: dictionary)
    }
}
