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
    var orderDate:[Any] = ["1"]
    
    
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
    func reloadTable(notification: NSNotification) {
        self.tableView.reloadData()
        
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
                        // imgurl http
                        self.items.append(imageurl)
                    }
                    if let orderdate = item["date"] as? String {
                        self.orderDate.append(orderdate)
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
        
        
        var originalurl=self.items[indexPath.row] as! String
        var strurl = originalurl.components(separatedBy: ".png")[0]+"t"+".png"
        
        
        
        cell.textLabel?.text = self.orderDate[indexPath.row] as? String
        
        ///////////////////
        
        let imageURL = URL(string: strurl)
        
        getDataFromUrl(url: imageURL!) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                cell.imageView?.image = UIImage(data: data)
                cell.imageView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                
            }
            //self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            
        }
        
        
        
        return cell
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.0;//Choose your custom row height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
