//
//  TableViewCell.swift
//  Yand
//
//  Created by Mac on 10.03.2021.
//

import UIKit

protocol FavoriteButton {
    func clickCell(sender: UIButton, symbol: String)
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var longNameLabel: UILabel!
    @IBOutlet weak var priceName: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var changeLabel: UILabel!
    
    var cellDelegate: FavoriteButton?
    var symbol = String()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func starTap(_ sender: Any) {
        cellDelegate?.clickCell(sender: likeButton, symbol: symbol)
    }
}
