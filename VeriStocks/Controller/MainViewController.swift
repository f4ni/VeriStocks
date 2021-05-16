//
//  ViewController.swift
//  VeriStocks
//
//  Created by f4ni on 13.05.2021.
//


import SideMenu
import SnapKit

class MainViewController: UITableViewController, UISearchResultsUpdating {
  
    fileprivate let tVCellId = "tVCellId"
    
    var stockViewModel = [StockViewModel]() {
        didSet{
          
        }
    }
    
    var stocksFilterable = [StockViewModel]()
    
    let search = UISearchController(searchResultsController: nil)
    
    lazy var refreshC: UIRefreshControl = {
        let c = UIRefreshControl()
        
        return c
    }()
    
    let sideMenuController = SideMenuViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = "IMKB Hisse ve Endeksler"

        tableView.register(StockListTableViewCell.self, forCellReuseIdentifier: tVCellId)
        tableView.addSubview( self.refreshC )
        
        refreshC.addTarget(self, action: #selector(refreshHandle), for: .valueChanged)
        fetchStocks()
        setupSearchBar()
        setupSideMenu()

    }
    
    @objc func openSideMenu(){
        let vc = SideMenuViewController()
        vc.mainViewController = self
        let menu = SideMenuNavigationController(rootViewController: vc)
        menu.leftSide = true
        menu.navigationBar.isHidden = true
        present(menu, animated: true, completion: nil)
    }
    
    func setupSideMenu() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "MENU", style: .done, target: self, action: #selector(openSideMenu))
        
        sideMenuController.mainViewController = self

    }
    
    func setupSearchBar() {
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Hisse ve Endeks ara"
        search.searchBar.tintColor = .black
        search.searchBar.barTintColor = .white
        search.searchBar.backgroundColor = .white
        navigationItem.searchController = search
        

    }

    func fetchStocks(period: String = "all"){
        APIService.instance.fetchStocks(type: period) { response in
            switch response {
            case .success(let data):
                if let sBundle = data as? StockBundle, let stocks = sBundle.stocks {
                    let stocksVM = stocks.map( { return StockViewModel(stock: $0 ) })
                    self.stockViewModel = stocksVM
                    self.stocksFilterable = stocksVM
                    self.tableView.reloadData()
                    self.tableView.endUpdates()
                }
                break
                
            case .failure(_):
                
                break
            }
        }
    }
    
    
    @objc func refreshHandle() {
        refreshC.beginRefreshing()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        if text.count == 0 {
            stocksFilterable = stockViewModel
        }
        else {
            stocksFilterable =  stockViewModel.filter { (dataStr: StockViewModel) -> Bool in
                return dataStr.symbol.lowercased().contains(text.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tVCellId", for: indexPath) as! StockListTableViewCell
        
        let stock = stocksFilterable[indexPath.row]
        
        if indexPath.row % 2 != 0 {
            cell.backgroundColor = .white
        }
        else{
            cell.backgroundColor = .lightGray.withAlphaComponent(0.1)
        }
    
        cell.stock = stock
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if !self.stocksFilterable.isEmpty {
            count = self.stocksFilterable.count
        }

        return count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let detailVC = DetailViewController()

        let id = stocksFilterable[indexPath.row].id
        APIService.instance.fetchStockDetail(id: id) { response in
            switch response {
            
            case .success(let data):
                if let sBundle = data as? Stock {
                    let stock =  StockViewModel(stock: sBundle )
    
                    detailVC.stock = stock
                    detailVC.mainViewController = self
                    
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            case .failure(_):
                debugPrint("failed to fetch stock detail")
            }
        }
            
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == stocksFilterable.count - 1 {
            self.updateSearchResults(for: self.search)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Sembol  Fiyat   Fark    Hacim   Alış    Satış   Değişim"
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let label = UILabel()
        
        //label.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        label.adjustsFontSizeToFitWidth = true

        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.addSubview(label)
        
        label.snp.makeConstraints { mk in
            mk.leftMargin.equalTo(10)
            mk.rightMargin.equalTo(10)
            mk.centerY.equalToSuperview()
            
        }

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
}

private extension UISearchBar {
    private func setBackgroundColorWithImage(color: UIColor) {
        let rect = self.bounds
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect);

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.backgroundImage = image // here!
    }
}
