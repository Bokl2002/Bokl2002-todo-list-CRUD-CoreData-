//
//  todoTableViewCell.swift
//  todo list project
//
//  Created by Abdullah Elbokl on 04/08/2022.
//

import UIKit

class todoTableViewCell: UITableViewCell {

    // outlets
    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var todoNamelabelView: UILabel!
    @IBOutlet weak var todoDateLabelView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
