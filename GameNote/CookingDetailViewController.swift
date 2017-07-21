//
//  CookingDetailViewController.swift
//  GameNote
//
//  Created by 劉進泰 on 2017/7/1.
//  Copyright © 2017年 劉進泰. All rights reserved.
//

import UIKit

class CookingDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DoneMethodDelegate {
    
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishDifficultyLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dishMaterialTableView: UITableView!
    
    private var dish:Dish?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dishMaterialTableView.dataSource = self
        dishMaterialTableView.delegate = self
        
        amountTextField.delegate = self
        let doneAccessoryView:DoneAccessoryView = DoneAccessoryView(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 30.0))
        doneAccessoryView.backgroundColor = UIColor(colorLiteralRed: 210.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        doneAccessoryView.doneDelegate = self
        amountTextField.inputAccessoryView = doneAccessoryView

        setDetailData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setDetailData() {
        dishNameLabel.text = dish!.dishName
        
        dishDifficultyLabel.text = "製作需求最低等級：\(dish!.dishDifficulty)"
    }
    
    func setDish(dish:Dish) {
        self.dish = dish
    }
    
    // MARK: TabelView Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dish!.dishMaterial.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? DishDetailTableViewCell {
            let amount:Int = Int(amountTextField.text!)!
            
            cell.materialLabel.text = "\(dish!.dishMaterial[indexPath.row]) x \(dish!.materialAmount[indexPath.row] * amount)"
            
            return cell
        }else {
            return DishDetailTableViewCell()
        }
    }
    
    // MARK: TextField Delegate Method
    func textFieldDidEndEditing(_ textField: UITextField) {
        dishMaterialTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: DoneMethodDelegate Method
    func doneButtonPressed() {
        print("Hi")
        amountTextField.resignFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
