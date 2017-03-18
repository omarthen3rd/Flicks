//
//  GenreDetailViewController.swift
//  Flicks
//
//  Created by Omar Abbasi on 2016-12-27.
//  Copyright © 2016 Omar Abbasi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GenreDetailViewController: UIViewController {

    var idPassed = 0
    var idToUse = 0
    
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
        Alamofire.request("https://api.themoviedb.org/3/discover/movie?api_key=562d128051ad4ff39900582f6624ca25&with_genres=\(genreId)&sort_by=vote_average.desc&vote_count.gte=10").responseJSON { (Response) in
            
            if let value = Response.result.value {
                
                let json = JSON(value)
                
                for result in json["results"].array! {
                    let title = result["title"].array!
                    let poster = result["poster"]
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
