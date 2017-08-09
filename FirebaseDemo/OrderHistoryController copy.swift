import UIKit
import FBSDKLoginKit
import Firebase
import Foundation
import imgurupload_client
import Alamofire

class OrderHistoryController: UIViewController,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate,NSURLConnectionDelegate {
    var tableView: UITableView  =   UITableView()
    var globalemail = FIRAuth.auth()?.currentUser?.email
    var getorderurl = "https://fbfb-9d93e.appspot.com/geto?userID="+(FIRAuth.auth()?.currentUser?.email)!
    var items:[Any] = ["1"]
    
    
    //let imagePickerController = UIImagePickerController()
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let currentUser = FIRAuth.auth()?.currentUser {
            let fbusername = currentUser.displayName
            let fbemail = currentUser.email
            getJSON(urlToRequest: "https://fbfb-9d93e.appspot.com/geto?userID="+fbemail!)
            
        }
        
    }
    
    
    @IBOutlet weak var home: UIToolbar!
    //@IBOutlet weak var fb_email: UILabel!
    //@IBOutlet weak var fb_username: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let currentUser = FIRAuth.auth()?.currentUser {
            let fbusername = currentUser.displayName
            let fbemail = currentUser.email
            getJSON(urlToRequest: "https://fbfb-9d93e.appspot.com/geto?userID="+fbemail!)
        }
        
        let screenSize = UIScreen.main.bounds
        let tableWidth = screenSize.width-60
        let tableHeight = screenSize.height-40
        tableView.frame         =   CGRect(x: 30, y: 30, width: tableWidth, height: tableHeight);
        tableView.delegate      =   self as! UITableViewDelegate
        tableView.dataSource    =   self as! UITableViewDataSource
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)

        
        
        let notificationName = Notification.Name("NotificationIdentifier")
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.handleAlert), name: notificationName, object: nil)
        
        
    }
    func handleAlert(notification: NSNotification) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        
    }
    
    func getJSON(urlToRequest: String){
        let urlString = urlToRequest
        //print(urlToRequest)
        Alamofire.request(urlString).responseJSON { response in
            
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                //print("Data: \(utf8Text)")
                //print(data)
                let parsedData = try! JSONSerialization.jsonObject(with: data) as! [[String:Any]]
                self.items=[]
                for item in parsedData {
                    if let imageurl = item["imageurl"] as? String {
                        print("imgurl")
                        print(imageurl)
                        self.items.append(imageurl)
                        
                        
                    }
                }
                
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        
        let strurl=self.items[indexPath.row] as! String
        //let imageURL = NSURL(string: strurl)
        cell.textLabel?.text = self.items[indexPath.row] as? String
        
        ///////////////////
        
        Alamofire.request(strurl).responseJSON { response in
            if let datai = response.data {
                let image = UIImage(data: datai)
                
                cell.imageView?.image = image
                
                
            }
                
            
        }
        
        ////////////////////////
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
