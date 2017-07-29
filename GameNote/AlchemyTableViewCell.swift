//
//  AlchemyTableViewCell.swift
//  GameNote
//
//  Created by 劉進泰 on 2017/7/28.
//  Copyright © 2017年 劉進泰. All rights reserved.
//

import UIKit

class AlchemyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(alchemy:Alchemy) {
        nameLabel.text = alchemy.name
        difficultyLabel.text = alchemy.difficulty
    }

}
