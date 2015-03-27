//
//  MasterViewController.swift
//  elepapa.ios
//
//  Created by Yuming Cao on 11/26/14.
//  Copyright (c) 2014 papa. All rights reserved.
//

import UIKit
import SwiftyJSON

class MasterViewController: UITableViewController {

    var objects = [PapaModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if objects.count == 0 {
            getPapaObjects()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPapaObjects() -> Void {
        DataManager.getLatestPapaDataFromElepapaWithSuccess { (data) -> Void in
            let json = JSON(data: data)
            
            let papaArray = json["topic_list"]["topics"].arrayValue
            for papaDict in papaArray {
                var papaId: Int? = papaDict["id"].intValue
                var papaTitle: String? = papaDict["title"].stringValue
                var papaImgUrl: String? = papaDict["image_url"].stringValue
                var papa = PapaModel(id: papaId!, title: papaTitle!, imageURL: papaImgUrl)
                self.objects.append(papa)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.insertLatestPapas()
            })
        }
    }
    
    func insertLatestPapas() {
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

        let object = objects[indexPath.row]
        cell.textLabel.text = object.description
        return cell
    }
}