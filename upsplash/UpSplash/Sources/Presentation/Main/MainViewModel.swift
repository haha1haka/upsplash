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
    
    init(topicUseCase: TopicUseCase, photoUseCase: PhotoUseCase) {
        self.topicUseCase = topicUseCase
        self.photoUseCase = photoUseCase
    }
    
    var topicListPublisher = CurrentValueSubject<[Topic], Never>([])
    var photoListPublisher = CurrentValueSubject<[Photo], Never>([])
    var errorPublisher = PassthroughSubject<String?, Never>()
    var didSelectItemAtPublisher = PassthroughSubject<IndexPath, Never>()
    var isLoadingPublisher = CurrentValueSubject<Bool, Never>(false)
    
    func fetchTopic() {
        isLoadingPublisher.send(true)
        topicUseCase.excute { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let topicList):
                self.topicListPublisher.send(topicList)
                self.isLoadingPublisher.send(false)
            case .failure(let error):
                self.errorPublisher.send(error.localizedDescription)
                self.isLoadingPublisher.send(false)
            }
        }
    }
    
    func fetchTopicPhoto(id: String) {
        isLoadingPublisher.send(true)
        photoUseCase.excute(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photoList):
                self.photoListPublisher.send(photoList)
                self.isLoadingPublisher.send(false)
            case .failure(let error):
                self.errorPublisher.send(error.localizedDescription)
                self.isLoadingPublisher.send(false)
            }
            
        }
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
