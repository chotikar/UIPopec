import UIKit
import SwiftR

class ChatLogTableViewController: UIViewController , UITableViewDelegate , UITableViewDataSource ,UITextFieldDelegate{
    
    let ws = WebService.self
    let fm = FunctionMutual.self
    var chatLogDisplay : UITableView!
    var facInfor : MessageModel!
    var chatLog = [ChatLogModel]()
    var ownerName = CRUDProfileDevice.GetUserProfile()
    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    let reuseIdentifier = "ChatLogTableViewCell"
    lazy var inputContainerView:UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor  = UIColor.white
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sentMessage), for: .touchUpInside)
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
    
    
    ////// CHAT //////
    var chatHub: Hub!
    var connection: SignalR!
    var roomCode : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatLogDisplay = UITableView(frame: CGRect(x: 0, y: 0, width: scWid, height: scHei-50))
        chatLogDisplay.delegate = self
        chatLogDisplay.dataSource = self
        chatLogDisplay.separatorColor = UIColor.clear
        self.view.addSubview(chatLogDisplay)
        chatLogDisplay.alwaysBounceVertical = true
        chatLogDisplay.register(ChatLogTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        chatLogDisplay.keyboardDismissMode = .interactive
        chatLogDisplay.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        connection = SignalR("http://www.supanattoy.com:89")
        connection.useWKWebView = true
        connection.signalRVersion = .v2_2_0
        
        chatHub = Hub("simpleHub")
        chatHub.on("broadcastMessage") { [weak self] args in
            if let log = args?[0] as? [String:AnyObject] {
                self?.chatLog.append(ChatLogModel(dic: log as AnyObject))
                self?.chatLogDisplay.reloadData()
            }
        }
        
        connection.addHub(chatHub)
        
        // SignalR events
        
        connection.starting = { [weak self] in
            self?.title = "Starting..."
        }
        
        connection.reconnecting = { [weak self] in
            self?.title  = "Reconnecting..."
        }
        
        connection.connected = { [weak self] in
            //print("Connection ID: \(self!.connection.connectionID!)")
            
            self?.joinGroup(userid: (self?.ownerName.userId)!, facid: (self?.facInfor.facId)!, proId: (self?.facInfor.programId)!)
            self?.title  = "Connected"
        }
        
        connection.reconnected = { [weak self] in
            self?.title  = "Reconnected. Connection ID: \(self!.connection.connectionID!)"
        }
        
        connection.disconnected = { [weak self] in
            self?.title  = "Disconnected"
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func  setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
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
    
    var containierViewBottomAnchor : NSLayoutConstraint?
    
    func joinGroup(userid:Int64, facid:Int64, proId :Int64) {
        if let hub = chatHub {
            do {
                try hub.invoke("joinRoom", arguments: [userid,facid,proId])
            } catch {
                print(error)
            }
        }
        
    }
    
    func sentMessage() {
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
    
    func setupCell(cell:ChatLogTableViewCell,who:Int){
        
        if who == 0 {
            //outcome message blue
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
        }else{
            //income message gray
            cell.profileImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.lightGray
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatLog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChatLogTableViewCell
        cell.selectionStyle = .none
        let log = chatLog[indexPath.row]
        
        cell.textView.text = log.mess
        cell.bubbleWidthAnchor?.constant = fm.calculateHeiFromString(text: log.mess, fontsize: fm.setFontSizeLight(fs: 14), tbWid: scWid*0.3).width + 10
        setupCell(cell: cell, who: log.sendby)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        var heigh : CGFloat = 80
        let message = chatLog[indexPath.row]
        heigh = fm.calculateHeiFromString(text: message.mess, fontsize: fm.setFontSizeLight(fs: 14), tbWid: scWid).height + 34
        return  heigh
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        connection.stop()
    }
    
}








