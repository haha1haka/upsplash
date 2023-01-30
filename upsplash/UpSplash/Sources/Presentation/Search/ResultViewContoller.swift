//
//  ResultViewContoller.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import UIKit

protocol ResultClearButtonDelegate: AnyObject {
    func tappedClearButton()
}

final class ResultViewController: BaseViewController {
    
    private let selfView = ResultView()
    
    weak var butonTriggerDelegate: ResultClearButtonDelegate?
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, String>!
    
    override func loadView() {
        view = selfView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }
}

extension ResultViewController {
    private func configureDataSource() {
        let listCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, itemIdentifier in
            var configuration = cell.defaultContentConfiguration()
            configuration.image = UIImage(systemName: "magnifyingglass")
            configuration.text = itemIdentifier
            configuration.imageProperties.tintColor = .lightGray
            cell.contentConfiguration = configuration
        }
        collectionViewDataSource = .init(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<ResultHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, elementKind, indexPath in
            guard let self = self else { return }
            guard let sectionIdentifier = self.collectionViewDataSource.sectionIdentifier(for: indexPath.section) else { return }
            supplementaryView.clearButton.addTarget(self, action: #selector(self.tappedClearButton), for: .touchUpInside)
            supplementaryView.headerLabel.text = sectionIdentifier
        }
        
        collectionViewDataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
}

extension ResultViewController {
    @objc func tappedClearButton() {
        butonTriggerDelegate?.tappedClearButton()
    }
}

