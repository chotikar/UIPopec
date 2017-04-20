



import UIKit
import SwiftR

private let reuseIdentifier = "Cell"

class ChatLogCollectionViewController: UICollectionViewController,UITextFieldDelegate ,UICollectionViewDelegateFlowLayout {
    
    let fm = FunctionMutual.self
    var chatLog = [ChatLog]()
    var ownerName = "Pop"
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
    
    
    ////// CHAT //////
    var chatHub: Hub!
    var connection: SignalR!
    var roomCode : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView!)
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        self.collectionView!.register(ChatMessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.backgroundColor = UIColor.white
        
        connection = SignalR("http://www.supanattoy.com:89")
        connection.useWKWebView = true
        connection.signalRVersion = .v2_2_0
        
        
        
        chatHub = Hub("simpleHub")
        chatHub.on("broadcastMessage") { [weak self] args in
            if let namee = args?[0] as? String, let message = args?[1] as? String {
                self?.chatLog.append(ChatLog(name: namee, text: message))
            print(" \(self?.chatLog))")
                self?.collectionView?.reloadData()
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
            print("Connection ID: \(self!.connection.connectionID!)")
            self?.joinGroup(roomcode: (self?.roomCode)!)
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
    
    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containierViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        containierViewBottomAnchor?.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(ChatLogCollectionViewController.sentMessage), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant:8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo:sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let seperateLineView = UIView()
        seperateLineView.backgroundColor = UIColor.black
        seperateLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperateLineView)
        
        seperateLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperateLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperateLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperateLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func joinGroup(roomcode:String){
        if let hub = chatHub {
            do {
                try hub.invoke("joinRoom", arguments: [roomcode])
            } catch {
                print(error)
            }
        }
        
    }
    
    func sentMessage(){
        if let hub = chatHub, let message = inputTextField.text {
            do {
                try hub.invoke("sent", arguments: [self.roomCode,ownerName,message])
            } catch {
                print(error)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatLog.count
    }
    //
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatMessageCell
        let message = chatLog[indexPath.item]
        
        cell.textView.text = message.text
        cell.bubbleWidthAnchor?.constant = fm.calculateHeiFromString(text: message.text, fontsize: fm.setFontSizeLight(fs: 14), tbWid: scWid*0.3).width + 10
        
        setupCell(cell: cell, who: message.name)
        
        return cell
        
    }
    
    func setupCell(cell:ChatMessageCell,who:String){
        
        if who == self.ownerName {
            //outcome message blue
            //            cell.bubbleView.backgroundColor  = UIColor.orange
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
        }else{
            //income message gray
            cell.profileImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.red//UIColor(red: 240, green: 240, blue: 240, alpha: 1)
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        connection.stop()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var heigh : CGFloat = 80
        
        let message = chatLog[indexPath.item]
        heigh = fm.calculateHeiFromString(text: message.text, fontsize: fm.setFontSizeLight(fs: 14), tbWid: scWid).height + 20
        
        return CGSize(width: view.frame.width+20, height: heigh)
    }
    
}




















//
//
//import UIKit
//
//private let reuseIdentifier = "Cell"
//
//class ChatLogCollectionViewController: UICollectionViewController,UITextFieldDelegate ,UICollectionViewDelegateFlowLayout{
//
//    let fm = FunctionMutual.self
//
//    lazy var inputTextField : UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Enter message..."
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.delegate = self
//        return textField
//    }()
//
//    lazy var inputContainerView:UIView = {
//        let containerView = UIView()
//        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
//        containerView.backgroundColor  = UIColor.white
//
//
//        let sendButton = UIButton(type: .system)
//        sendButton.setTitle("Send", for: .normal)
//        sendButton.addTarget(self, action: #selector(ChatLogCollectionViewController.sentMessage), for: .touchUpInside)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(sendButton)
//
//        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//
//        containerView.addSubview(self.inputTextField)
//
//        self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant:8).isActive = true
//        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        self.inputTextField.rightAnchor.constraint(equalTo:sendButton.leftAnchor).isActive = true
//        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//
//        let seperateLineView = UIView()
//        seperateLineView.backgroundColor = UIColor.black
//        seperateLineView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(seperateLineView)
//
//        seperateLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        seperateLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        seperateLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//        seperateLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//
//        return containerView
//    }()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.addSubview(collectionView!)
//        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        collectionView?.alwaysBounceVertical = true
//        self.collectionView!.register(ChatMessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        collectionView?.keyboardDismissMode = .interactive
////        setupInputComponents()
////        setupKeyboardObserver()
//
//    }
//
//    override var inputAccessoryView: UIView? {
//        get {
//            return inputContainerView
//        }
//    }
//
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
//
//    func  setupKeyboardObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    func handleKeyboardWillShow(notification: NSNotification) {
//        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
//        let  keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]) as! Double
//        containierViewBottomAnchor?.constant = -(keyboardFrame!.height)
//        UIView.animate(withDuration: keyboardDuration){
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    func handleKeyboardWillHide(notification: NSNotification){
//        let  keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]) as! Double
//        containierViewBottomAnchor?.constant = 0
//        UIView.animate(withDuration: keyboardDuration){
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    var containierViewBottomAnchor : NSLayoutConstraint?
//
//    func setupInputComponents(){
//        let containerView = UIView()
//        containerView.backgroundColor = UIColor.white
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(containerView)
//
//        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        containierViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
//        containierViewBottomAnchor?.isActive = true
//        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        let sendButton = UIButton(type: .system)
//        sendButton.setTitle("Send", for: .normal)
//        sendButton.addTarget(self, action: #selector(ChatLogCollectionViewController.sentMessage), for: .touchUpInside)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(sendButton)
//
//        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//
//        containerView.addSubview(inputTextField)
//
//        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant:8).isActive = true
//        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        inputTextField.rightAnchor.constraint(equalTo:sendButton.leftAnchor).isActive = true
//        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//
//        let seperateLineView = UIView()
//        seperateLineView.backgroundColor = UIColor.black
//        seperateLineView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(seperateLineView)
//
//        seperateLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        seperateLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        seperateLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//        seperateLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//    }
//
//    func sentMessage(){
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//    // MARK: UICollectionViewDataSource
//
////    override func numberOfSections(in collectionView: UICollectionView) -> Int {
////        // #warning Incomplete implementation, return the number of sections
////        return 10
////    }
////
////
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
////
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatMessageCell
////        let message = message[indexPath.item]
//
//        cell.textView.text = "mook"
//        cell.bubbleWidthAnchor?.constant = fm.calculateHeiFromString(text: "mook", fontsize: fm.setFontSizeLight(fs: 13), tbWid: scWid*0.3).width + 20
//
//        setupCell(cell: cell, lar: indexPath.row)
//             return cell
//
//    }
//
//    func setupCell(cell:ChatMessageCell,lar:Int){
//        if lar / 2 == 0 {
//            //outcome message blue
//            cell.bubbleView.backgroundColor  = UIColor.orange
//            cell.profileImageView.isHidden = true
//            }else{
//            //income message gray
//            cell.profileImageView.isHidden = false
//            cell.bubbleView.backgroundColor = UIColor.red//UIColor(red: 240, green: 240, blue: 240, alpha: 1)
//            cell.bubbleRightAnchor?.isActive = false
//            cell.bubbleLeftAnchor?.isActive = true
//        }
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var heigh : CGFloat = 80
//        heigh = fm.calculateHeiFromString(text: "Mook", fontsize: fm.setFontSizeLight(fs: 14), tbWid: scWid).height + 20
//        return CGSize(width: view.frame.width, height: heigh)
//    }
//
//    // MARK: UICollectionViewDelegate
//
//    /*
//    // Uncomment this method to specify if the specified item should be highlighted during tracking
//    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    */
//
//    /*
//    // Uncomment this method to specify if the specified item should be selected
//    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    */
//
//    /*
//    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
//        return false
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//    
//    }
//    */
//
//}

