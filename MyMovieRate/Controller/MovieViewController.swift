//
//  MovieViewController.swift
//  MyMovieRate
//
//  Created by Lin Yi Sen on 2020/9/14.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit
import Foundation

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIImageView!
    
    
    
    var pullheaderView: UIView!
    let headerHeight: CGFloat = 450
    
    
    
    var timer: Timer?
    var moviesArray = [MoviesData]()
    var index = 0
    
    
    
   
    
    // 取得電影資訊(評分排序且評分數超過一萬的資料)
    func getMovieInfo() {
        
        // API URL string
        let urlStr = "https://api.themoviedb.org/3/discover/movie?api_key=fa36146a9c9339288ef9538e4bb1abb6&language=zh-TW&sort_by=vote_average.desc&certification_country=US&certification=R&include_adult=false&include_video=false&vote_count.gte=10000&with_original_language=en"
        
        // 嘗試將url字串轉換成URL
        if let url = URL(string: urlStr) {
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                if let data = data, let moviesData = try? decoder.decode(Film.self, from: data) {
                    self.moviesArray = moviesData.results
                    
                    DispatchQueue.main.async {
                        
                        if  self.moviesArray.count > 0 {
                            self.setMovieInfo(film:self.moviesArray[self.index])
                            self.time()
                        }
                        
                        self.tableView.reloadData()
//                        print(moviesData)
                    }
                }
            }.resume()
        }
    }
    
    
    
    
    
    
    //每三秒換一張電影海報
    func time(){
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true){
            (timer) in self.newImage()
        }
    }
    
    //換海報
    func newImage(){
        
        index = (index + 1) % moviesArray.count
        setMovieInfo(film: moviesArray[index])
    }
    
    
    
    //顯示電影海報
    func setMovieInfo(film:MoviesData){
        if let imageAddress = film.poster_path{
            if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/" + imageAddress){
                let task = URLSession.shared.downloadTask(with: imageURL) {
                    (data, response, error) in
                    
                    if error != nil{
                        DispatchQueue.main.async {
                            self.popAlert()
                        }
                        print(error!.localizedDescription)
                        return
                    }
                    if let getImageURL = data {
                        do{
                            let getImage = UIImage(data: try Data(contentsOf: getImageURL))
                            DispatchQueue.main.async {
                            self.headerView.image = getImage
                            
                           }
                        }catch{
                            DispatchQueue.main.async {
                            self.popAlert()
                            }
                            print(error.localizedDescription)
                            
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    
    //提示訊息
    func popAlert() {
        let alert = UIAlertController(title: "Something Wrong", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieTableCell", for: indexPath) as! MovieTableViewCell
        let movieList = moviesArray[indexPath.row]
        
        cell.titleLabel.text = movieList.title
        cell.releaseDateLabel.text = movieList.release_date
        
        if let vote = movieList.vote_average {
            cell.voteLabel.text = String(vote)
        }
        
        if let imageAddress = movieList.poster_path {
            if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/" + imageAddress) {
                let task = URLSession.shared.dataTask(with: imageURL) {
                    (data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.movieImageView.image = UIImage(data: data)
                        }
                    }
                }
                task.resume()
            }
        }
        return cell
    }
    
    
    func updateHeader() {
        print(tableView.contentOffset.y)
        if tableView.contentOffset.y < -headerHeight {
            pullheaderView.frame.origin.y = tableView.contentOffset.y
            pullheaderView.frame.size.height = -tableView.contentOffset.y

        } else {

        }
    }
    
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeader()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMovieInfo()
        
        
        
//        tableView.contentInset = UIEdgeInsets(top: imageOriginalHeight, left: 0, bottom: 0, right: 0)
        
        
        pullheaderView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(pullheaderView)
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
        updateHeader()
        pullheaderView.frame.origin.y = tableView.contentOffset.y
    }
    
    
    //關閉app畫面即停止timer，以防止在背景持續執行
    override func viewDidDisappear(_ animated: Bool) {
       timer?.invalidate()
    }

    

}
