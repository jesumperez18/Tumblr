//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Jesus perez on 1/31/18.
//  Copyright © 2018 Jesus perez. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var PhotoTableView: UITableView!
    var posts: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PhotoTableView.delegate = self
        PhotoTableView.dataSource = self

        // Do any additional setup after loading the view.
        // Network request snippet
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                
               
                self.PhotoTableView.reloadData()
                // TODO: Reload the table view
            }
        }
        task.resume()
        
        
    }
    func tableView(_ PhotoTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ PhotoTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.textLabel?.text = "This is row \(indexPath.row)"
        let cell = PhotoTableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell") as! PhotoTableViewCell
        
        // Configure YourCustomCell using the outlets that you've defined.
        let post = posts[indexPath.row]
        print(post)
        if let photos = post["photos"] as? [[String: Any]] {
            // photos is NOT nil, we can use it!
            // TODO: Get the photo url
            // 1.
            let photo = photos[0]
            // 2.
            let originalSize = photo["original_size"] as! [String: Any]
            // 3.
            let urlString = originalSize["url"] as! String
            // 4.
            let url = URL(string: urlString)
            
            cell.pImageView.af_setImage(withURL: url!)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let pdvc = segue.destination as! PhotoDetailsViewController
        let cell = sender as! UITableViewCell
        let indexPath = PhotoTableView.indexPath(for: cell)
        
        let post = posts[indexPath!.row]
        
        if let photos = post["photos"] as? [[String: Any]] {
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String: Any]
            let urlS = originalSize["url"] as! String
            let url = URL(string: urlS)
            
            pdvc.photoURL = url
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
