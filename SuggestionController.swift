

import Foundation
import UIKit

class SuggestionTableViewController : UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
     @IBOutlet weak var FacSuggestTableView: UITableView!
//    var suggestProgram :[]()
    let facSuggestId = "facSugCellID"
    
    let titleButton : UIButton = {
        let tb = UIButton(type: .custom)
        tb.setTitle("Suggestion", for: .normal)
        tb.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = titleButton
         navigationController?.navigationBar.barTintColor = UIColor.red
        drawSuggestionFac()
        FacSuggestTableView.register(UITableViewCell.self, forCellReuseIdentifier: facSuggestId)
        FacSuggestTableView.tag = 1
        

    }
    
    func drawSuggestionFac(){
        self.view.addSubview(FacSuggestTableView)
        FacSuggestTableView.frame = CGRect(x: 0, y: 0, width: scWid, height: scHei)
//        FacSuggestTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        FacSuggestTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        FacSuggestTableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        FacSuggestTableView.backgroundColor  = UIColor.yellow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: facSuggestId, for: indexPath)
        cell.textLabel?.text = "Dummy message"
        cell.detailTextLabel?.textColor = UIColor.darkGray
        cell.imageView?.image = UIImage(named: "User_Shield")
       // cell.imageView?.loadImageUsingCacheWithUrlString(urlStr: "http://static1.squarespace.com/static/525f350ee4b0fd74e5ba0495/t/53314e2be4b00782251d9427/1481141044684/?format=1500w")
        cell.imageView?.contentMode = .scaleAspectFill
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return scHei*0.15
    }
    
    func buttonPressed(button: UIButton) {
        
        print("Click")
        
    }

}
