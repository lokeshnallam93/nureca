//
//  CountryTableViewCell.swift
//  IOS Assisgnment
//
//  Created by Lokesh on 29/08/21.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var country_label: UILabel!
    @IBOutlet weak var flag_imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
