//
//  YoutubeTableViewController.swift
//  Swift Practice # 98 Maroon5 YT Test
//
//  Created by Dogpa's MBAir M1 on 2021/10/21.
//

import UIKit

class YoutubeTableViewController: UITableViewController {

    @IBOutlet weak var bannerImageView: UIImageView!    //封面照
    @IBOutlet weak var profileImageView: UIImageView!   //大頭照
    @IBOutlet weak var channelTitleLabel: UILabel!      //頻道名稱
    @IBOutlet weak var channelIntrTextView: UITextView! //頻道介紹
    @IBOutlet weak var subscriberLabel: UILabel!        //頻道訂閱人數
    
    var maroon5YTVideoData = [YTVideoJSON.Items]()      //maroon5YTVideoData為取得影片Array
    var maroon5FrontPageData : YtFrontPageJSON?         //自定義maroon5FrontPageData為頻道資訊
    
    //取得影片資訊的Function
    func getMaroon5YTData () {
        let urlFromYTAPI = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet,contentDetails,status&playlistId=UUBVjMGOIkavEAhyqpxJ73Dw&key=&maxResults=50"
        //檢查網址網址是否有中文透過if let 指派 urlString 取得剛剛取得的urlFromYTAPI轉碼網址
        if let urlString = urlFromYTAPI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            if let JSONUrl = URL(string: urlString){
                
                URLSession.shared.dataTask(with: JSONUrl) { data, response, error in
                    //指派data為DATA類別
                    if let date = data {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        do {
                            let yTsearchResponse = try decoder.decode(YTVideoJSON.self , from: date)
                            self.maroon5YTVideoData = yTsearchResponse.items
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            print("影片成功")
                        }catch{
                            //若無法do或是失敗列印失敗原因
                            print(error)
                            print("影片失敗")
                        }
                    }
                }.resume()
            }
        }
    }

    //取得影片資訊的API Function
    func getMaroon5YTFrontPageData () {
        let urlFrontPageFromYTAPI = "https://www.googleapis.com/youtube/v3/channels?part=brandingSettings,snippet,contentDetails,statistics,status&id=UCBVjMGOIkavEAhyqpxJ73Dw&key="
        if let urlString = urlFrontPageFromYTAPI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let JSONUrl = URL(string: urlString){
                URLSession.shared.dataTask(with: JSONUrl) { data, response, error in
                    if let date = data {
                        
                        
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        do {
                            
                            //嘗試取得資料後將header內的資料透過 self.maroon5FrontPageData來協助顯示
                            let ytFrontPagesearchResponse = try decoder.decode(YtFrontPageJSON.self , from: date)
                            self.maroon5FrontPageData = ytFrontPagesearchResponse
                            DispatchQueue.main.async {
                                URLSession.shared.dataTask(with: (self.maroon5FrontPageData?.items[0].brandingSettings.image.bannerExternalUrl)!) {data, reponse, error in
                                    if let bannerData = data {
                                        DispatchQueue.main.async {
                                            self.bannerImageView.image = UIImage(data: bannerData)
                                        }
                                    }
                                }.resume()
                                URLSession.shared.dataTask(with: (self.maroon5FrontPageData?.items[0].snippet.thumbnails.high.url)!) {data, reponse, error in
                                    if let profileData = data {
                                        DispatchQueue.main.async {
                                            self.profileImageView.image = UIImage(data: profileData)
                                        }
                                    }
                                }.resume()
                                self.channelTitleLabel.text = self.maroon5FrontPageData?.items[0].snippet.title
                                
                                
                                self.channelIntrTextView.text = self.maroon5FrontPageData!.items[0].snippet.description
                                
                                let formatter = NumberFormatter()
                                formatter.numberStyle = .decimal
                                formatter.maximumFractionDigits = 0
                                if let intString = Int(self.maroon5FrontPageData!.items[0].statistics.subscriberCount) {
                                    let stringInt = formatter.string(from: NSNumber(value: intString))
                                    self.subscriberLabel.text = "subscriber : \(stringInt!)"
                                }
                            }
                            print("成功")
                        }catch{
                            //若無法do或是失敗列印失敗原因
                            print(error)
                            print("失敗")
                        }
                    }
                }.resume()
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //執行兩個API Function
        getMaroon5YTFrontPageData ()
        getMaroon5YTData ()
        
        //將大頭貼變成全圓形
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        

    }

    
    // MARK: - Table view data source
    
    //回傳一個section
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //row顯示maroon5YTVideoData的總數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return maroon5YTVideoData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //guard let協助完成取得YoutubeTableViewCell後指派給cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "YoutubeTableViewCell", for: indexPath) as? YoutubeTableViewCell else {return UITableViewCell()}
        
        //顯示影片標題
        cell.videoTitleLabel.text = maroon5YTVideoData[indexPath.row].snippet.title
        
        //取得縮圖
        URLSession.shared.dataTask(with: maroon5YTVideoData[indexPath.row].snippet.thumbnails.high.url) {data, response, error in
            if let photo = data {
                DispatchQueue.main.async {
                    cell.videoImageView.image = UIImage(data: photo)
                }
            }
        }.resume()
        
        //日期指派格式後顯示在publishDateLabel上
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        cell.publishDateLabel.text = dateFormatter.string(from: maroon5YTVideoData[indexPath.row].snippet.publishedAt)

        return cell
    }
    
    
    //點選cell透過"showVideo"跳至下一頁
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showVideo", sender: nil)
    }
    
    //傳送資料給下一頁使用先確定路徑是否為showVideo後協助將資料傳送過去
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVideo" {
            if let webVC = segue.destination as? YTWebViewController {
                let selectRow = self.tableView.indexPathForSelectedRow
                if let passIndex = selectRow?.row {
                    webVC.index = passIndex
                    webVC.YTDataFromPrePage = maroon5YTVideoData
                }
                
            }
        }
    }
}
