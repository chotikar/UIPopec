
import UIKit
import SwiftR
import CoreData

class ChatViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, NSFetchedResultsControllerDelegate {

    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    var chatHub: Hub!
    var connection: SignalR!
    var roomCode : String!
    var lang = CRUDSettingValue.GetUserSetting()
    let ws = WebService.self
    let fm = FunctionMutual.self
    let dc = CRUDDepartmentMessage.self
    let loginInfor = CRUDProfileDevice.GetUserProfile()
    var departmentEntity: DepartmentEntity? {
        didSet {
            navigationItem.title = departmentEntity?.programNameEn
        }
    }
    
    lazy var fetchResultController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MessageEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "department.roomCode = %@", self.departmentEntity!.roomCode!)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    var blockOperation = [BlockOperation()]
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            blockOperation.append(BlockOperation(block: {
                self.collectionView?.insertItems(at: [newIndexPath!])
            }))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates({
            for operation in self.blockOperation {
                operation.start()
            }
        }, completion: { finished in
            self.ScrollDisplaylogToBottom()
        })
    }
    
    let cellId = "chatItemCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchResultController.performFetch()
        } catch let err {
            print(err)
        }
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
        collectionView?.register(ChatLogCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        SetupKeyboardObserver()
        SetupConnection()
    }

    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor  = UIColor.white
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(SentMessage), for: .touchUpInside)
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchResultController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogCell
        let log = fetchResultController.object(at: indexPath) as! MessageEntity
        cell.textView.text = log.text
        cell.textView.text = log.text
        cell.chatTime.text = SetDateFormatter(date: (log.date)!)
        cell.profileImageView.image = UIImage(named: (log.department?.programAbb!)!)
        cell.bubbleWidthAnchor?.constant = fm.calculateHeiFromString(text: (log.text)!, fontsize: 13, tbWid: 200).width + 28
        SetupCell(cell: cell, who: log.sendBy)
//        log.read = 1
//        SaveMessageRead()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var heigh : CGFloat = 80
        let log = fetchResultController.object(at: indexPath) as! MessageEntity
        heigh = fm.calculateHeiFromString(text: log.text!, fontsize: 13, tbWid: 200).height + 20;
        return CGSize(width: view.frame.width, height: heigh)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func SetupCell(cell: ChatLogCell,who: Int16){
        if who == 0 {
            //outcome message blue
            cell.profileImageView.isHidden = true
            cell.textView.textColor = UIColor.white
            cell.bubbleView.backgroundColor = UIColor(red: 0/225, green: 137/225, blue: 249/225, alpha: 1)
            
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
            cell.chatTime.textAlignment = .right
            cell.timeRight?.isActive = true
            cell.timeLeft?.isActive = false
        }else{
            //income message gray
            cell.profileImageView.isHidden = false
            cell.textView.textColor = UIColor.darkText
            cell.bubbleView.backgroundColor = UIColor(red: 200/225, green: 200/225, blue: 200/225, alpha: 1)
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
            cell.chatTime.textAlignment = .left
            cell.timeRight?.isActive = false
            cell.timeLeft?.isActive = true
        }
    }
    
    func KeyboardNotification(notification: NSNotification){
        if notification.userInfo != nil {
            let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect
            let keyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            let  keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]) as! Double
            containerViewBottomAnchor?.constant = keyboardShowing ? -(keyboardFrame?.height)! : 0
            UIView.animate(withDuration:  keyboardDuration, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.ScrollDisplaylogToBottom()
            })
        }
    }
    
    func SetupKeyboardObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(HandleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    func HandleKeyboardDidShow(){
        let size = (departmentEntity?.message?.count)!
        if size > 0 {
            let indexPath = NSIndexPath(item: size - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    var containerViewBottomAnchor : NSLayoutConstraint?
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func JoinGroup(userid: Int64, facid: String, proId: String) {
        if let hub = chatHub {
            do {
                try hub.invoke("joinRoom", arguments: [userid,facid,proId])
            } catch {
                print(error)
            }
        }
        
    }
    
    func SentMessage() {
        if let hub = chatHub, let message = inputTextField.text {
            do {
                if message != "" || message != nil {
                    try hub.invoke("sent", arguments: [self.departmentEntity?.roomCode ?? "", 0, loginInfor.userId, message])
                    inputTextField.text = ""
                }
            } catch {
                print(error)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SentMessage()
        return true
    }
    
    func SetupConnection(){
        connection = SignalR(ws.domainName)
        print(ws.domainName)
        connection.useWKWebView = true
        connection.signalRVersion = .v2_2_0
        chatHub = Hub("simpleHub")
        chatHub.on("broadcastMessage") { [weak self] args in
            if let log = args?[0] as? [String:AnyObject] {
                self?.dc.CreateMessageWithText(textInfo: log as AnyObject, department: (self?.departmentEntity!)!)
            }
        }
        connection.addHub(chatHub)
        connection.starting = { [weak self] in
            print("Starting...")
        }
        connection.reconnecting = { [weak self] in
            print("Reconnecting...")
        }
        connection.connected = { [weak self] in
            print("Connected")
            self?.JoinGroup(userid: (self?.loginInfor.userId)!, facid: (self?.departmentEntity?.facultyId)!, proId: (self?.departmentEntity?.programId)!)
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
    }
    
    func ScrollDisplaylogToBottom(){
        let size = self.fetchResultController.sections?[0].numberOfObjects
        if size! > 0 {
            let indexPath = NSIndexPath(item: size! - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
        }
        print("Scroll Display Log To Bottom")
    }
    
    func CreateMessageWithText(textInfo: AnyObject, department: DepartmentEntity) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let chatLog = NSEntityDescription.insertNewObject(forEntityName: "MessageEntity", into: context) as! MessageEntity
        chatLog.department = department
        chatLog.date = NSDate()
        chatLog.sendBy = textInfo["Sendby"] as! Int16
        chatLog.text = String(textInfo["Message"] as! String)
//        chatLog.read = 0
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        self.collectionView?.reloadData()
        let indexPath = NSIndexPath(item: (department.message?.count)! - 1, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: false)
    }
    
    func SaveMessageRead(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let chatLog = NSEntityDescription.insertNewObject(forEntityName: "MessageEntity", into: context) as! MessageEntity
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    func SetDateFormatter(date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        return dateFormatter.string(from: date as Date)
    }
}
