//
//  DetailViewController.swift
//  VeriStocks
//
//  Created by f4ni on 14.05.2021.
//

import Charts
import SnapKit

class DetailViewController: UIViewController, ChartViewDelegate {
    
    var mainViewController: MainViewController!
    
    lazy var lineChart: LineChartView = {

        let c = LineChartView()

        c.backgroundColor = .lightGray.withAlphaComponent(0.1)

        c.snp.makeConstraints { mk in
            mk.height.equalTo(300)
        }
        
        return c
    }()
    
    var stock: StockViewModel!
    {
        didSet{
            self.symbolLabel.text    = "Sembol: " + stock.symbol
            self.priceLabel.text     = "Fiyat:  " + stock.price
            self.differenceLabel.text = "Fark:  " + stock.difference
            self.volumeLabel.text    = "Hacim:  " + stock.volume
            self.bidLabel.text       = "Alış:   " + stock.bid
            self.offerLabel.text     = "Satış:  " + stock.offer
            self.changeLabel.text    = "Değişim:    " + stock.change
            self.lowestLabel.text    = "Günlük Düşük:   " + stock.lowest
            self.highestLabel.text   = "Günlük Yüksek:  " + stock.highest
            self.countLabel.text     = "Adet:   " + stock.count
            self.maximumLabel.text   = "Tavan:  " + stock.maximum
            self.minimumLabel.text   = "Taban:  " + stock.minimum
        }
    }
    
    var symbolLabel = UILabel()
    var priceLabel = UILabel()
    var differenceLabel = UILabel()
    var volumeLabel = UILabel()
    var bidLabel = UILabel()
    var offerLabel = UILabel()
    var changeLabel = UILabel()
    var lowestLabel = UILabel()
    var highestLabel = UILabel()
    var maximumLabel = UILabel()
    var minimumLabel = UILabel()
    var countLabel = UILabel()
    
    lazy var labelStack: UIStackView = {
        
        var views = [symbolLabel, lowestLabel, priceLabel, highestLabel, differenceLabel, countLabel, volumeLabel, maximumLabel, bidLabel, minimumLabel, offerLabel, changeLabel]
        
        var sv = UIStackView(arrangedSubviews: views).gridStackSubs(spacing: 30, column: 2)
        
        sv.sizeToFit()
        sv.axis = .vertical
        sv.spacing = 10
        
        //views = views.map({ return $0.setLabel() })
        
        return sv
    }()
    
    lazy var mainStack: UIStackView = {
        
        var views = [labelStack, lineChart]
        
        var sv = UIStackView(arrangedSubviews: views)
        
        sv.alignment = .fill
        sv.axis = .vertical
        sv.spacing = 30
        
        //views = views.map({ return $0.setLabel() })
        
        return sv
    }()
    
    override func viewDidLoad() {
        setupViews()

    }
    
    func setupViews() {
        navigationController?.navigationBar.backgroundColor = .red
        view.backgroundColor = .white
    
        setupMainStackView()
        
        setupChartView()
    }
    
    func setupMainStackView(){
        view.addSubview(mainStack)
        
        mainStack.snp.makeConstraints { mk in
            mk.left.equalToSuperview().offset(10)
            mk.right.equalToSuperview().offset(-10)
            mk.top.equalToSuperview().offset(120).priorityRequired()
        }
        
    }

    func setupChartView(){
                
        var graphData = [ChartDataEntry]()
        
        for i in stock.graphicData! {
            
            graphData.append(ChartDataEntry(x: Double(i.day ?? 0), y: Double(i.value ?? 0)))
            
        }
        
        let set = LineChartDataSet(entries: graphData, label: "Geçmiş")
        
        let data = LineChartData(dataSet: set)
        
        self.lineChart.data = data
    }
    
}

