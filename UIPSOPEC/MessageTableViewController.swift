
import UIKit
import SWRevealViewController

class MessageTableViewController: UITableViewController {


    @IBOutlet weak var MenuButton: UIBarButtonItem!

    var profileDevice : UserLogInDetail!
    var facList = [MessageModel]()
    let tableCellCode = "cellId"
    
    let scHei = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Sidemenu()
        CustomNavbar()
        tableView.register(UserCell.self, forCellReuseIdentifier: tableCellCode)
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellCode, for: indexPath)
        cell.textLabel?.text = "Dummy message"
        cell.detailTextLabel?.text = "Detail dummy messagekllllksdkwkenxmewkdojwememopdkeopkdpwokeod"
        cell.detailTextLabel?.textColor = UIColor.darkGray
//        cell.imageView?.loadImageUsingCacheWithUrlString(urlStr: "http://static1.squarespace.com/static/525f350ee4b0fd74e5ba0495/t/53314e2be4b00782251d9427/1481141044684/?format=1500w")
        cell.imageView?.contentMode = .scaleAspectFill
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (scHei * 0.11)
    }
    
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatLogController = ChatLogCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.roomCode = "1234"
        navigationController?.pushViewController(chatLogController, animated: true)
//                        let vc = ChatLogCollectionViewController()
//                self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func Sidemenu() {
        if revealViewController() != nil {
            MenuButton.target = SWRevealViewController()
            MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func CustomNavbar() {
        navigationController?.navigationBar.barTintColor = UIColor.red
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//class UserCell : UITableViewCell {
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        textLabel?.frame = CGRect(x:  56, y: (textLabel!.frame.origin.y - 2), width: (textLabel!.frame.width), height: (textLabel!.frame.height))
//        detailTextLabel?.frame = CGRect(x: 56, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
//    }
//
//    let profileImageView : UIImageView = {
//        let piv = UIImageView()
////        piv.image = (UIImage(named: "User_Shield"))
//        piv.contentMode = .scaleAspectFill
//        piv.translatesAutoresizingMaskIntoConstraints = false
//        piv.layer.cornerRadius = 20
//        piv.layer.masksToBounds = true
//        piv.backgroundColor = UIColor.brown
//        return piv
//    }()
//    
//    override init(style: UITableViewCellStyle, reuseIdentifier:String?){
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//        addSubview(profileImageView)
//        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
//        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
//    }
//    
//    required init?(coder aDecorder : NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //    override func layoutSubviews() {
//    //        super.layoutSubviews()
//    //    }
//    //  profileImageView.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei*0.1)
//    ////        name.textAlignment = .center
//    ////        name.font = fm.setFontSizeLight(fs: 20)
//    ////        name.textColor = UIColor.darkGray
//    //    }
//    //    let picUser : UIImageView = {
//    //       let pu = UIImageView()
//    //        pu.frame = CGRect(x: 0, y:0, width: sWid*0.3, height: sWid*0.3)
//    //        pu.image = UIImage(cgImage: "User_Shield" as! CGImage)
//    //
//    //        return pu
//    //    }()
//    
//    //    let titleLabel: UITextView = {
//    //        let tl = UITextView()
//    //        tl.font = UIFont.systemFont(ofSize: 16)
//    //        tl.textColor = UIColor.black
//    //        tl.textAlignment = .left
//    //       return tl
//    //    }()
//    //
//    //    let subtitleLabel : UITextView = {
//    //       let sl = UITextView()
//    //        sl.font = UIFont.systemFont(ofSize: 12)
//    //        sl.textColor = UIColor.black
//    //        sl.textAlignment = .left
//    //        return sl
//    //    }()
//
//}



