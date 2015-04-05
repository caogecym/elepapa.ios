//
//  DetailViewController.swift
//  elepapa
//
//  Created by Yuming Cao on 11/26/14.
//  Copyright (c) 2014 papa. All rights reserved.
//

import UIKit
import SwiftyJSON
import WeChat

class DetailViewController: UIViewController {

    @IBOutlet var papaDetailView: UIWebView!


    var detailItem: PapaModel? {
        didSet {
            self.configureView()
        }
    }

    func getPapaDetail(papaId: Int) -> Void {
        DataManager.getPapaDetailFromElepapaWithSuccess(papaId, success: { (data) -> Void in
            let json = JSON(data: data)
            
            let papaArray = json["post_stream"]["posts"].arrayValue
            if let detail: PapaModel = self.detailItem {
                detail.content = papaArray[0]["cooked"].stringValue
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
                content.loadHTMLString(self.generateHtml(detail), baseURL: NSURL(string:"https://"))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get rid of 64px UIWebView top padding
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Action,
            target:self,
            action: "rightBtnSelected"
        )
        
        //self.setupGestureRecognizer()

        if let detail: PapaModel = self.detailItem {
            getPapaDetail(detail.id)
        }
    }
    
    func setupGestureRecognizer() {
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeLeft:")
        recognizer.direction = .Left
        self.view.addGestureRecognizer(recognizer)
    }
    
    func swipeLeft(recognizer : UISwipeGestureRecognizer) {
        //self.performSegueWithIdentifier("MySegue", sender: self)
        println("TODO: swipe left handler here")
    }

    
    func initAlertController() -> UIAlertController {
        var alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        
        let shareWithWeChatFriendAction = UIAlertAction(
            title: "Share with WeChat friend",
            style: UIAlertActionStyle.Default,
            handler: { (action: UIAlertAction!) -> Void in
                self.sharePapaToFriend()
            }            
        )             
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler: nil
        )
        
        alert.addAction(shareWithWeChatFriendAction);
        alert.addAction(cancelAction);
        return alert
    }
    
    func sharePapaToFriend() {
        var message = WXMediaMessage()
        
        if let papa: PapaModel = self.detailItem {
            message.title = papa.title
            // message.description = papa.getText()
            
            // TODO: fetch papa image or elepapa logo
            // message.setThumbImage(UIImage(imageNamed: "res2.png"))
            
            var webObj = WXWebpageObject()
            webObj.webpageUrl = "www.elepapa.com/t/\(papa.id)"
            message.mediaObject = webObj
            
            var req  = SendMessageToWXReq()
            req.bText = false
            req.message = message
            
            WXApi.sendReq(req)
        }
    }

    
    func rightBtnSelected() {
        self.presentViewController(self.initAlertController(), animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

