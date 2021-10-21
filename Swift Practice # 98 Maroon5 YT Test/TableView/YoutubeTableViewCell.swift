//
//  YoutubeTableViewCell.swift
//  Swift Practice # 98 Maroon5 YT Test
//
//  Created by Dogpa's MBAir M1 on 2021/10/21.
//

import UIKit

class YoutubeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var videoImageView: UIImageView! //影片縮圖
    @IBOutlet weak var videoTitleLabel: UILabel!    //影片標題
    @IBOutlet weak var publishDateLabel: UILabel!   //影片發布日
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
