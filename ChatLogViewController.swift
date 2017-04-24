
import UIKit
import SwiftR

class ChatLogViewController: UIViewController,UITextFieldDelegate {
    
    let ws = WebService.self
    let fm = FunctionMutual.self
    var facInfor : MessageModel!
    var activityiIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    var chatLog = [ChatLogModel]()
    var ownerName = CRUDProfileDevice.GetUserProfile()
    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    lazy var inputContainerView:UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor  = UIColor.white
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(ChatLogCollectionViewController.sentMessage), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(self.inputTextField)
        
        self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant:8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo:sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let seperateLineView = UIView()
        seperateLineView.backgroundColor = UIColor.black
        seperateLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperateLineView)
        
        seperateLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperateLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperateLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperateLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
    }()
    
    let cvView = UIView()
    var cvSc = UIScrollView()
    var logFromHub : ChatLogModel!
    var contenthei = CGFloat(20)
    ////// CHAT //////
    var chatHub: Hub!
    var connection: SignalR!
    var roomCode : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(cvView)
        self.view.addSubview(cvSc)
        startIndicator()
        self.title = self.facInfor.programName
        cvView.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
        cvView.backgroundColor = UIColor.white
        cvSc.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        cvSc.frame = CGRect(x: 0, y: 64, width: scWid, height: scHei*0.8)
        cvSc.alwaysBounceVertical = true
        cvSc.keyboardDismissMode = .interactive
        cvSc.contentSize = CGSize(width: scWid, height: scHei)
//        cvSc.setContentOffset(CGPoint(x:0,y:cvSc.contentSize.height), animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        connection = SignalR("http://www.supanattoy.com:89")
        connection.useWKWebView = true
        connection.signalRVersion = .v2_2_0
        
        chatHub = Hub("simpleHub")
        chatHub.on("broadcastMessage") { [weak self] args in
            if let log = args?[0] as? [String:AnyObject] {
                self?.logFromHub = ChatLogModel(dic: log as AnyObject)
                self?.chatLog.append((self?.logFromHub)!)
                self?.logSeperate(logg: (self?.logFromHub.mess)!, sb: (self?.logFromHub.sendby)!)
            }
        }
        
        connection.addHub(chatHub)
        
        // SignalR events
        
        connection.starting = { [weak self] in
            print("Starting...")
        }
        
        connection.reconnecting = { [weak self] in
             print("Reconnecting...")
        }
        
        connection.connected = { [weak self] in
            //print("Connection ID: \(self!.connection.connectionID!)")
            self?.stopIndicator()
            self?.joinGroup(userid: (self?.ownerName.userId)!, facid: (self?.facInfor.facId)!, proId: (self?.facInfor.programId)!)
             print("Connected")
        }
        
        connection.reconnected = { [weak self] in
             print("Reconnected. Connection ID: \(self!.connection.connectionID!)")
        }
        
        connection.disconnected = { [weak self] in
            print("Disconnected")
        }
        
        connection.connectionSlow = { print("Connection slow...") }
        
        connection.error = { [weak self] error in
            print("Error: \(String(describing: error))")
            
            
            if let source = error?["source"] as? String, source == "TimeoutException" {
                print("Connection timed out. Restarting...")
                self?.connection.start()
            }
        }
        
        connection.start()
        
        //        setupInputComponents()
        //        setupKeyboardObserver()
        
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func startIndicator(){
        self.activityiIndicator.center = self.view.center
        self.activityiIndicator.hidesWhenStopped = true
        self.activityiIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityiIndicator)
        activityiIndicator.startAnimating()
    }
    
    func stopIndicator(){
        self.activityiIndicator.stopAnimating()
    }
    
    func  setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    var containierViewBottomAnchor : NSLayoutConstraint?
    
    func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let  keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]) as! Double
        containierViewBottomAnchor?.constant = -(keyboardFrame!.height)
        UIView.animate(withDuration: keyboardDuration){
            self.view.layoutIfNeeded()
        }
    }
    
    func handleKeyboardWillHide(notification: NSNotification){
        let  keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]) as! Double
        containierViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration){
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    func joinGroup(userid:Int64, facid:Int64, proId :Int64){
        if let hub = chatHub {
            do {
                try hub.invoke("joinRoom", arguments: [userid,facid,proId])
            } catch {
                print(error)
            }
        }
        
    }
    
    func sentMessage(){
        if let hub = chatHub, let message = inputTextField.text {
            do {
                if message != ""{
                    try hub.invoke("sent", arguments: [self.facInfor.roomCode,0,ownerName.userId,message])
                    inputTextField.text = ""
                }
            } catch {
                print(error)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       override func viewWillDisappear(_ animated: Bool) {
        connection.stop()
    }
    let blueColor = UIColor(red: 0/225, green: 137/225, blue: 249/225, alpha: 1)
    func logSeperate(logg : String,sb:Int){
        let k = fm.calculateHeiFromString(text: logg, fontsize: fm.setFontSizeLight(fs: 14), tbWid: 200)
        if sb == 0 {
            drawLog(log: logg, profilHid: true, bubBg: blueColor,logHei : k,sendBy:sb)
        }else{
            drawLog(log: logg, profilHid: false, bubBg: UIColor.lightGray, logHei : k,sendBy:sb)
        }
    }
    
    var textView: UITextView!
    var bubbleView: UIView!
    var profileImageView: UIImageView!
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    
    func drawLog(log : String , profilHid:Bool,bubBg: UIColor, logHei :CGRect,sendBy:Int){
        
        profileImageView = UIImageView(frame:  CGRect(x: 8, y: self.contenthei, width: 32, height: 32))
        profileImageView.image = UIImage(named: "User_Shield")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 16
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill

        
        if sendBy == 0 {
            bubbleView = UIView(frame: CGRect(x:scWid - (logHei.width+20) - 8, y: self.contenthei, width: logHei.width+20, height: logHei.height+20))
            profileImageView.isHidden = true
        }else{
            bubbleView = UIView(frame: CGRect(x: 42, y: self.contenthei, width: logHei.width+20, height: logHei.height+20))
        }
        
        bubbleView.sizeThatFits(CGSize(width: logHei.width+20, height: logHei.height+20))
        bubbleView.backgroundColor = bubBg
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.layer.cornerRadius = 16
        bubbleView.layer.masksToBounds = true


        
        textView = UITextView(frame:  CGRect(x: 5, y: 0, width: logHei.width+10, height: logHei.height+20))
        textView.font = fm.setFontSizeLight(fs: 14)
        textView.text = log
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clear
        textView.isScrollEnabled = false
        textView.isEditable = false

            //UIView(frame: CGRect(x: 42, y: self.contenthei, width: logHei.width+20, height: logHei.height+20))
            
        
        //
        
                bubbleView.frame.origin.y = self.contenthei
        bubbleView.addSubview(textView)
        
        self.contenthei = self.contenthei + logHei.height + 40
        self.cvSc.contentSize = CGSize(width: scWid, height: self.contenthei)
        self.cvSc.addSubview(bubbleView)
        self.cvSc.addSubview(profileImageView)
        self.cvSc.setNeedsDisplay()
        //self.cvSc.setContentOffset(CGPoint(x:0,y:cvSc.contentSize.height*0.8), animated: true)

    }
    
    
}

