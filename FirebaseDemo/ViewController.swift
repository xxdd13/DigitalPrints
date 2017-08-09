import UIKit
import FBSDKLoginKit
import Firebase
import Foundation
import imgurupload_client
import Alamofire

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //let imagePickerController = UIImagePickerController()
    var imagePicker : UIImagePickerController = UIImagePickerController()
    var videoURL: NSURL?
    @IBOutlet weak var album: UIButton!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var dropBox: UIButton!
    @IBOutlet weak var dropBoxLabel: UILabel!
    @IBOutlet weak var iCloud: UIButton!
    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet weak var iCloudLabel: UILabel!
    
    let selectedImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .black
        return img
    }()
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool)
    {
        viewController.navigationItem.title = "Media" // Change title
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let screenSize = UIScreen.main.bounds
        let centerX = Int(screenSize.size.width/2)
        let centerY = Int(screenSize.size.height/2)
        let offx = 80
        let offy = 70
        
        
        let leftx = centerX-offx
        let rightx = centerX+offx
        let uppery = centerY-offy
        let lowery = centerY+offy
        let labelOff = 80
        
        
        album?.center.x = CGFloat(leftx) //album
        
        album?.center.y = CGFloat(uppery-labelOff)
        albumLabel?.center.x=CGFloat(leftx)
        albumLabel?.center.y=CGFloat(uppery)
        
        dropBox?.center.x = CGFloat(rightx)
        dropBox?.center.y = CGFloat(uppery-labelOff)
        dropBoxLabel?.center.x=CGFloat(rightx)
        dropBoxLabel?.center.y=CGFloat(uppery)
        
        
       
        
        iCloud?.center.x = CGFloat(leftx)
        iCloud?.center.y = CGFloat(lowery)
        iCloudLabel?.center.x=CGFloat(leftx)
        iCloudLabel?.center.y=CGFloat(lowery+labelOff)
        
        
        facebook?.center.x = CGFloat(rightx)
        facebook?.center.y = CGFloat(lowery)
        facebookLabel?.center.x=CGFloat(rightx)
        facebookLabel?.center.y=CGFloat(lowery+labelOff)
        
        /**/
        
        if let currentUser = FIRAuth.auth()?.currentUser {
            let fbusername = currentUser.displayName
            let fbemail = currentUser.email
            Alamofire.request("https://fbfb-9d93e.appspot.com/addu?userID="+fbemail!)
        }
    
    }

    
    @IBAction func selectImageFromPhotoLibrary(_ sender: Any) {
        
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePicker.navigationBar.isTranslucent = false
            var capturedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            let rect = CGRect(x:0, y:0, width:capturedImage.size.width/3, height:capturedImage.size.height/3)
            UIGraphicsBeginImageContext(rect.size)
            capturedImage.draw(in: rect)
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let compressedImageData = UIImageJPEGRepresentation(resizedImage!, 0.1)
            capturedImage = UIImage(data: compressedImageData!)!
            
            self.selectedImage.image = capturedImage
            
            
            uploadImage()
            
            
            
            
            
            self.dismiss(animated: true, completion: nil)
            
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            
            
            
            
        }
    }
    
    
    
    @IBOutlet weak var home: UIToolbar!
    //@IBOutlet weak var fb_email: UILabel!
    //@IBOutlet weak var fb_username: UILabel!
    

        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //if let currentUser = FIRAuth.auth()?.currentUser {
            //fb_username.text = currentUser.displayName
            //fb_email.text = currentUser.email
        //}
        
        imagePicker.delegate = self
        
        
        let notificationName = Notification.Name("NotificationIdentifier")
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.handleAlert), name: notificationName, object: nil)

        
    }
    func handleAlert(notification: NSNotification) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        
    }
    
    func uploadImage(){
        
        let imageData = UIImagePNGRepresentation(selectedImage.image!)
        
        
        
        
        ImgurUpload.upload(imageData: imageData!, apiKey: "1b9e084d233edbb", completionHandler: { (response) in
            
            
            let test = String(describing:response?.result.value).components(separatedBy: "link = \"")[1].components(separatedBy: "\";")[0]
            print("EOR")
            print(type(of:response))
            print(test)
            print("uploadfinish")
            
            let notificationName = Notification.Name("NotificationIdentifier")
            NotificationCenter.default.post(name: notificationName, object: nil)
            var imgurlid=test.components(separatedBy: ".com/")[1]

            //dismiss(false, completion: nil)
            let cur_user = FIRAuth.auth()?.currentUser?.email
            var requesturl = "https://fbfb-9d93e.appspot.com/addo?userID="+cur_user!+"&imageurl="+test
            print(requesturl)
            Alamofire.request(requesturl).responseJSON { response in
                //print("Request: \(String(describing: response.request))")   // original url request
                //print("Response: \(String(describing: response.response))") // http url response
                //print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
            }
            
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
