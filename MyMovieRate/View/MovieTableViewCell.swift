//
//  MovieTableViewCell.swift
//  MyMovieRate
//
//  Created by Lin Yi Sen on 2020/9/14.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
