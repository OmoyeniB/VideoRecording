//
//  VideoTableViewCell.swift
//  VideoRecording
//
//  Created by Sharon Omoyeni Babatunde on 08/08/2023.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    static let identifier = "VideoTableViewCell"
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoTag: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var number: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    
}


