//
//  Alchemy.swift
//  GameNote
//
//  Created by 劉進泰 on 2017/7/28.
//  Copyright © 2017年 劉進泰. All rights reserved.
//

import Foundation
import Firebase

class Alchemy:NSObject, NSCoding {
    private var _alchemyRef:DatabaseReference!
    
    //MARK: Types
    struct PropertyKey {
        static let key:String = "key"
        static let dictionary:String = "dictionary"
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory:URL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("alchemies")
    
    private var _key:String!
    private var _name:String!
    private var _difficulty:String!
    private var _material:[String]!
    private var _materialAmount:[Int]!
    private var _dictionary:Dictionary<String, AnyObject>!
    
    var key:String {
        return _key
    }
    
    var name:String {
        return _name
    }
    
    var difficulty:String {
        return _difficulty
    }
    
    var material:[String] {
        return _material
    }
    
    var materialAmount:[Int] {
        return _materialAmount
    }
    
    var dictionary:Dictionary<String, AnyObject> {
        return _dictionary
    }
    
    init(key:String, dictionary:Dictionary<String, AnyObject>) {
        self._key = key
        self._dictionary = dictionary
        
        if let name = dictionary["名稱"] as? String {
            self._name = name
        }
        
        if let difficulty = dictionary["難度"] as? String {
            self._difficulty = difficulty
        }
        
        if let material = dictionary["材料"] as? [String] {
            self._material = material
        }
        
        if let materialAmount = dictionary["材料數量"] as? [Int] {
            self._materialAmount = materialAmount
        }
        
        self._alchemyRef = Database.database().reference().child("煉金").child(key)
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(key, forKey: PropertyKey.key)
        aCoder.encode(dictionary, forKey: PropertyKey.dictionary)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let key = aDecoder.decodeObject(forKey: PropertyKey.key) as? String else {
            print("解碼 key 失敗！(at:Alchemy.swift)")
            return nil
        }
        
        guard let dictionary = aDecoder.decodeObject(forKey: PropertyKey.dictionary) as? Dictionary<String, AnyObject> else {
            print("解碼 dictionary 失敗！(at:Alchemy.swift)")
            return nil
        }
        
        self.init(key: key, dictionary: dictionary)
    }
}
