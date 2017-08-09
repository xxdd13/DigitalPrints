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
    var items:[Any] = [String]()
    var orderDate:[Any] = [String]()
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 8
    
    //var items:[Any] = ["1"]
    //var orderDate:[Any] = ["1"]
    
    
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
            //getJSON(urlToRequest: "https://fbfb-9d93e.appspot.com/geto?userID="+fbemail!)
        }
        
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        
        let screenSize = UIScreen.main.bounds
        let tableWidth = screenSize.width-60
        let tableHeight = screenSize.height-40
        tableView.frame         =   CGRect(x: 30, y: 30, width: tableWidth, height: tableHeight);
        tableView.delegate      =   self as! UITableViewDelegate
        tableView.dataSource    =   self as! UITableViewDataSource
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        let notificationName = Notification.Name("NotificationIdentifier")
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.handleAlert), name: notificationName, object: nil)
        
        
        
        
    }
    
    func hasImageViewInside(_ cell: UITableViewCell) -> Bool {
        for child in cell.subviews {
            if let _ = child as? UIImageView {
                return true
            }
        }
        return false
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
        Alamofire.request(urlString).responseJSON { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                let parsedData = try! JSONSerialization.jsonObject(with: data) as! [[String:Any]]
                self.items=[]
                for item in parsedData {
                    if let imageurl = item["imageurl"] as? String {
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
        
        return 1//self.items.count
    }
    
    //////////////////////////////////////////////////////////
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    // There is just one row in every section
    
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    //////////////////////////////////////////////////////////////////////////////
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        
        var originalurl=self.items[indexPath.section] as! String
        
        var strurl = originalurl.components(separatedBy: ".png")[0]+"t"+".png"

        
        let imageURL = URL(string: strurl)
        
        getDataFromUrl(url: imageURL!, idx:indexPath.row) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                cell.imageView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                cell.imageView?.image = UIImage(data: data)
                cell.textLabel?.text = self.orderDate[indexPath.section] as? String
                
                cell.backgroundColor = UIColor.white
                cell.layer.borderColor = UIColor(hue: 288/360, saturation: 9/100, brightness: 3/100, alpha: 0.5).cgColor
                cell.layer.borderWidth = 1
                cell.layer.cornerRadius = 8
                cell.clipsToBounds = true
                
                /*
                if indexPath.row == (self.items.count - 1)
                {
                    print("came to last row")
                    self.checkIfNeedReload2()
                    
                }
                if indexPath.row == 6
                {
                    print("6th row")
                    self.checkIfNeedReload()
                }
                */
            }
        }
        
        
        return cell
    }
    func getDataFromUrl(url: URL,idx: Int, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        print("You tapped cell number \(indexPath.section).")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


