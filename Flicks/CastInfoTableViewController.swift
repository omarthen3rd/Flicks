//
//  CastInfoTableViewController.swift
//  Flicks
//
//  Created by Omar Abbasi on 2016-12-20.
//  Copyright © 2016 Omar Abbasi. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

class InMovieCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var inMoviePoster: UIImageView!
    @IBOutlet weak var inMovieName: UILabel!
    @IBOutlet weak var inMovieChar: UILabel!
    
}

class InMovieTableCell: UITableViewCell {
    
    
    
}

class CastInfoTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var idPassed = 0
    var idToUse = 0
    
    var inMovieId = [Int]()
    var inMovieName = [String]()
    var inMovieChar = [String]()
    var inMovieRelease = [String]()
    var inMoviePoster = [URL]()
    
    var imageView = UIImageView()
    
    @IBOutlet var name: UILabel!
    @IBOutlet var poster: UIImageView!
    @IBOutlet var birth: UILabel!
    @IBOutlet var birthPlace: UILabel!
    @IBOutlet var overview: UILabel!
    
    @IBOutlet weak var inMovies: UICollectionView!
    @IBAction func moreInfo(_ sender: Any) {
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        idToUse = idPassed
        getDetail(idToUse)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.estimatedRowHeight = 400
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.backgroundView = imageView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func getDetail(_ id: Int) {
        
        Alamofire.request("https://api.themoviedb.org/3/person/\(id)?api_key=562d128051ad4ff39900582f6624ca25&language=en-US").responseJSON { (Response) in
            
            if let value = Response.result.value {
                
                let json = JSON(value)
                
                let name = json["name"].stringValue
                let birthday = self.formattedDateFromString(json["birthday"].stringValue, "MMM dd, yyyy")
                let bio = json["biography"].stringValue
                let birth = json["place_of_birth"].stringValue
                let posterURL = URL(string: "https://image.tmdb.org/t/p/w300" + json["profile_path"].stringValue)
                
                self.name.text = name
                self.poster.layer.cornerRadius = 10.0
                self.poster.clipsToBounds = true
                self.poster.sd_setImage(with: posterURL, placeholderImage: #imageLiteral(resourceName: "empty"))
                self.birth.text = "Born: " + birthday!
                self.overview.text = bio
                self.birthPlace.text = "Birth Place: " + birth
                self.imageView.sd_setImage(with: posterURL, placeholderImage: #imageLiteral(resourceName: "empty"))
                self.imageView.addBlurEffect()
                
            }
            
        }
        
        Alamofire.request("https://api.themoviedb.org/3/person/\(id)/movie_credits?api_key=562d128051ad4ff39900582f6624ca25&language=en-US").responseJSON { (Response) in
            
            if let value = Response.result.value {
                
                let json = JSON(value)
                
                for result in json["cast"].array! {
                    
                    let id = result["id"].intValue
                    let moviePoster =  URL(string: "https://image.tmdb.org/t/p/w300" + result["poster_path"].stringValue)
                    let movieName = result["title"].stringValue
                    let movieCharacter = result["character"].stringValue
                    // let release = self.formattedDateFromString(result["release_date"].stringValue, "yyyy")
                    
                    self.inMovieId.append(id)
                    self.inMoviePoster.append(moviePoster!)
                    self.inMovieName.append(movieName)
                    self.inMovieChar.append(movieCharacter)
                    // self.inMovieRelease.append(release!)
                    
                }
                
                DispatchQueue.main.async {
                    self.inMovies.reloadData()
                }
                
            }
            
        }
        
        
    }
    
    func formattedDateFromString(_ dateString: String, _ format: String) -> String? {
        
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

    // MARK: - Collection view data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.inMovieName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "inMovieCell", for: indexPath) as! InMovieCollectionCell
        
        let objectName = inMovieName[indexPath.row]
        let objectChar = inMovieChar[indexPath.row]
        let objectPoster = inMoviePoster[indexPath.row]
        // let objectRelease = inMovieRelease[indexPath.row]
        
        cell.inMovieName.text = objectName // + " (\(objectRelease))"
        cell.inMovieChar.text = objectChar
        cell.inMoviePoster.sd_setImage(with: objectPoster, placeholderImage: #imageLiteral(resourceName: "empty"))
        cell.inMoviePoster.layer.cornerRadius = 8.0
        cell.inMoviePoster.clipsToBounds = true
        
        return cell
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < super.numberOfSections(in: tableView) {
        
            return super.tableView.numberOfRows(inSection: section)
        } else {
            return self.inMovieName.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < super.numberOfSections(in: tableView) {
            return super.tableView.cellForRow(at: indexPath)!
        } else {
            let dynamicCell = tableView.dequeueReusableCell(withIdentifier: "cell")
            
            let objectName = inMovieName[indexPath.row]
            let objectChar = inMovieChar[indexPath.row]
            let objectPoster = inMoviePoster[indexPath.row]
            
            return dynamicCell!
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showMovie" {
            if let cell = sender as? InMovieCollectionCell, let indexPath = inMovies.indexPath(for: cell) {
                let objectId = inMovieId[indexPath.row]
                let controller = segue.destination as! DetailTableViewController
                controller.detailItem = objectId
            }
        }
    }

}
