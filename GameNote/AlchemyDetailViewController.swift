//
//  AlchemyDetailViewController.swift
//  GameNote
//
//  Created by 劉進泰 on 2017/7/29.
//  Copyright © 2017年 劉進泰. All rights reserved.
//

import UIKit

class AlchemyDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DoneMethodDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var materialTableView: UITableView!
    
    private var alchemy:Alchemy?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        materialTableView.dataSource = self
        materialTableView.delegate = self

        let doneAccessoryView:DoneAccessoryView = DoneAccessoryView(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 30.0))
        doneAccessoryView.backgroundColor = UIColor(red: 210.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        doneAccessoryView.doneDelegate = self
        
        amountTextField.delegate = self
        amountTextField.inputAccessoryView = doneAccessoryView
        
        setDetailData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setAlchemyData(alchemy:Alchemy) {
        self.alchemy = alchemy
    }
    
    // MARK: Private Method
    private func setDetailData() {
        nameLabel.text = alchemy!.name
        
        difficultyLabel.text = "製作需求最低等級：\(alchemy!.difficulty)"
    }
    
    // MARK: DoneMethodDelegate Method
    func doneButtonPressed() {
        amountTextField.resignFirstResponder()
    }
    
    // MARK: TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alchemy!.material.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? AlchemyDetailTableViewCell {
            let amount:Int = Int(amountTextField.text!)!
            
            cell.materialLabel.text = "\(alchemy!.material[indexPath.row]) x \(alchemy!.materialAmount[indexPath.row] * amount)"
            
            return cell
        }else {
            return AlchemyDetailTableViewCell()
        }
    }
    
    // MARK: TextField Delegate Method
    func textFieldDidEndEditing(_ textField: UITextField) {
        materialTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
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
