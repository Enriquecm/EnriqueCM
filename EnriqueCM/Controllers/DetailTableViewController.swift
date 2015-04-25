//
//  DetailTableViewController.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 19/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

private let kTableHeaderHeight  : CGFloat = 400.0
private let kTableHeaderCut     : CGFloat = 80.0


class DetailTableViewController: UITableViewController, UIScrollViewDelegate {
    
    private var isLoading = true
    private var headerView      : UIView!
    private var headerMaskLayer : CAShapeLayer!
    private var arrayOfCardInfo: [[String: AnyObject]]? = []
    
    @IBOutlet var fullImageView : UIImageView!
    @IBOutlet var miniImageView : UIImageView!
    @IBOutlet var viewFullImageView: UIView!
    
    var card            : Card? = nil
    var fullImage       : UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.miniImageView.image = self.fullImage
        self.fullImageView.image = self.fullImage
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        //TODO: Remove Timer
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("loadCardInfo"), userInfo: nil, repeats: false)
    }
    
    func loadCardInfo() {
        if card != nil {
            if let array = card!.info as? [[String : AnyObject]] {
                for info in array {
                    arrayOfCardInfo?.append(info)
                }
            }
        }
        isLoading = false
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.headerView = self.tableView.tableHeaderView
            self.tableView.tableHeaderView = nil
            self.tableView.addSubview(self.headerView)
            
            let effectiveHeight = kTableHeaderHeight //- kTableHeaderCut/2
            self.tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
            self.tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
            
            self.headerMaskLayer = CAShapeLayer()
            self.headerMaskLayer.fillColor = UIColor.blackColor().CGColor
            
            self.headerView.layer.mask = self.headerMaskLayer
            
            self.updateHeaderView()
            }) { (finished) -> Void in
                //Nothing to do
        }
    }
    
    func updateHeaderView() {
        let effectiveHeight = kTableHeaderHeight //- kTableHeaderCut/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y //+ kTableHeaderCut/2
        }
        headerView.frame = headerRect
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLineToPoint(CGPoint(x: 0, y: headerRect.height - kTableHeaderCut))
        headerMaskLayer?.path = path.CGPath
    }
    
    
    // MARK: Segue unwind
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier {
            if id == "segueToDetailUnwind" {
                let unwindSegue = UnwindBottonToUpCustomSegue(identifier: id,
                    source:fromViewController,
                    destination: toViewController,
                    performHandler: { () -> Void in
                        
                })
                return unwindSegue
            }
        }
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)
    }
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue){
        
    }
    
    @IBAction func dismissViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - ScrollView delegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    
    // MARK: - Table view data source and delegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else {
            return arrayOfCardInfo!.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if isLoading {
            cell = tableView.dequeueReusableCellWithIdentifier("cellLoading", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
        
        var info = arrayOfCardInfo![indexPath.row]
        if info["type"] is String {
            
            var identifier = getPropertiesFromType(info["type"] as! String)["identifier"] as! String
            cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell
            if cell.respondsToSelector("initWithDictionary:") {
                cell.initWithDictionary(info)
            }
            
            return cell
            
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("cellLoading", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if isLoading {
//            return 80.0
//        } else {
//            let info = arrayOfCardInfo![indexPath.row]
//            return getPropertiesFromType(info["type"] as! String)["height"] as! CGFloat
//        }
//    }
//    
    
    //MARK: - Methods
    
    func getPropertiesFromType(type:NSString) -> [String : AnyObject] {
        switch(type){
        case "title":
            return ["identifier": "cellTitleSubtitleImage", "height": 60.0]
        case "adjustable-text":
            return ["identifier": "cellAdjustableText", "height": 122.0]
        case "link":
            return ["identifier": "cellLink", "height": 53.0]
        case "date":
            return ["identifier": "cellDate", "height": 33.0]
        case "media", "project", "honor":
            return ["identifier": "cellCollection", "height": 155.0]
        default:
            return ["identifier": "cellLoading", "height": 80]
        }
    }
}









