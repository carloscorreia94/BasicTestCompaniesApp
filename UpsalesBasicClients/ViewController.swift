//
//  ViewController.swift
//  UpsalesBasicClients
//
//  Created by NTW-laptop on 09/01/18.
//  Copyright © 2018 NTW - Web Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

/**
    Colors are assigned to view references in code as I find it a better practice than to hardcode it in a storyboard (although there are some defined there for ease of storyboard element visualization). Starting from iOS 11 one can use Color Assets, and it'd be the case not for the backwards compability with iOS 10. Colors are declared in a file called Colors.swift inside the common folder.
 **/

typealias Pagination = (limit: Int, offset: Int)

class ViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate let baseUrl = "https://integration.upsales.com/api/v2/accounts?token=fab2dd8eb69dcdc3d108c7e7bfa6c4932fe69b06ba4cfe4c8cebe45d08a5b0a2&limit=%d&offset=%d"
    fileprivate var network : CoreNetwork!
    fileprivate var companies : [Company]?
    fileprivate var pagination = Pagination(10,0)
    fileprivate var totalCount = 0
    fileprivate var downloadingNetworkData = true
    
    @IBOutlet var companiesHeaderView: UIView! {
        didSet {
            companiesHeaderView.backgroundColor = UIColor.baseBackground()
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "CompanyView", bundle: nil), forCellReuseIdentifier: "CompanyViewCell")
            tableView.separatorStyle = .none
            tableView.tableHeaderView = companiesHeaderView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.beginInfiniteScroll(true)
        
        view.backgroundColor = UIColor.baseBackground()
        network = CoreNetwork(vController: self, url: String(format: baseUrl, pagination.limit, pagination.offset), success: successLoading, in_error:
            { error in
                
            self.downloadingNetworkData = false
            self.tableView.finishInfiniteScroll()
                
                
            })
        network.fetchData()
        
    }

    func successLoading(json: JSON) {
        
        if json["data"].array != nil && json["data"].arrayValue.count > 0 && json["metadata"].exists() {
            
            var companies = [Company]()
            
            for company in json["data"].arrayValue {
                if let company = CompanyView.createCompany(company) {
                    companies.append(company)
                }
            }
            
            //If we have actual valid elements
            if companies.count > 0 {
                
                //the actual elements presented on the list might not sum up to the total count in case required properties of the serialized content aren't present and are therefore thrown away (from the createCompany invocation above)
                totalCount = json["metadata"]["total"].int ?? 0
                
                if pagination.offset >= pagination.limit {
                    self.companies?.append(contentsOf: companies)
                } else {
                    self.companies = companies
                }
                
                //sort elements by name ascending (I couldn't find anything  in the documentation to this directly from the network request)
                self.companies?.sort(by: { $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending })

                self.tableView.reloadData()
            }
            
        }
        
        downloadingNetworkData = false
        self.tableView.finishInfiniteScroll()
        

    }
    

}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK : UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyViewCell", for: indexPath) as! CompanyView
        cell.backgroundColor = UIColor.white
        
        //there's never a nil scenario here
        cell.companyNameLabel.text  = companies![indexPath.row].name
        cell.userNameLabel.text = companies![indexPath.row].user
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies?.count ?? 0
    }
    
    
    // MARK : UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableCell(withIdentifier: "CompanyNumberFixedHeader") as! CompanyNumberFixedHeaderView
        header.numberLabel.text = "\(totalCount) companies"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25

    }
    
    
    // MARK : ScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y<=0) {
            scrollView.contentOffset = CGPoint.zero
        }
        
        if downloadingNetworkData {
            return
        }
        
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if pagination.offset < totalCount {
                pagination = Pagination(10, pagination.offset + 10)
                network?.url = String(format: baseUrl, pagination.limit, pagination.offset)
                
                downloadingNetworkData = true
                self.tableView.beginInfiniteScroll(true)
                
                network?.fetchData()
            }
            
        }
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


