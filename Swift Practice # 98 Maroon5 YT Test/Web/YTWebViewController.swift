//
//  YTWebViewController.swift
//  Swift Practice # 98 Maroon5 YT Test
//
//  Created by Dogpa's MBAir M1 on 2021/10/21.
//

import UIKit
import WebKit

class YTWebViewController: UIViewController {

    @IBOutlet weak var ytWebKitView: WKWebView!     //webkitview顯示網頁
    var index: Int!                                 //前一頁select到的tableview的row的位置
    var YTDataFromPrePage = [YTVideoJSON.Items]()   //前一頁解析完成的API資料
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //透過YTDataFromPrePage內並指定參數index的值抓到影片id組合成網址
        //後續透過URLRequest指派並透過ytWebKitView顯示網頁
        let urlToWatch = "https://www.youtube.com/watch?v=\(YTDataFromPrePage[index].contentDetails.videoId)"
        if let url = URL(string: urlToWatch) {
            let request = URLRequest(url: url)
            ytWebKitView.load(request)
        }
        
    }

}
