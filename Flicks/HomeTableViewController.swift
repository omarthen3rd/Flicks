//
//  HomeTableViewController.swift
//  Flicks
//
//  Created by Omar Abbasi on 2016-12-17.
//  Copyright © 2016 Omar Abbasi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Spring

extension UIImageView {
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

class PopularCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var popPoster: UIImageView!
    @IBOutlet weak var popBackdrop: UIImageView!
    @IBOutlet weak var popName: UILabel!
    @IBOutlet weak var popDate: UILabel!
    @IBOutlet weak var popOverview: UILabel!
    
}

class UpcomingCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var latestPoster: UIImageView!
    @IBOutlet weak var latestTitle: UILabel!
    
}

class TopRatedCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var topPoster: UIImageView!
    @IBOutlet weak var topTitle: UILabel!
    
}

class HomeTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    var movieID = [Int]()
    var movieTitles = [String]()
    var movieReleaseDates = [String]()
    var movieOverviews = [String]()
    var moviePosters = [NSURL]()
    var movieBackdrops = [NSURL]()
    
    var upcomingMovieID = [Int]()
    var upcomingMovieTitles = [String]()
    var upcomingMoviePosters = [NSURL]()
    
    var topMovieID = [Int]()
    var topMovieTitles = [String]()
    var topMoviePosters = [NSURL]()
    
    var idToPass = 0
    
    var imageView = UIImageView()
    
    @IBOutlet var popularCollectionView: UICollectionView!
    @IBOutlet var upcomingCollectionView: UICollectionView!
    @IBOutlet var topCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .lightContent
        
        self.imageView.image = #imageLiteral(resourceName: "wall")
        self.imageView.addBlurEffect()
        self.tableView.backgroundView = imageView
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = true
        
        // self.navigationController?.isNavigationBarHidden = true
        
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self
        upcomingCollectionView.dataSource = self
        upcomingCollectionView.delegate = self
        
        getNowPlayingMovies("562d128051ad4ff39900582f6624ca25")
        getUpcomingMovies("562d128051ad4ff39900582f6624ca25")
        getTopRatedMovies("562d128051ad4ff39900582f6624ca25")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.backgroundColor = UIColor.clear
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    
    func getNowPlayingMovies(_ apiKey: String) {
        
        Alamofire.request("https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US&page=1").responseJSON { (Response) in
            
            if let value = Response.result.value {
                
                let json = JSON(value)
                
                for result in json["results"].array! {
                    
                    let id = result["id"].intValue
                    let movieName = result["title"].stringValue
                    let poster = result["poster_path"].stringValue
                    let backdrop = result["backdrop_path"].stringValue
                    let moviePoster = NSURL(string: "https://image.tmdb.org/t/p/w185" + poster)
                    let movieBackdrop = NSURL(string: "https://image.tmdb.org/t/p/w500" + backdrop)
                    let movieOverview = result["overview"].stringValue
                    let movieRelease = result["release_date"].stringValue
                    self.movieID.append(id)
                    self.movieTitles.append(movieName)
                    self.moviePosters.append(moviePoster!)
                    self.movieOverviews.append(movieOverview)
                    self.movieReleaseDates.append(movieRelease)
                    self.movieBackdrops.append(movieBackdrop!)
                    
                }
                
                DispatchQueue.main.async {
                    self.popularCollectionView.reloadData()
                }
            }
        }
        
    }

    func getUpcomingMovies(_ apiKey: String) {
        
        Alamofire.request("https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&language=en-US&page=1").responseJSON { (Response) in
            
            if let value = Response.result.value {
                
                let json = JSON(value)
                
                for result in json["results"].array! {
                    
                    let id = result["id"].intValue
                    let movieName = result["title"].stringValue
                    let poster = result["poster_path"].stringValue
                    let moviePoster = NSURL(string: "https://image.tmdb.org/t/p/w185" + poster)
                    self.upcomingMovieID.append(id)
                    self.upcomingMovieTitles.append(movieName)
                    self.upcomingMoviePosters.append(moviePoster!)

                }
                
                DispatchQueue.main.async {
                    self.upcomingCollectionView.reloadData()
                }
            }
        }
        
    }
    
    func getTopRatedMovies(_ apiKey: String) {
        
        Alamofire.request("https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)&language=en-US&page=1").responseJSON { (Response) in
            
            if let value = Response.result.value {
                
                let json = JSON(value)
                
                for result in json["results"].array! {
                    
                    let id = result["id"].intValue
                    let movieName = result["title"].stringValue
                    let poster = result["poster_path"].stringValue
                    let moviePoster = NSURL(string: "https://image.tmdb.org/t/p/w185" + poster)
                    self.topMovieID.append(id)
                    self.topMovieTitles.append(movieName)
                    self.topMoviePosters.append(moviePoster!)
                    
                }
                
                print("topMovieId: " + "\(self.topMovieID)")
                
                DispatchQueue.main.async {
                    self.topCollectionView.reloadData()
                }
            }
        }
        
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    // MARK: - Collection view data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == popularCollectionView {
            return self.movieTitles.count
        } else if collectionView == topCollectionView {
            return self.upcomingMovieTitles.count
        } else {
            return self.topMovieTitles.count
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == popularCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularCell", for: indexPath) as! PopularCollectionCell
            
            let objectTitles = movieTitles[indexPath.row]
            let objectDate = movieReleaseDates[indexPath.row]
            let objectOverview = movieOverviews[indexPath.row]
            let objectPoster = moviePosters[indexPath.row]
            
            cell.layer.cornerRadius = 10.0
            cell.popPoster.sd_setImage(with: objectPoster as URL, placeholderImage: #imageLiteral(resourceName: "empty"))
            cell.popBackdrop.sd_setImage(with: objectPoster as URL, placeholderImage: #imageLiteral(resourceName: "empty"))
            cell.popBackdrop.addBlurEffect()
            cell.popName.text = objectTitles
            cell.popDate.text = self.formattedDateFromString(dateString: objectDate, withFormat: "MMM dd, yyyy")
            cell.popOverview.text = objectOverview

            return cell
            
        } else if collectionView == upcomingCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestCell", for: indexPath) as! UpcomingCollectionCell
            
            let objectTitles = upcomingMovieTitles[indexPath.row]
            let objectPoster = upcomingMoviePosters[indexPath.row]
            
            cell.latestPoster.sd_setImage(with: objectPoster as URL, placeholderImage: #imageLiteral(resourceName: "empty"))
            cell.latestPoster.layer.cornerRadius = 5.0
            cell.latestPoster.clipsToBounds = true
            cell.latestTitle.text = objectTitles
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topCell", for: indexPath) as! TopRatedCollectionCell
            
            let objectTitles = topMovieTitles[indexPath.row]
            let objectPoster = topMoviePosters[indexPath.row]
            
            cell.topPoster.sd_setImage(with: objectPoster as URL, placeholderImage: #imageLiteral(resourceName: "empty"))
            cell.topPoster.layer.cornerRadius = 5.0
            cell.topPoster.clipsToBounds = true
            cell.topTitle.text = objectTitles
            
            return cell

        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showNowPlaying" {
            if let cell = sender as? PopularCollectionCell, let indexPath = popularCollectionView.indexPath(for: cell) {
                let objectId = movieID[indexPath.row]
                let controller = segue.destination as! DetailTableViewController
                controller.detailItem = objectId
            }
        }
        
        if segue.identifier == "showUpcoming" {
            if let cell = sender as? UpcomingCollectionCell, let indexPath = upcomingCollectionView.indexPath(for: cell) {
                let objectId = upcomingMovieID[indexPath.row]
                let controller = segue.destination as! DetailTableViewController
                controller.detailItem = objectId
            }
        }
        
        if segue.identifier == "showTopRated" {
            if let cell = sender as? TopRatedCollectionCell, let indexPath = topCollectionView.indexPath(for: cell) {
                let objectId = topMovieID[indexPath.row]
                let controller = segue.destination as! DetailTableViewController
                controller.detailItem = objectId
            }
        }
        
    }

}
