import UIKit
import Combine

class SearchViewController: BaseViewController {
    
    private let selfView = SearchView()

    private let viewModel: SearchViewModel
    
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<String, Photo>!
    
    var coordinator: SearchCoordinator?
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = selfView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureDataSource()
        selfView.collectionView.delegate = self
        selfView.searchController.delegate = self
        selfView.searchController.searchBar.delegate = self
        selfView.resultViewController.butonTriggerDelegate = self
        navigationItem.searchController = selfView.searchController
    }
}

extension SearchViewController: Bindable {
    func bind() {
        viewModel.searchedPhotoList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] searchedPhotoList in
                guard let self = self else { return }
                var snapshot = NSDiffableDataSourceSnapshot<String, Photo>()
                snapshot.appendSections(["search"])
                snapshot.appendItems(searchedPhotoList)
                self.collectionViewDataSource.apply(snapshot)
            }
            .store(in: &cancellableBag)
        
        viewModel.searchBarBeginEditingPublish
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                guard let self = self else { return }
                self.selfView.searchController.showsSearchResultsController = true
                }
            .store(in: &cancellableBag)
        
        viewModel.searchBarCancelPublish
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                var snapshot = self.collectionViewDataSource.snapshot()
                snapshot.deleteAllItems()
                self.collectionViewDataSource.apply(snapshot)
            }
            .store(in: &cancellableBag)
        
        viewModel.searchBarButtonClickedPublish
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                guard let searchText = self.selfView.searchController.searchBar.text else { return }
                self.selfView.searchController.showsSearchResultsController = false
                
                self.viewModel.fetchSearchedPhotoList(text: searchText)
                
                if self.viewModel.isContainsSearchLogInDB(searchText: searchText) {
                    self.viewModel.addRealmStoreage(with: SearchLog(text: searchText))
                }
                let searchLogList = self.viewModel.fetchSearchLog()
                var snapshot = NSDiffableDataSourceSnapshot<String, String>()
                snapshot.appendSections(["🔥 Recent Search"])
                snapshot.appendItems(searchLogList.reversed())
                self.selfView.resultViewController.collectionViewDataSource.apply(snapshot)
            }
            .store(in: &cancellableBag)
        
        viewModel.willPresentSearchControllerPublish
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.selfView.searchController.searchBar.scopeButtonTitles = ["Photos", "Collections", "Users"]
                self.selfView.searchController.searchBar.selectedScopeButtonIndex = .zero
            }
            .store(in: &cancellableBag)
        
        viewModel.didDismissSearchControllerPublish
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.selfView.searchController.searchBar.scopeButtonTitles = nil
            }
            .store(in: &cancellableBag)
        
        viewModel.didSelectItemAtPublish
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                guard let self = self else { return }
                self.coordinator?.pushDetailViewController(with: self.viewModel.searchedPhotoList.value, indexPath: indexPath)
            }
            .store(in: &cancellableBag)
        
        viewModel.tappedHeaderClearButtonPublish
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                guard let resultViewControllerDataSource =
                        self.selfView.resultViewController.collectionViewDataSource else { return }
                var snapshot = resultViewControllerDataSource.snapshot()
                let allItems = snapshot.itemIdentifiers(inSection: "🔥 Recent Search")
                snapshot.deleteItems(allItems)
                resultViewControllerDataSource.apply(snapshot)
            }
            .store(in: &cancellableBag)
        
    }
}

extension SearchViewController {
    private func configureDataSource() {
        let photoCellRegistraion = UICollectionView.CellRegistration<PhotoCell, Photo> { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier)
        }
        collectionViewDataSource = .init(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: photoCellRegistraion,
                for: indexPath,
                item: itemIdentifier
            )
            return cell
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.tappedSearchBarEditing()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.tappedSearchBarCancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.tappedSearchBarButtonClicked()
    }
}

extension SearchViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        viewModel.willPresentSearchController()
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        viewModel.didDismissSearchController()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.tappedCollectionViewDidSelectItemAt(indexPath: indexPath)
    }
}
extension SearchViewController: ResultClearButtonDelegate {
    func tappedClearButton() {
        viewModel.tappedHeaderClearButton()
    }
}
