//
//  DisconnectedView.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/02/10.
//

import UIKit
import SnapKit

final class NoConnectionView: BaseView {
    
    private var noConnecntionView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "네트워크 연결 상태를 확인해 주세요"
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override func setHierarchy() {
        addSubview(noConnecntionView)
        addSubview(descriptionLabel)
    }
    
    override func setLayout() {
        NSLayoutConstraint.activate([
            noConnecntionView.topAnchor.constraint(equalTo: topAnchor),
            noConnecntionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            noConnecntionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            noConnecntionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: noConnecntionView.centerXAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: noConnecntionView.centerYAnchor)
        ])
        noConnecntionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func setAttributes() {
        backgroundColor = .white
    }
}
