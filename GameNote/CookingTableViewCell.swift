//
//  CookingTableViewCell.swift
//  GameNote
//
//  Created by 劉進泰 on 2017/6/26.
//  Copyright © 2017年 劉進泰. All rights reserved.
//

import UIKit

class CookingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(withDish dish:Dish) {
        dishNameLabel.text = dish.dishName
        difficultyLabel.text = dish.dishDifficulty
    }

}
