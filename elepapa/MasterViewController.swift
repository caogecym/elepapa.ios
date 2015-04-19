//
//  MasterViewController.swift
//  elepapa
//
//  Created by Yuming Cao on 11/26/14.
//  Copyright (c) 2014 papa. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVPullToRefresh

class MasterViewController: UITableViewController {

    var objects = [PapaModel]()
    var objMap = [Int: PapaModel]()
    var baseUrl = "http://shanzhu365.com"
    var papaUrl = "http://shanzhu365.com/latest.json"
    var nextUrl = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = false
        
        self.tableView.addPullToRefreshWithActionHandler({() -> Void in
            // Pull refresh is pretty expensive
            self.objects.removeAll()
            self.getPapaObjects(self.papaUrl, {() -> Void in
                self.tableView.reloadData()
                self.tableView.pullToRefreshView.stopAnimating()
            })
        })
        
        self.tableView.addInfiniteScrollingWithActionHandler({() -> Void in
            if !self.hasNextPage() {
                self.tableView.infiniteScrollingView.stopAnimating()
                return
            }
            
            let insertPosition = self.objects.count
            self.getPapaObjects(self.nextUrl, {() -> Void in
                self.insertNextPage(insertPosition)
                self.tableView.infiniteScrollingView.stopAnimating()
            })
        })
    }
    
    func hasNextPage() -> Bool {
        if self.nextUrl.rangeOfString("latest") != nil {
            return true
        }
        else {
            return false
        }
    }
    
    func insertNextPage(insertPosition: Int) -> Void {
        var index_paths = [NSIndexPath]()
        for i in insertPosition...self.objects.count - 1 {
            index_paths.append(NSIndexPath(forRow: i, inSection: 0))
        }
        self.tableView.insertRowsAtIndexPaths(index_paths, withRowAnimation: .Automatic)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if objects.count == 0 {
            self.getPapaObjects(self.papaUrl, self.loadLatestPapas)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPapaObjects(url: String, success: () -> Void) -> Void {
        DataManager.getLatestPapaDataFromElepapaWithSuccess (url, { (data) -> Void in
            let json = JSON(data: data)
            
            self.nextUrl = self.baseUrl + json["topic_list"]["more_topics_url"].stringValue
            let papaArray = json["topic_list"]["topics"].arrayValue
            for papaDict in papaArray {
                var papaId: Int? = papaDict["id"].intValue
                var papaTitle: String? = papaDict["title"].stringValue
                var papaImgUrl: String? = papaDict["image_url"].stringValue
                if let id: Int = papaId {
                    if let papa = self.objMap[id] {
                        self.objects.append(papa)
                    }
                    else {
                        var papa = PapaModel(id: id, title: papaTitle!, imageURL: papaImgUrl)
                        self.objMap[id] = papa
                        self.objects.append(papa)
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                success()
            })
        })
    }
    
    func loadLatestPapas() {
        var index_paths = [NSIndexPath]()
        for i in 0...objects.count - 1 {
            index_paths.append(NSIndexPath(forRow: i, inSection: 0))
        }
        self.tableView.insertRowsAtIndexPaths(index_paths, withRowAnimation: .Automatic)
    }
    
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = self.objects[indexPath.row]
                
            self.tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.textColor = UIColor.grayColor()

            (segue.destinationViewController as DetailViewController).detailItem = object
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        if !objects.isEmpty {
            let object = objects[indexPath.row]
            if object.visited {
                cell.textLabel?.textColor = UIColor.grayColor()
            }
            else {
                cell.textLabel?.textColor = UIColor.blackColor()
            }
            cell.textLabel?.text = object.description
        }
        return cell
    }
}