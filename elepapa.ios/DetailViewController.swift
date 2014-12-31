//
//  DetailViewController.swift
//  elepapa.ios
//
//  Created by Yuming Cao on 11/26/14.
//  Copyright (c) 2014 papa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var papaDetailView: UIWebView!


    var detailItem: PapaModel? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func getPapaDetail(papaId: Int) -> Void {
        DataManager.getPapaDetailFromElepapaWithSuccess(papaId, success: { (data) -> Void in
            let json = JSON(data: data)
            
            if let papaArray = json["post_stream"]["posts"].arrayValue {
                if let detail: PapaModel = self.detailItem {
                    detail.content = papaArray[0]["cooked"].stringValue
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.configureView()
            })
        })
    }
    
    func generateHtml(detail: PapaModel) -> String {
        var cssStyle = "<link href=\"http://elepapa.com/uploads/stylesheet-cache/mobile_d53bbc3837adefabb16d696db452a9618a4805b6.css\" rel=\"stylesheet\">"
        var topicStyle = "<style>#wmd-preview img:not(.thumbnail), .cooked img:not(.thumbnail) {max-width: 100%; height: auto;}</style>"
        var metaView = "<meta name=\"viewport\" content=\"width=device-width; minimum-scale=1.0; maximum-scale=1.0; user-scalable=no\">"
        
        var htmlHeader = "<head>" + cssStyle + topicStyle + metaView + "</head>"
        var htmlBody = "<div class=\"cooked\">" + detail.content! + "</div>"
        return htmlHeader + htmlBody
    }   
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: PapaModel = self.detailItem {
            if let content = self.papaDetailView {
                content.loadHTMLString(self.generateHtml(detail), baseURL: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let detail: PapaModel = self.detailItem {
            getPapaDetail(detail.id)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

