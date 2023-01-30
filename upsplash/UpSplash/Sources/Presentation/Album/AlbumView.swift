import UIKit
import SnapKit

class AlbumView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        view.alwaysBounceVertical = false
        return view
    }()
    
    override func setHierarchy() {
        addSubview(collectionView)
    }
    
    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}

extension AlbumView {
    private func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let collectionViewLayout = UICollectionViewCompositionalLayout(
            sectionProvider:
                { sectionIndex, layoutEnvironment in
                    switch sectionIndex {
                    default: return self.albumLayout()
                    }
                },
            configuration: configuration)
        return collectionViewLayout
    }
    
    private func albumLayout() -> NSCollectionLayoutSection {
        
        let photoItem = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0))
        )
        photoItem.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2
        )
        let smallPhotoItem = NSCollectionLayoutItem(layoutSize:.init(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalWidth(1/3))
        )
        smallPhotoItem.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 2,
            bottom: 0,
            trailing: 2
        )
        
        let photoGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1/3)),
            subitem: smallPhotoItem, count: 3)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500)),
            subitems: [photoItem, photoGroup])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
