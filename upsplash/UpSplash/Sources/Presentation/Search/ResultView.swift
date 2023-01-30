//
//  ResultView.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import UIKit
import SnapKit

final class ResultView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout())
        return view
    }()
    
    override func setHierarchy() {
        addSubview(collectionView)
    }
    
    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
}

extension ResultView {
    private func createLayout() -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
        listConfiguration.headerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
}
