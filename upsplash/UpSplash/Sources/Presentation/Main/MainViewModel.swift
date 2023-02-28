import Foundation
import Combine

protocol MainViewModelInput {
    func tappedCollectionViewDidSelectItemAt(indexPath: IndexPath)
}

protocol MainViewModelOuput {
    var topicList: AnyPublisher<[Topic], Never> { get }
    var photoList: AnyPublisher<[Photo], Never> { get }
    var error: AnyPublisher<String?, Never> { get }
    var didSelectedItemAt: AnyPublisher<IndexPath, Never> { get }
    var isLoading: AnyPublisher<Bool, Never> { get }
}

protocol MainViewModelIO {
    var input: MainViewModelInput { get }
    var output: MainViewModelOuput { get }
}

final class MainViewModel: MainViewModelIO {
    
    private let topicUseCase: TopicUseCase
    private let photoUseCase: PhotoUseCase
    private var anyCancellable = Set<AnyCancellable>()
    
    init(topicUseCase: TopicUseCase, photoUseCase: PhotoUseCase) {
        self.topicUseCase = topicUseCase
        self.photoUseCase = photoUseCase
    }
    
    var topicListPublisher = CurrentValueSubject<[Topic], Never>([])
    var photoListPublisher = CurrentValueSubject<[Photo], Never>([])
    var errorPublisher = PassthroughSubject<String?, Never>()
    var didSelectItemAtPublisher = PassthroughSubject<IndexPath, Never>()
    var isLoadingPublisher = CurrentValueSubject<Bool, Never>(false)
    
    func fetchTopicList() {
        isLoadingPublisher.send(true)
        topicUseCase.excute()
            .sink { [weak self] completion in
                guard let self = self else { return }
                if case .failure(let error) = completion {
                    self.errorPublisher.send(error.localizedDescription)
                }
                self.isLoadingPublisher.send(false)
            } receiveValue: { [weak self] topicList in
                guard let self = self else { return }
                self.topicListPublisher.send(topicList)
                self.isLoadingPublisher.send(false)
            }
            .store(in: &self.anyCancellable)
    }
    
    func fetchTopicPhoto(id: String) {
        isLoadingPublisher.send(true)
        photoUseCase.excute(id: id)
            .sink { [weak self] completion in
                guard let self = self else { return }
                if case .failure(let error) = completion {
                    self.errorPublisher.send(error.localizedDescription)
                }
                self.isLoadingPublisher.send(false)
            } receiveValue: { [weak self] photoList in
                guard let self = self else { return }
                self.photoListPublisher.send(photoList)
                self.isLoadingPublisher.send(false)
            }
            .store(in: &self.anyCancellable)
    }
    
}

extension MainViewModel: MainViewModelInput {
    var input: MainViewModelInput { self }
    
    func tappedCollectionViewDidSelectItemAt(indexPath: IndexPath) {
        didSelectItemAtPublisher.send(indexPath)
    }
}

extension MainViewModel: MainViewModelOuput {
    var output: MainViewModelOuput { self }
    
    var topicList: AnyPublisher<[Topic], Never> {
        return topicListPublisher.eraseToAnyPublisher()
    }
    
    var photoList: AnyPublisher<[Photo], Never> {
        return photoListPublisher.eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<String?, Never> {
        return errorPublisher.eraseToAnyPublisher()
    }
    
    var didSelectedItemAt: AnyPublisher<IndexPath, Never> {
        return didSelectItemAtPublisher.eraseToAnyPublisher()
    }
    var isLoading: AnyPublisher<Bool, Never> {
        return isLoadingPublisher.eraseToAnyPublisher()
    }
}
