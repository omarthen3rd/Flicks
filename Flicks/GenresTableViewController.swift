//
//  GenresTableViewController.swift
//  Flicks
//
//  Created by Omar Abbasi on 2016-12-27.
//  Copyright © 2016 Omar Abbasi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class GenreCell: UITableViewCell {
    
    @IBOutlet var genreName: UILabel!
    
}

class GenresTableViewController: UITableViewController {

    var genres = [String]()
    var genresId = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getGenres()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getGenres() {
        
        Alamofire.request("https://api.themoviedb.org/3/genre/movie/list?api_key=562d128051ad4ff39900582f6624ca25&language=en-US").responseJSON { (Response) in
            
            if let value = Response.result.value {
                
                let json = JSON(value)
                
                for result in json["genres"].array! {
                    
                    let id = result["id"].intValue
                    let name = result["name"].stringValue
                    self.genres.append(name)
                    self.genresId.append(id)
                    
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.genres.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath) as! GenreCell

        let objectName = genres[indexPath.row]
        
        // Configure the cell...

        cell.genreName.text = objectName
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showGenreDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let objectName = genres[indexPath.row]
                let objectId = genresId[indexPath.row]
                let controller = segue.destination as! GenreDetailTableViewController
                controller.detailItem = objectId
            }
        }
        
    }

}
