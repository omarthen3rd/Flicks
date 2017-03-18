//
//  DetailTableViewController.swift
//  Flicks
//
//  Created by Omar Abbasi on 2016-12-17.
//  Copyright © 2016 Omar Abbasi. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage
import Spring

class CastCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var character: UILabel!
    @IBOutlet weak var actor: UILabel!
    
}

class DetailTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    var idPassed = 0
    var idToUse = 0
    var genres = [String]()
    
    var profileId = [Int]()
    var characterNames = [String]()
    var characterActors = [String]()
    var characterPosters = [NSURL]()
    
    var imageView = UIImageView()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var runtime: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var genre: UILabel!
    
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        // self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = true
        // self.navigationController?.isNavigationBarHidden = false

        self.castCollectionView.delegate = self
        self.castCollectionView.dataSource = self
        self.tableView.estimatedRowHeight = 400
        self.tableView.rowHeight = UITableViewAutomaticDimension
        idToUse = idPassed
        getDetail(idToUse)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // self.navigationController?.isNavigationBarHidden = false
        self.tableView.estimatedRowHeight = 400
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.backgroundView = imageView
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // self.navigationController?.isNavigationBarHidden = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getDetail(_ id: Int) {
        
        Alamofire.request("https://api.themoviedb.org/3/movie/\(id)?api_key=562d128051ad4ff39900582f6624ca25&language=en-US").responseJSON { (Response) in
            
            if let value = Response.result.value {
                
                let json = JSON(value)
                
                let movieBackdrop = NSURL(string:  "https://image.tmdb.org/t/p/w300" + json["backdrop_path"].stringValue)
                for genre in json["genres"].array! {
                    let genreName = genre["name"].stringValue
                    let genreId = genre["id"].intValue
                    self.genres.append(genreName)
                    let genresArrayToString = self.genres.joined(separator: ", ")
                    self.genre.text = genresArrayToString
                }
                let title = json["title"].stringValue
                let overview = json["overview"].stringValue
                let moviePoster = NSURL(string:  "https://image.tmdb.org/t/p/w300" + json["poster_path"].stringValue)
                let release = json["release_date"].stringValue
                let runtime = json["runtime"].intValue
                let vote = json["vote_average"].intValue
                self.nameLabel.text = title
                if (self.nameLabel.text?.characters.count)! < 20 {
                    self.nameLabel.font = UIFont.systemFont(ofSize: 32, weight: 400)
                }
                self.releaseDate.text = self.formattedDateFromString(dateString: release, withFormat: "MMM dd, yyyy")
                self.rating.text = "\(vote)"
                self.runtime.text = self.formatRuntime(runtime)
                self.overview.text = overview
                self.moviePoster.layer.cornerRadius = 10.0
                self.moviePoster.clipsToBounds = true
                self.moviePoster.sd_setImage(with: moviePoster as! URL, placeholderImage: #imageLiteral(resourceName: "empty"))
                self.imageView.sd_setImage(with: movieBackdrop as! URL, placeholderImage: #imageLiteral(resourceName: "empty"))
                self.imageView.addBlurEffect()
                self.tableView.setNeedsLayout()
                self.tableView.layoutIfNeeded()
                self.tableView.reloadData()
                // self.movieBackdrop.addBlurEffect()
                // self.movieBackdrop.sd_setImage(with: movieBackdrop as! URL, placeholderImage: #imageLiteral(resourceName: "empty"))
                
            }
        }
        
        Alamofire.request("https://api.themoviedb.org/3/movie/\(id)/credits?api_key=562d128051ad4ff39900582f6624ca25").responseJSON { (Response) in
            
            if let value = Response.result.value {
                
                let json = JSON(value)
                
                for result in json["cast"].array! {
                    
                    let profileId = result["id"].intValue
                    let character = result["character"].stringValue
                    let name = result["name"].stringValue
                    let profilePoster = NSURL(string: "https://image.tmdb.org/t/p/w300" + result["profile_path"].stringValue)
                    self.profileId.append(profileId)
                    self.characterNames.append(character)
                    self.characterActors.append(name)
                    self.characterPosters.append(profilePoster!)
                    
                }
                
                DispatchQueue.main.async {
                    self.castCollectionView.reloadData()
                }
                
            }
            
        }
        
    }

    func formatRuntime(_ minutesInput: Int) -> String {
        
        let hours = Int(minutesInput / 60)
        let minutes = Int(minutesInput % 60)
        
        return String("\(hours)" + " h " + "\(minutes)" + " mins")
        
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
    
    func configureView() {
        if let detail = self.detailItem {
            idPassed = detail
        }
    }
    
    var detailItem: Int? {
        didSet {
            self.configureView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    // MARK: - Collection view data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.characterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "castCell", for: indexPath) as! CastCollectionCell
        
        let objectActor = characterActors[indexPath.row]
        let objectCharcter = characterNames[indexPath.row]
        let objectPoster = characterPosters[indexPath.row]
        
        cell.actor.text = objectActor
        cell.character.text = objectCharcter
        cell.poster.sd_setImage(with: objectPoster as URL, placeholderImage: #imageLiteral(resourceName: "empty"))
        cell.poster.contentMode = .scaleAspectFill
        cell.poster.clipsToBounds = true
        cell.poster.layer.cornerRadius = 10.0
     
        return cell
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showCast" {
            if let cell = sender as? CastCollectionCell, let indexPth = castCollectionView.indexPath(for: cell) {
                let objectId = profileId[indexPth.row]
                let controller = segue.destination as! CastInfoTableViewController
                controller.detailItem = objectId
                print(objectId)
            }
        }
        
    }

}
