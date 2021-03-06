//
//  HomeViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/7/16.
//  Copyright © 2016 vertaceapp. All rights reserved.


import UIKit


class HomeViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
      var notificationItems = [Notification]()
     var categoryItems = [Category]()
     var no_of_items = -1
    var timer = NSTimer()
    var count = 0
    var movecount = 1
    var value: UIImage?
    var check = 0
    var username1 = ""
    var password1 = ""
    var activitystop = 0
    var cartcountnumber = 0
    var userid = ""
    
    
    var baseViewForTopImageView: UIView = UIView()
    var noticeimg: UIImageView = UIImageView()
    var categorylbl: UILabel = UILabel()
    var pageController: UIPageControl = UIPageControl()
    
    
    @IBOutlet weak var Open: UIBarButtonItem!
    
//    @IBOutlet weak var categorylbl: UILabel!
   
//    @IBOutlet weak var noticeimg: UIImageView!

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
   
//    @IBOutlet weak var pageController: UIPageControl!
         var scrollView: UIScrollView!
    
    var sidemenu: UIBarButtonItem!
    @IBOutlet weak var cartbtn: UIButton!

        @IBOutlet weak var tableView: UITableView!
    var search: UIBarButtonItem!
     var actionButton: ActionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        baseViewForTopImageView.frame = CGRectMake(0, 0, self.view.frame.size.width , 200)
        baseViewForTopImageView.backgroundColor = UIColor(red: 58.0/255.0, green: 88.0/255.0, blue: 38.0/255.0, alpha:1.0)
        tableView.tableHeaderView = baseViewForTopImageView
        noticeimg.frame = CGRectMake(0, 0, self.view.frame.size.width, 175)
        [baseViewForTopImageView .addSubview(noticeimg)]
        categorylbl.frame = CGRectMake(0, noticeimg.frame.size.height, self.view.frame.size.width, 25)
        categorylbl.text = "Categories"
        categorylbl.tintColor = UIColor.whiteColor()
        categorylbl.textAlignment = NSTextAlignment.Center
        [baseViewForTopImageView .addSubview(categorylbl)]
        pageController.frame = CGRectMake(self.view.center.x-20, noticeimg.frame.size.height-15, self.view.frame.size.width, 15)
        configurePageControl()
        [baseViewForTopImageView .addSubview(pageController)]
        
        
        
        
        activityIndicator.startAnimating()
         Reachability().checkconnection()
        sidemenu = UIBarButtonItem(image: UIImage(named: "Menu_36.png"), style: .Plain, target: self, action: Selector("action"))
        navigationItem.leftBarButtonItem = sidemenu
        sidemenu.target = self.revealViewController()
        sidemenu.action = Selector("revealToggle:")
//        Open.target = self.revealViewController()
//        Open.action = Selector("revealToggle:")
//        self.cartbtn = UIButton(type: .Custom)
        self.cartbtn.frame = CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height - 80, 45, 45)
        self.cartbtn.layer.cornerRadius = 23
        self.cartbtn.layer.shadowOpacity = 1
        self.cartbtn.layer.shadowRadius = 2
        self.cartbtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.cartbtn.layer.shadowColor = UIColor.grayColor().CGColor

        cartbtn.titleEdgeInsets = UIEdgeInsetsMake(5, -35, 0, 0)
        
        cartbtn.setImage(UIImage(named: "Cartimg.png"), forState: UIControlState.Normal)
        cartbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 4.5, 3, 0)

        cartbtn.tintColor = UIColor(red: 58.0/255.0, green: 88.0/255.0, blue: 38.0/255.0, alpha:1.0)
        cartbtn.backgroundColor = UIColor(red: 58.0/255.0, green: 88.0/255.0, blue: 38.0/255.0, alpha:1.0)
        cartbtn.userInteractionEnabled = true
        cartbtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cartbtn)

        getuserdetails()
        
        

            self.sendrequesttoserveragain()
            self.sendrequesttoserver()
        

    }
    
    func configurePageControl()
    {
        self.pageController.numberOfPages = 5
        self.pageController.currentPage = 0
        self.pageController.tintColor = UIColor.redColor()
        self.pageController.pageIndicatorTintColor = UIColor.whiteColor()
        self.pageController.currentPageIndicatorTintColor = UIColor.greenColor()
        
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.hidesBackButton = true
        search = UIBarButtonItem(image: UIImage(named: "search.png"), style: .Plain, target: self, action: Selector("searchaction"))
        
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        navigationItem.rightBarButtonItem = search
        
        cartcountnumber = 0
        Getcartcount()
        
        self.view.userInteractionEnabled = false

        self.view.userInteractionEnabled = true
    }
    
    func searchaction(){
        
        self.performSegueWithIdentifier("goto_search", sender: self)
        
    }
    

    @IBAction func FloatBtnAction(sender: AnyObject) {
        self.performSegueWithIdentifier("fromhome_tocart", sender: self)
    }
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
           navigationItem.hidesBackButton = true
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)

    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                ChangeImageAction(true)
            case UISwipeGestureRecognizerDirection.Left:
                ChangeImageAction(false)
            default:
                break
            }
        }
    }
    
    
    func ChangeImageAction(let moveLeft:Bool) {
        if moveLeft
        {
            count -= 1
        }
        else
        {
            count += 1
        }
        
        if count < 0
        {
            count = no_of_items
            self.pageController.currentPage = no_of_items
        }
       
        if count > no_of_items
        {
//            count = no_of_items
            count = 0
            self.pageController.currentPage = 0
        }
        
        
        self.pageController.currentPage = count
        
        let notification = notificationItems[count]
        noticeimg.image = notification.NotificationPhoto
        
    }
    
    
    
    
    
    

//    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
//        
//        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
//            
//            
//            switch swipeGesture.direction {
//            case UISwipeGestureRecognizerDirection.Right:
////
//                count = count - 1
//                print("count==>>",count)
////                self.pageController.currentPage -= 1
////                ChangeImageAction()
//                ChangeImageActionForRightSwipe()
//            case UISwipeGestureRecognizerDirection.Left:
//                
////                count = count + 1
//                print("count==>>",count)
////                self.pageController.currentPage += 1
//                ChangeImageAction()
//            default:
//                break
//            }
//        }
//    }
    
    func GotoCartView(){
        self.performSegueWithIdentifier("fromhome_tocart", sender: self)
    }
    
    func getuserdetails(){
        DBHelper().opensupermarketDB()
        let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
        let databasePath = databaseURL.absoluteString
        let supermarketDB = FMDatabase(path: databasePath as String)
        if supermarketDB.open() {
            
            let selectSQL = "SELECT * FROM LOGIN"
            
            let results:FMResultSet! = supermarketDB.executeQuery(selectSQL,
                withArgumentsInArray: nil)
            if (results.next())
            {
                self.userid = "\(results.intForColumn("USERID"))"
                self.username1 = results.stringForColumn("EMAILID")
                self.password1 = results.stringForColumn("PASSWORD")
                
            }
            supermarketDB.close()
        } else {
            print("Error: \(supermarketDB.lastErrorMessage())")
        }
        print(username1)
        print(password1)
    }



    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "homeCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell!
        if(activitystop == 2) {
        activityIndicator.stopAnimating()
        }
        let category = categoryItems[indexPath.row ]
        let categoryimg = cell.viewWithTag(2) as! UIImageView
        let categorylbl = cell.viewWithTag(3) as! UILabel
        categorylbl.text = category.Name
        categoryimg.image = category.CategoryPhoto
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.grayColor().CGColor

        if(check == 0){
            let clr = UIColor(red: 176, green: 240, blue: 148, alpha: 1)
            cell.layer.backgroundColor = clr.CGColor
            check = 1
        }
        else {
            let clr = UIColor(red: 46, green: 71, blue: 30, alpha: 1)
            cell.layer.backgroundColor = clr.CGColor
            check = 0
        }
        return cell
    }
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems.count
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.clearColor().CGColor
        selectionColor.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = selectionColor
    }

    
    func sendrequesttoserver()
    {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        //let request = NSMutableURLRequest(URL: NSURL(string: "https://ttltracker.azurewebsites.net/task/getallwalllist")!)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GETCATEGORY)!)
        request.HTTPMethod = "GET"
      
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
      
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                
                
                
                
                let json = JSON(data: data!)
                
                for item in json["result"].arrayValue {
                    let categoryimgPath = Appconstant.IMAGEURL+"Images/Category/"+item["ImageUrl"].stringValue
                    let img =  UIImage(data: NSData(contentsOfURL: NSURL(string:categoryimgPath)!)!)
                  
                    let category = Category(ID: item["ID"].stringValue, Name: item["Name"].stringValue, CategoryPhoto : img!, imagePath: categoryimgPath)!
                   
                    self.categoryItems += [category];
                 
                }
                self.activitystop += 1

                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
        }
        task.resume()
        
    }
    func sendrequesttoserveragain() {
        
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        //let request = NSMutableURLRequest(URL: NSURL(string: "https://ttltracker.azurewebsites.net/task/getallwalllist")!)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GETNOTICE)!)
        request.HTTPMethod = "GET"
      
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        //    let postString = "Username="+self.txtUsername.text!+"&Password="+self.txtPassword.text!
        //    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                
                let jsons = JSON(data: data!)
                for item in jsons["result"].arrayValue {
                   
                    let NotificationimgPath = Appconstant.IMAGEURL+"Images/Notice/"+item["ImagePath"].stringValue;
                    let nimg = UIImage(data: NSData(contentsOfURL: NSURL(string:NotificationimgPath)!)!)
                    let notification = Notification(Title: item["Title"].stringValue, Description: item["Description"].stringValue, StartDate: item["StartDate"].stringValue,  NotificationPhoto : nimg!)!
                    self.no_of_items += 1;
                     self.notificationItems += [notification];
                }
                self.activitystop += 1
                dispatch_async(dispatch_get_main_queue()) {
                    print(self.notificationItems[0].NotificationPhoto)
                     self.noticeimg.image = self.notificationItems[0].NotificationPhoto
                    self.pageController.numberOfPages = self.no_of_items + 1
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(7, target:self, selector: Selector("ChangeImageAction"), userInfo: nil, repeats: true)
                }
        }
        task.resume()
   
    }

    func Getcartcount() {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_CART_OPEN+self.userid)!)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("ERROR")
                    print("response = \(response)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                
                let json = JSON(data: data!)
                var item = json["result"]
                for item2 in item["CartLineItemList"].arrayValue{
                    
                    self.cartcountnumber = self.cartcountnumber + 1
                    
                    
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.cartbtn.setTitle("\(self.cartcountnumber)", forState: .Normal)
                }
        }
        
        task.resume()
        
    }
    
    
   
    
    

    func ChangeImageAction() {
        print("cou==>>",count)
        if (no_of_items >= count) {
            if (count < 0) {
                count = 0
                self.pageController.currentPage = 0
            }
        let notification = notificationItems[count]

            noticeimg.image = notification.NotificationPhoto

            
        count = count + 1
            self.pageController.currentPage += 1
        }
            if (no_of_items + 1 == count) {
                count = 0
                self.pageController.currentPage = 0
            }
     }
    
    func ChangeImageActionForRightSwipe() {
        
        if (no_of_items >= count) {
            if (count < 0) {
                count = 0
                self.pageController.currentPage = 0
            }
            print("couright==>>",count)
            let notification = notificationItems[count]
            
            noticeimg.image = notification.NotificationPhoto
            
            
            count = count - 1
            if count != -1
            {
            self.pageController.currentPage -= 1
            }
            else
            {
               self.pageController.currentPage = no_of_items
                count = no_of_items
            }
        }
//        if (count == -1) {
//            print("reached end")
//            count = 4
//            self.pageController.currentPage = 4
//        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goto_productlist") {
                let nextview = segue.destinationViewController as! ProductViewController
           let indexPath = self.tableView.indexPathForSelectedRow
                nextview.categoryimage = self.categoryItems[(indexPath?.row)!].CategoryPhoto
            nextview.categoryID = self.categoryItems[(indexPath?.row)!].ID
            nextview.cartcountnumber = self.cartcountnumber
            }
        if(segue.identifier == "goto_search"){
            let nextvc = segue.destinationViewController as! SearchViewController
            nextvc.cartcountnumber = self.cartcountnumber
        }
    }

    
 }
