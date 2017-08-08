//
//  CookingTableViewController.swift
//  GameNote
//
//  Created by 劉進泰 on 2017/6/26.
//  Copyright © 2017年 劉進泰. All rights reserved.
//

import UIKit

class CookingTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet var cookingTableView: UITableView!
    private var searchController:UISearchController!
    
    
    private var allDishes:[Dish] = [Dish]()
    private var filteredDishes:[Dish] = [Dish]()
    private var shouldShowSearchResult:Bool = false
    private var isPrepareToNextPage:Bool = false
    private var selectIndex:Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        shouldShowSearchResult = false
        isPrepareToNextPage = false
        
        cookingTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
    }
    
    func setDish(dishes:[Dish]) {
        allDishes = dishes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var dataCount:Int = 0
        
        if shouldShowSearchResult {
            dataCount = filteredDishes.count
        }else {
            dataCount = allDishes.count
        }
        
        return dataCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CookingTableViewCell", for: indexPath) as? CookingTableViewCell {
            
            if shouldShowSearchResult {
                cell.setCell(withDish: filteredDishes[indexPath.row])
            }else {
                cell.setCell(withDish: allDishes[indexPath.row])
            }
            
            return cell
        }else {
            print("觸發 return CookingTableViewCell()")
            return CookingTableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        self.performSegue(withIdentifier: "showDishDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dishDetailViewController:CookingDetailViewController = segue.destination as! CookingDetailViewController
        
        isPrepareToNextPage = true
        print("prepare SearchResult:\(shouldShowSearchResult)")
        if shouldShowSearchResult {
            dishDetailViewController.setDish(dish: filteredDishes[selectIndex])
        }else {
            dishDetailViewController.setDish(dish: allDishes[selectIndex])
        }
        
        searchController.isActive = false
    }
    
    //MARK: Search Controller Method
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false //指定再輸入搜尋列時要不要讓畫面暗下來以凸顯搜尋列
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.placeholder = "料理名稱"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        cookingTableView.tableHeaderView = searchController.searchBar
    }
    
    //MARK: Search Bar Delegate
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("BarTextDidEndEditing")
        shouldShowSearchResult = true
        cookingTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("CancelButtonClicked")
        shouldShowSearchResult = false
        cookingTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("BarSearchButtonClicked")
        
        if !shouldShowSearchResult {
            shouldShowSearchResult = true
            cookingTableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        if searchString != "" {
            filteredDishes = allDishes.filter({ (dish) -> Bool in
                let dishNameText:String = dish.dishName
                return ((dishNameText.range(of: searchString) != nil))
            })
        }
        
        // searchString 只要沒有輸入文字就是 "" ，這會導致搜尋結果為0，所以這邊改成顯示全部資料
        if searchString == "" {
            if !isPrepareToNextPage {
                shouldShowSearchResult = false
                cookingTableView.reloadData()
            }
        }
        
        print("filteredDishes:\(filteredDishes.count)")
        
        print("should:\(shouldShowSearchResult)")
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
