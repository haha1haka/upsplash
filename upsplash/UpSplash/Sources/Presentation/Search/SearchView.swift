import UIKit
import SnapKit

class SearchView: BaseView {
    
    var resultViewController = ResultViewController()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(
            searchResultsController: resultViewController
        )
        searchController.searchBar.tintColor = .label
        searchController.searchBar.placeholder = "Search photos, collections, users"
        searchController.searchResultsUpdater = resultViewController as? UISearchResultsUpdating
        return searchController
    }()
 
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
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
// MARK: - CompositonalLayout
extension SearchView {
    private func createLayout() -> UICollectionViewLayout {
        let collectionViewLayout = UICollectionViewCompositionalLayout(
            sectionProvider:
                { sectionIndex, layoutEnvironment in
                    let itemSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(128)
                    )
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                    let group = NSCollectionLayoutGroup.vertical(
                        layoutSize: itemSize,
                        subitems: [item]
                    )
                    let section = NSCollectionLayoutSection(group: group)
                    return section
                })
        return collectionViewLayout
    }
}


