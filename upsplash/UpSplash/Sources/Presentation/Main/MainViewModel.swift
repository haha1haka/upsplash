import Foundation
import Combine

protocol MainViewModelInput {
    func tappedCollectionViewDidSelectItemAt(indexPath: IndexPath)
}

protocol MainViewModelOuput {
    var topicListPublish: CurrentValueSubject<[Topic], Never> { get }
    var photoListPublish: CurrentValueSubject<[Photo], Never> { get }
    var errorMessagePublish: PassthroughSubject<String?, Never> { get }
    var didSelectItemAtPublish: PassthroughSubject<IndexPath, Never> { get }
}

protocol MainViewModelIO: MainViewModelInput, MainViewModelOuput {}

final class MainViewModel: MainViewModelIO {
    
    private let topicUseCase: TopicUseCase
    private let photoUseCase: PhotoUseCase
    
    init(topicUseCase: TopicUseCase, photoUseCase: PhotoUseCase) {
        self.topicUseCase = topicUseCase
        self.photoUseCase = photoUseCase
    }
    
    var topicListPublish = CurrentValueSubject<[Topic], Never>([])
    var photoListPublish = CurrentValueSubject<[Photo], Never>([])
    var errorMessagePublish = PassthroughSubject<String?, Never>()
    var didSelectItemAtPublish = PassthroughSubject<IndexPath, Never>()
    
    func fetchTopic() {
        topicUseCase.excute { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let topicList):
                self.topicListPublish.send(topicList)
            case .failure(let error):
                self.errorMessagePublish.send(error.message)
            }
        }
    }
    
    func fetchTopicPhoto(id: String) {
        photoUseCase.excute(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photoList):
                self.photoListPublish.send(photoList)
            case .failure(let error):
                self.errorMessagePublish.send(error.message)
            }
            
        }
    }
}


extension MainViewModel {
    func tappedCollectionViewDidSelectItemAt(indexPath: IndexPath) {
        didSelectItemAtPublish.send(indexPath)
    }
}
