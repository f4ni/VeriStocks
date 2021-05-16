//
//  SideMenuViewController.swift
//  VeriStocks
//
//  Created by f4ni on 15.05.2021.
//

import SnapKit
import Kingfisher

class SideMenuViewController: UITableViewController {
    
    var mainViewController: MainViewController!
    
    let menuItems = ["all": "IMKB Hisse ve Endeksler", "increasing": "Yükselenler", "decreasing": "Düşenler", "volume30": "IMKB 30", "volume50": "IMKB 50", "volume100": "IMKB 100" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.tableFooterView = UIView()
        setupTableViewHeader()
        
    }
    func setupTableViewHeader(){
        
        let placeholder = UIImage(imageLiteralResourceName: "stocks")

        let iView = UIImageView(image: placeholder)
        iView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        iView.contentMode = .scaleAspectFit
        
        let imgUrl = URL(string: StaticModel.sideMenuHeaderImageUrl)
        iView.kf.setImage(with: imgUrl, placeholder: placeholder, options: [.transition(.fade(0.1))])
        
        tableView.tableHeaderView = iView
       
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = Array(menuItems)[indexPath.row].value
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = Array(menuItems)[indexPath.row]
        mainViewController.navigationItem.title = item.value
        mainViewController.fetchStocks(period: item.key)
        tableView.cellForRow(at: indexPath)?.isSelected = false
        self.dismiss(animated: true, completion: nil)
    }
    
}
