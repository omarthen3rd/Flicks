//
//  GenreDetailTableViewController.swift
//  Flicks
//
//  Created by Omar Abbasi on 2016-12-28.
//  Copyright © 2016 Omar Abbasi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class GenreDetailCell: UITableViewCell {
    
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var moviePoster: UIImageView!
    
}

class GenreDetailTableViewController: UITableViewController {

    var idPassed = 0
    var idToUse = 0
    
    var movieId = [Int]()
    var movieName = [String]()
    var moviePoster = [URL]()
    var movieRating = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
        idToUse = idPassed
        
        getGenreDetail(idToUse)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getGenreDetail(_ genreId: Int) {
        
        // highest rated
        Alamofire.request("https://api.themoviedb.org/3/discover/movie?api_key=562d128051ad4ff39900582f6624ca25&language=en_US&with_genres=\(genreId)&sort_by=vote_average.desc&vote_count.gte=10").responseJSON { (Response) in
            
            if let value = Response.result.value {
                
                let json = JSON(value)
                
                for result in json["results"].array! {
                    
                    let id = result["id"].intValue
                    let title = result["title"].stringValue
                    let poster = URL(string: "https://image.tmdb.org/t/p/w300" + result["poster_path"].stringValue)
                    let rating = result["vote_average"].doubleValue
                    self.movieId.append(id)
                    self.movieName.append(title)
                    self.moviePoster.append(poster!)
                    self.movieRating.append(rating)
                }
                
                print(self.movieName)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func configureView() {
        if let detail = detailItem {
            idPassed = detail
        }
    }
    
    var detailItem: Int? {
        didSet {
            self.configureView()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieName.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! GenreDetailCell

        let objectName = movieName[indexPath.row]
        let objectPoster = moviePoster[indexPath.row]
        let objectRating = movieRating[indexPath.row]
        
        // Configure the cell...
        
        cell.moviePoster.sd_setImage(with: objectPoster, placeholderImage: #imageLiteral(resourceName: "empty"))
        cell.movieTitle.text = objectName

        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
