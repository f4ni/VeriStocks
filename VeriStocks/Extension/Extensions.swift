//
//  extensions.swift
//  VeriStocks
//
//  Created by f4ni on 14.05.2021.
//

import CryptoSwift

extension String {
    
    func AESEncryptWithBase64(keyBase64: String, ivBase64: String) -> String? {
        let key = [UInt8](base64: keyBase64)

        let iv = [UInt8](base64: ivBase64)

        let aes = try? AES(key: key, blockMode: CBC(iv: iv))
        
        let cipherText = try? aes?.encrypt(Array(self.utf8))
        
        return cipherText?.toBase64()
    }
    
    func AESDecryptWithBase64(keyBase64: String, ivBase64: String) -> String? {
        let key = [UInt8](base64: keyBase64)

        let iv = [UInt8](base64: ivBase64)
        
        let aes = try? AES(key: key, blockMode: CBC(iv: iv) )
        
        guard let decryptedText = try? aes?.decrypt(Array(base64: self)),
              let target = String(bytes: decryptedText, encoding: .utf8)
        else { return nil }
        
        return target
    }

}

extension UILabel {
    func setLabelinTable() -> UILabel {
        self.numberOfLines = 1
        self.lineBreakMode = .byWordWrapping
        self.font = UIFont.systemFont(ofSize: 14)
        self.snp.makeConstraints { make in
            let width = UIScreen.main.bounds.width
            make.width.equalTo( width / 7)
        }
        return self
    }

    func setDetailLabels() -> UILabel {
        self.numberOfLines = 1
        self.lineBreakMode = .byWordWrapping
        self.font = UIFont.systemFont(ofSize: 16)
        self.snp.makeConstraints { make in
            let width = UIScreen.main.bounds.width
            make.width.equalTo( width / 2)
            
        }
        return self
    }
}

extension UIStackView {
    func gridStackSubs(spacing: CGFloat, column: Int) -> UIStackView {
        
        let subviews = self.arrangedSubviews
        
        let tmpStackV = UIStackView()
        tmpStackV.axis = .vertical
        
        var stacVCell = UIStackView()
        
        for i in 0 ... (subviews.count - 1) {
            
            stacVCell.axis = .horizontal
            stacVCell.addArrangedSubview(subviews[i])
            stacVCell.spacing = spacing
            stacVCell.distribution = .fillEqually
            
            if i % column == 1 {
                tmpStackV.addArrangedSubview(stacVCell)
                stacVCell = UIStackView()
            }
        }
        
        return tmpStackV
    }
}


extension UIApplication {
var statusBarUIView: UIView? {

    if #available(iOS 13.0, *) {
        let tag = 3848245

        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first

        if let statusBar = keyWindow?.viewWithTag(tag) {
            return statusBar
        } else {
            let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
            let statusBarView = UIView(frame: height)
            statusBarView.tag = tag
            statusBarView.layer.zPosition = 999999

            keyWindow?.addSubview(statusBarView)
            return statusBarView
        }

    } else {

        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
    }
    return nil
  }
}
