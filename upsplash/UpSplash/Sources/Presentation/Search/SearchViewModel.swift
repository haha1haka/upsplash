import Foundation
import Combine

protocol SearchViewModelInput {
    func tappedSearchBarEditing()
    func tappedSearchBarCancel()
    func tappedSearchBarButtonClicked()
    func willPresentSearchController()
    func didDismissSearchController()
    func tappedCollectionViewDidSelectItemAt(indexPath: IndexPath)
}

protocol SearchViewModelOuput {
    var searchedPhotoList: CurrentValueSubject<[Photo], Never> { get }
    var errorMessage: PassthroughSubject<String?, Never> { get }
    var searchBarBeginEditingPublish: PassthroughSubject<Void, Never> { get }
    var searchBarCancelPublish: PassthroughSubject<Void, Never> { get }
    var searchBarButtonClickedPublish: PassthroughSubject<Void, Never> { get }
    var willPresentSearchControllerPublish: PassthroughSubject<Void, Never> { get }
    var didDismissSearchControllerPublish: PassthroughSubject<Void, Never> { get }
    var didSelectItemAtPublish: PassthroughSubject<IndexPath, Never> { get }
}

protocol SearchViewModelIO: SearchViewModelInput, SearchViewModelOuput {}

class SearchViewModel: SearchViewModelIO {
    
    private let searchUseCase: SearchUseCase
    private let searchLogUseCase: SearchLogUseCase
    
    init(searchUseCase: SearchUseCase, searchLogUseCase: SearchLogUseCase) {
        self.searchUseCase = searchUseCase
        self.searchLogUseCase = searchLogUseCase
    }
    
    var searchedPhotoList = CurrentValueSubject<[Photo], Never>([])
    var errorMessage = PassthroughSubject<String?, Never>()
    var searchBarBeginEditingPublish = PassthroughSubject<Void, Never>()
    var searchBarCancelPublish = PassthroughSubject<Void, Never>()
    var searchBarButtonClickedPublish = PassthroughSubject<Void, Never>()
    var willPresentSearchControllerPublish = PassthroughSubject<Void, Never>()
    var didDismissSearchControllerPublish = PassthroughSubject<Void, Never>()
    var didSelectItemAtPublish = PassthroughSubject<IndexPath, Never>()
    var tappedHeaderClearButtonPublish = PassthroughSubject<Void, Never>()
    
    func fetchSearchedPhotoList(text: String) {
        searchUseCase.excute(text: text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let search):
                self.searchedPhotoList.send(search.results)
            case .failure(let error):
                self.errorMessage.send(error.message)
            }
        }
    }
    func addRealmStoreage(with item: SearchLog) {
        searchLogUseCase.save(with: item)
    }
    
    func fetchSearchLog() -> [String] {
        searchLogUseCase.load().map { $0.text }
    }
    
    func isContainsSearchLogInDB(searchText: String) -> Bool {
        !fetchSearchLog().contains(searchText) == true ? true : false
    }
    
    private func deleteSearchLog() {
        searchLogUseCase.deleteAll()
    }
}

extension SearchViewModel {
    func tappedSearchBarEditing() {
        searchBarBeginEditingPublish.send()
    }
    func tappedSearchBarCancel() {
        searchBarCancelPublish.send()
    }
    func tappedSearchBarButtonClicked() {
        searchBarButtonClickedPublish.send()
    }
    func willPresentSearchController() {
        willPresentSearchControllerPublish.send()
    }
    func didDismissSearchController() {
        didDismissSearchControllerPublish.send()
    }
    func tappedCollectionViewDidSelectItemAt(indexPath: IndexPath) {
        didSelectItemAtPublish.send(indexPath)
    }
    func tappedHeaderClearButton() {
        deleteSearchLog()
        tappedHeaderClearButtonPublish.send()
    }
}

