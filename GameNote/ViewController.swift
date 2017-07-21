//
//  ViewController.swift
//  GameNote
//
//  Created by 劉進泰 on 2017/5/24.
//  Copyright © 2017年 劉進泰. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var CookingPageButton: UIButton!
    @IBOutlet weak var AlchemyPageButton: UIButton!
    
    private var dishs:[Dish] = [Dish]()
    var reachability:Reachability? = Reachability.networkReachabilityForInternetConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    private func fetchData(nodeName:String) {
        Database.database().reference().child(nodeName).observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                // 先清空資料陣列，否則進入下一頁會重複顯示資料
                self.dishs = []
                
                for snap in snapshots {
                    if let valueDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key:String = snap.key
                        switch nodeName {
                            case "料理":
                                let dish:Dish = Dish(key: key, dictionary: valueDictionary)
                                self.dishs.append(dish)
                            case "煉金":
                                print("尚待製作")
                            default:
                                print("fetchData() 判斷有問題")
                        }
                        print("Fetch Data!!!")
                    }
                }
                switch nodeName {
                case "料理":
                    // 將下載好的資料存在手機端，供下次快取使用
                    self.saveDishs()
                    
                    // 執行特定 Segue
                    self.performSegue(withIdentifier: "showCookingPage", sender: self)
                case "煉金":
                    print("尚待製作")
                default:
                    print("fetchData() 判斷有問題")
                }
            }
        })
    }
    
    @IBAction func cookingPageButtonPressed(_ sender: UIButton) {
        print("讀取資料結束後前往料理頁面")
        loadDishs()
    }
    
    @IBAction func AlchemyPageButtonPressed(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCookingPage" {
            print("準備前往料理頁面")
            let cookingPageController:CookingTableViewController = segue.destination as! CookingTableViewController
            cookingPageController.setDish(dishes: dishs)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("料理").removeAllObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Private Method
    private func saveDishs() {
        let isDishSaveSuccessed:Bool = NSKeyedArchiver.archiveRootObject(dishs, toFile: Dish.ArchiveURL.path)
        
        if isDishSaveSuccessed {
            print("儲存 料理資料 成功！")
        }else {
            print("儲存 料理資料 失敗！")
        }
    }
    
    private func loadDishs() {
        // 如果讀取失敗，要在這裡開始重新抓取資料嗎？
        // 如果改成重新抓取資料，那這邊就不用回傳 Dish 陣列
        // 預計改成呼叫 fetchData()，事情做完儲存好就進入下一頁
        // 使用 if let 判斷 NSKeyedUnarchiver.unarchiveObject 成功與否，成功就在這邊跳轉到下一頁
        // 失敗就呼叫 fetchData()
        
        if let unarchiveDishs = NSKeyedUnarchiver.unarchiveObject(withFile: Dish.ArchiveURL.path) as? [Dish] {
            print("取得料理離線資料，前往下一頁")
            self.dishs = unarchiveDishs
            self.performSegue(withIdentifier: "showCookingPage", sender: self)
        }else {
            if (reachability?.isReachable)! {
                print("Firebase 連線中")
                // 為了安全獲得 Firebase 的資料，先幫使用者進行匿名註冊與登入
                Auth.auth().signInAnonymously { (user, error) in
                    if let error = error {
                        let loginErrorAlert:UIAlertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                        let okAction:UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        loginErrorAlert.addAction(okAction)
                        
                        self.present(loginErrorAlert, animated: true, completion: nil)
                        return
                    }
                    
                    self.fetchData(nodeName: "料理")
                }
            }else {
                print("網路狀態不良，顯示警告")
                let networkErrorAlert:UIAlertController = UIAlertController(title: "網路錯誤", message: "請檢查是否有連接網路，然後再試一次", preferredStyle: .alert)
                let okAction:UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                networkErrorAlert.addAction(okAction)
                
                self.present(networkErrorAlert, animated: true, completion: nil)
                return
            }
            
        }
        
//        return NSKeyedUnarchiver.unarchiveObject(withFile: Dish.ArchiveURL.path) as? [Dish]
    }
}

