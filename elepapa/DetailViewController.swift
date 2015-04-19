//
//  DetailViewController.swift
//  elepapa
//
//  Created by Yuming Cao on 11/26/14.
//  Copyright (c) 2014 papa. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
import WeChat

class DetailViewController: UIViewController, WKNavigationDelegate {

    var webView = WKWebView()
    var detailItem: PapaModel?
    
    func loadPapaData(papa: PapaModel, papaArray: [JSON]) {
        for post in papaArray {
            let author_name = post["username"].stringValue
            let content = post["cooked"].stringValue
            let author_avator_url = "http://shanzhu365.com/letter_avatar/caogecym/45/2.png"//post[""].stringValue
            papa.posts.append(Post(author_name: author_name, author_avatar_url: author_avator_url, content: content))
        }
    }
    
    func getPapaDetail(papaId: Int) {
        DataManager.getPapaDetailFromElepapaWithSuccess(papaId, success: { (data) -> Void in
            let json = JSON(data: data)
            let papaArray = json["post_stream"]["posts"].arrayValue
            if let papa: PapaModel = self.detailItem {
                self.loadPapaData(papa, papaArray: papaArray)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.configureWebView()
            })
        })
    }
    
    func getHeader() -> String {
        var cssStyle = "<link href=\"http://www.shanzhu365.com/uploads/stylesheet-cache/mobile_7451cd83369ad97b0cb973b0fb273ce2bf497534.css?__ws=elepapa.com\" media=\"all\" rel=\"stylesheet\">"
        var topicStyle = "<style>#wmd-preview img:not(.thumbnail), .cooked img:not(.thumbnail) {max-width: 100%; height: auto;}</style>"
        var metaView = "<meta name=\"viewport\" content=\"initial-scale=1.0\"/>"
        return "<head>" + cssStyle + topicStyle + metaView + "</head>"
    }
    
    func generateHtml() -> String {
        var res = "<html>" + getHeader() + getBody() + "</html>"
        return res
        
    }
    
    func getBody() -> String {
        if let papa: PapaModel = self.detailItem {
            return "<body>" + getTitle(papa) + getPosts(papa) + "</body>"
        } else {
            return ""
        }
    }
    
    func getTitle(papa: PapaModel) -> String {
        return "<h3 style=\"padding-top: 10px;\">\(papa.title)</h3>"
    }
    
    func getPosts(papa: PapaModel) -> String {
        var htmlMarkdown = ""
        for post in papa.posts {
            htmlMarkdown += getAvator(post) + getTopicBody(post)
        }                                   
        return htmlMarkdown
    }
    
    func getAvator(post: Post) -> String {
        return "<div style=\"float: left;\"><img width=\"45\" height=\"45\" src=\"" +  post.author_avatar_url + "\" class=\"avatar\"></div>" +
               "<div style=\"float: left; margin-left: 5px;\"><b>" + post.author_name + "</b></div>"
    }
    
    func getTopicBody(post: Post) -> String {
        return "<div style=\"clear: left; padding-top: 5px; padding-right: 5px;\"><div class=\"cooked\">" + post.content + "</div></div>"
    }
    
    func configureWebView() {
        view.addSubview(webView)
        self.addWebViewConstraints(webView, parent: view)
        webView.loadHTMLString(self.generateHtml(), baseURL: NSURL(string:"https://"))
    }
    
    //func webView(webView: WKWebView,
    //             shouldStartLoadWithRequest request: NSURLRequest,
    //             navigationType: UIWebViewNavigationType) -> Bool {
    //    println("im here")
    //    return true
    //}
    
    func addWebViewConstraints(webView: WKWebView, parent: UIView) {
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let top = NSLayoutConstraint(item: webView, attribute: .Top, relatedBy: .Equal, toItem: parent, attribute: .Top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: webView, attribute: .Bottom, relatedBy: .Equal, toItem: parent, attribute: .Bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: webView, attribute: .Left, relatedBy: .Equal, toItem: parent, attribute: .Left, multiplier: 1, constant: 5)
        let right = NSLayoutConstraint(item: webView, attribute: .Right, relatedBy: .Equal, toItem: parent, attribute: .Right, multiplier: 1, constant: -5)
        parent.addConstraints([top, bottom, left, right])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Action,
            target:self,
            action: "rightBtnSelected"
        )
        
        //self.setupGestureRecognizer()

        if let papa: PapaModel = self.detailItem {
            papa.visited = true
            getPapaDetail(papa.id)
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

    
    func initActionSheet() -> UIAlertController {
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
            message.description = papa.getText()
            message.setThumbImage(UIImage(named: "logo.png"))
            
            var webObj = WXWebpageObject()
            webObj.webpageUrl = "www.shanzhu365.com/t/\(papa.id)"
            message.mediaObject = webObj
            
            var req  = SendMessageToWXReq()
            req.bText = false
            req.message = message
            
            WXApi.sendReq(req)
        }
    }

    
    func rightBtnSelected() {
        self.presentViewController(self.initActionSheet(), animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

