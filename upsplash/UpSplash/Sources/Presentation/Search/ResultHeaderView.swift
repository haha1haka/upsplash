//
//  ResultHeaderView.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import UIKit
import SnapKit

final class ResultHeaderView: UICollectionReusableView {
    
    var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var clearButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = .black
        button.layer.masksToBounds = true
        button.setTitleColor(.tintColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.setTitle("clear", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setHierarchy() {
        addSubview(headerLabel)
        addSubview(clearButton)
    }
    
    private func setLayout() {
        headerLabel.snp.makeConstraints {
            $0.leading.equalTo(self).inset(15)
            $0.top.equalTo(self).offset(10)
            $0.bottom.equalTo(self).inset(10)
            $0.trailing.equalTo(clearButton.snp.leading)
        }
        
        clearButton.snp.makeConstraints {
            $0.top.equalTo(self).offset(15)
            $0.trailing.equalTo(self).inset(15)
            $0.bottom.equalTo(self).inset(15)
            $0.width.equalTo(44)
        }
    }
    
    func configureAttributes(with title: String) {
        headerLabel.text = title
    }
}


