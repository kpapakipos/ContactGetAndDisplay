//
//  ContactCell.swift
//  ContactGetAndDisplay
//
//  Created by Keegan Papakipos on 11/18/20.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
