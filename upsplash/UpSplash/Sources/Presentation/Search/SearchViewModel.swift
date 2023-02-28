import Foundation
import Combine

protocol SearchViewModelInput {
    func tappedSearchBarEditing()
    func tappedSearchBarCancel()
    func tappedSearchBarButtonClicked()
    func willPresentSearchController()
    func didDismissSearchController()
    func tappedCollectionViewDidSelectItemAt(indexPath: IndexPath)
    func tappedHeaderClearButton() 
}

protocol SearchViewModelOuput {
    var searchedPhotoList: AnyPublisher<[Photo], Never> { get }
    var error: AnyPublisher<String?, Never> { get }
    var eventSearchBarBeginEditing: AnyPublisher<Void, Never> { get }
    var didTappedSearchBarCancel: AnyPublisher<Void, Never> { get }
    var didTappedSearchBar: AnyPublisher<Void, Never> { get }
    var eventWillPresentSearchController: AnyPublisher<Void, Never> { get }
    var eventdidDismissSearchController: AnyPublisher<Void, Never> { get }
    var didTappedDidSelectItemAt: AnyPublisher<IndexPath, Never> { get }
    var didTappedHeader: AnyPublisher<Void, Never> { get }
}

protocol SearchViewModelIO {
    var input: SearchViewModelInput { get }
    var output: SearchViewModelOuput { get }
}

class SearchViewModel: SearchViewModelIO {
    
    private let searchUseCase: SearchUseCase
    private let searchLogUseCase: SearchLogUseCase
    
    init(searchUseCase: SearchUseCase, searchLogUseCase: SearchLogUseCase) {
        self.searchUseCase = searchUseCase
        self.searchLogUseCase = searchLogUseCase
    }
    
    var searchedPhotoListPublisher = CurrentValueSubject<[Photo], Never>([])
    var errorMessagePublisher = PassthroughSubject<String?, Never>()
    
    var searchBarBeginEditingPublisher = PassthroughSubject<Void, Never>()
    var searchBarCancelPublisher = PassthroughSubject<Void, Never>()
    var searchBarButtonClickedPublisher = PassthroughSubject<Void, Never>()
    var willPresentSearchControllerPublisher = PassthroughSubject<Void, Never>()
    var didDismissSearchControllerPublisher = PassthroughSubject<Void, Never>()
    var didSelectItemAtPublisher = PassthroughSubject<IndexPath, Never>()
    var tappedHeaderClearButtonPublisher = PassthroughSubject<Void, Never>()
    
    func fetchSearchedPhotoList(text: String) {
        searchUseCase.excute(text: text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let search):
                self.searchedPhotoListPublisher.send(search.results)
            case .failure(let error):
                self.errorMessagePublisher.send(error.localizedDescription)
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

extension SearchViewModel: SearchViewModelInput {
    var input: SearchViewModelInput { self }
    
    func tappedSearchBarEditing() {
        searchBarBeginEditingPublisher.send()
    }
    func tappedSearchBarCancel() {
        searchBarCancelPublisher.send()
    }
    func tappedSearchBarButtonClicked() {
        searchBarButtonClickedPublisher.send()
    }
    func willPresentSearchController() {
        willPresentSearchControllerPublisher.send()
    }
    func didDismissSearchController() {
        didDismissSearchControllerPublisher.send()
    }
    func tappedCollectionViewDidSelectItemAt(indexPath: IndexPath) {
        didSelectItemAtPublisher.send(indexPath)
    }
    func tappedHeaderClearButton() {
        deleteSearchLog()
        tappedHeaderClearButtonPublisher.send()
    }
}

extension SearchViewModel: SearchViewModelOuput {
    var output: SearchViewModelOuput { self }
    
    var searchedPhotoList: AnyPublisher<[Photo], Never> { searchedPhotoListPublisher.eraseToAnyPublisher() }
    var error: AnyPublisher<String?, Never> { errorMessagePublisher.eraseToAnyPublisher() }
    var eventSearchBarBeginEditing: AnyPublisher<Void, Never> { searchBarBeginEditingPublisher.eraseToAnyPublisher() }
    var didTappedSearchBarCancel: AnyPublisher<Void, Never> { searchBarCancelPublisher.eraseToAnyPublisher() }
    var didTappedSearchBar: AnyPublisher<Void, Never> { searchBarButtonClickedPublisher.eraseToAnyPublisher() }
    var eventWillPresentSearchController: AnyPublisher<Void, Never> { willPresentSearchControllerPublisher.eraseToAnyPublisher() }
    var eventdidDismissSearchController: AnyPublisher<Void, Never> { didDismissSearchControllerPublisher.eraseToAnyPublisher() }
    var didTappedDidSelectItemAt: AnyPublisher<IndexPath, Never> { didSelectItemAtPublisher.eraseToAnyPublisher() }
    var didTappedHeader: AnyPublisher<Void, Never> { tappedHeaderClearButtonPublisher.eraseToAnyPublisher() }
}
