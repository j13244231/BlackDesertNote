//
//  AlchemyTableViewController.swift
//  GameNote
//
//  Created by 劉進泰 on 2017/7/28.
//  Copyright © 2017年 劉進泰. All rights reserved.
//

import UIKit

class AlchemyTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet var alchemyTableView: UITableView!
    private var searchController:UISearchController!
    
    private var allAlchemies:[Alchemy] = [Alchemy]()
    private var filteredAlchemies:[Alchemy] = [Alchemy]()
    private var shouldShowSearchResult:Bool = false
    private var isPrepareToNextPage:Bool = false
    private var selectIndex:Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        shouldShowSearchResult = false
        isPrepareToNextPage = false
        
        alchemyTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "煉金"

        configureSearchController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setAlchemies(alchemies:[Alchemy]) {
        allAlchemies = alchemies
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResult {
            return filteredAlchemies.count
        }else {
            return allAlchemies.count
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AlchemyTableViewCell", for: indexPath) as? AlchemyTableViewCell {
            
            if shouldShowSearchResult {
                
                cell.setCell(alchemy: filteredAlchemies[indexPath.row])
            }else {
                cell.setCell(alchemy: allAlchemies[indexPath.row])
            }
            
            return cell
        }else {
            print("觸發 AlchemyTableViewCell() (at AlchemyTableViewController.swift)")
            return AlchemyTableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.isActive = false
        
        selectIndex = indexPath.row
        self.performSegue(withIdentifier: "showAlchemyDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let alchemyDetailViewController:AlchemyDetailViewController = segue.destination as! AlchemyDetailViewController
        
        if shouldShowSearchResult {
            alchemyDetailViewController.setAlchemyData(alchemy: filteredAlchemies[selectIndex])
        }else {
            alchemyDetailViewController.setAlchemyData(alchemy: allAlchemies[selectIndex])
        }
    }
    
    //MARK: Private Method
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.placeholder = "製品名稱"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        alchemyTableView.tableHeaderView = searchController.searchBar
    }
    
    //MARK: Search Bar Delegate
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResult = true
        alchemyTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResult = false
        alchemyTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResult {
            shouldShowSearchResult = true
            alchemyTableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        if searchString != "" {
            filteredAlchemies = allAlchemies.filter({ (alchemy) -> Bool in
                let nameText:String = alchemy.name
                return (nameText.range(of: searchString) != nil)
            })
        }
        
        if searchString == "" {
            if !isPrepareToNextPage {
                shouldShowSearchResult = false
                alchemyTableView.reloadData()
            }
        }
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectIndex = indexPath.row
//        self.performSegue(withIdentifier: "showAlchemyDetail", sender: self)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let dishDetailViewController:CookingDetailViewController = segue.destination as! CookingDetailViewController
//        dishDetailViewController.setDish(dish: allDishes[selectIndex])
//    }

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
