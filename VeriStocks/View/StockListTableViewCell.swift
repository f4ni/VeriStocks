//
//  StockListTableViewCell.swift
//  VeriStocks
//
//  Created by f4ni on 14.05.2021.
//

import SnapKit

class StockListTableViewCell: UITableViewCell {
    
    var stock: StockViewModel! {
        didSet{
        
            self.symbolLabel.text = stock!.symbol
            self.priceLabel.text = stock!.price
            self.differenceLabel.text = stock!.difference
            self.volumeLabel.text = stock!.volume
            self.bidLabel.text = stock!.bid
            self.offerLabel.text = stock!.offer
            self.changeLabel.text = stock!.change

        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        self.addSubview(stackView)
        
        self.adjustConstraits()
    }
    
    func adjustConstraits() {
    
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
    
    }
    
    lazy var stackView: UIStackView = {
        var views = [symbolLabel, priceLabel, differenceLabel, volumeLabel, bidLabel, offerLabel, changeLabel]
        views = views.map({   return $0.setLabelinTable() })
        
        let sv = UIStackView(arrangedSubviews: views)
        sv.alignment = .fill
        
        return sv
    }()

    
    let symbolLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 14)
        return l
    }()
    
    let priceLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    let differenceLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    let volumeLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    let bidLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    let offerLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    let changeLabel: UILabel = {
        let l = UILabel()
        return l
    }()
}
