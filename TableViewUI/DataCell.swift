//
//  DataCellTableViewCell.swift
//  Zinging
//
//  Created by Abu Nabe on 7/1/21.
//

import UIKit

class DataCell: UITableViewCell {

    @IBOutlet weak var VideoView: PlayerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
        // Configure the view for the selected state
    }

}
