import Foundation
import Combine

protocol DetailViewModelInput {
    func tappedFloatingButton()
}
protocol DetailViewModelOuput {
    var photoList: AnyPublisher<[Photo], Never> { get }
    var currentIndexPath: AnyPublisher<IndexPath, Never> { get }
    var didTappedFloatingButton: AnyPublisher<Void, Never> { get }
    var imageIdList: AnyPublisher<[String], Never> { get }
}

protocol DetailViewModelIO {
    var input: DetailViewModelInput { get }
    var output: DetailViewModelOuput { get }
}

final class DetailViewModel: DetailViewModelIO {
    
    private var imageUseCase: ImageUseCase
    
    init(imageUseCase: ImageUseCase) {
        self.imageUseCase = imageUseCase
    }
    
    var photoListPublish = CurrentValueSubject<[Photo], Never>([])
    var indexPathPublisher = PassthroughSubject<IndexPath, Never>()
    var tappedfloatButtonPublish = PassthroughSubject<Void, Never>()
    var imageIdListPublish = CurrentValueSubject<[String], Never>([])
    
    
    func addRealmStoreage(with item: Image) -> Future<Void, Never> {
        imageUseCase.save(with: item)
        return Future() { promiss in
            promiss(.success(()))
        }
    }
    
    func deleteFromRealmStoreage(with item: Image) {
        imageUseCase.delete(with: item)
    }
    
    private func fetchImageIdList() {
        imageIdListPublish.send(imageUseCase.load().map{$0.id})
    }
}

extension DetailViewModel: DetailViewModelInput {
    var input: DetailViewModelInput { self }
    
    func tappedFloatingButton() {
        fetchImageIdList()
        tappedfloatButtonPublish.send()
    }
}

extension DetailViewModel: DetailViewModelOuput {
    var output: DetailViewModelOuput { self }
    
    var photoList: AnyPublisher<[Photo], Never> { photoListPublish.eraseToAnyPublisher() }
    var currentIndexPath: AnyPublisher<IndexPath, Never> { indexPathPublisher.eraseToAnyPublisher() }
    var didTappedFloatingButton: AnyPublisher<Void, Never> { tappedfloatButtonPublish.eraseToAnyPublisher() }
    var imageIdList: AnyPublisher<[String], Never> { imageIdListPublish.eraseToAnyPublisher() }
}
