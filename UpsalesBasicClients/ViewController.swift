//
//  ViewController.swift
//  UpsalesBasicClients
//
//  Created by NTW-laptop on 09/01/18.
//  Copyright © 2018 NTW - Web Technology. All rights reserved.
//

import UIKit
/**
    Colors are assigned to view references in code as I find it a better practice than to hardcode it in a storyboard (although there are some defined there for ease of storyboard element visualization). Starting from iOS 11 one can use Color Assets, and it'd be the case not for the backwards compability with iOS 10. Colors are declared in a file called Colors.swift inside the common folder.
 **/

class ViewController: UIViewController {

    @IBOutlet var companiesHeaderView: UIView! {
        didSet {
            companiesHeaderView.backgroundColor = UIColor.baseBackground()
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "CompanyView", bundle: nil), forCellReuseIdentifier: "CompanyViewCell")
            tableView.bounces = false
            tableView.separatorStyle = .none
            tableView.tableHeaderView = companiesHeaderView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.baseBackground()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK : UITableViewDataSource method implementation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyViewCell", for: indexPath) as! CompanyView
        cell.backgroundColor = UIColor.white
        
        cell.companyNameLabel.text  = "Label Title"
        cell.userNameLabel.text = "Description"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    
    // MARK : UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableCell(withIdentifier: "CompanyNumberFixedHeader") as! CompanyNumberFixedHeaderView
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Nothing for now
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Nothing for now
    }
}

class CompanyNumberFixedHeaderView : UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numberLabel.textColor = UIColor.sectionHeaderCompanyPeopleNumber()
        backgroundColor = UIColor.baseBackground()
    }
}


