import Foundation
import Combine

protocol DetailViewModelInput {
    func tappedFloatingButton()
}
protocol DetailViewModelOuput {
    var photoListPublish: CurrentValueSubject<[Photo], Never> { get }
    var indexPathPublish: CurrentValueSubject<IndexPath, Never> { get }
    var tappedfloatButtonPublish: PassthroughSubject<Void, Never> { get }
    var imageIdListPublish: CurrentValueSubject<[String], Never> { get }
}

protocol DetailViewModelIO: DetailViewModelInput, DetailViewModelOuput {}

final class DetailViewModel: DetailViewModelIO {
    
    private var imageUseCase: ImageUseCase
    
    init(imageUseCase: ImageUseCase) {
        self.imageUseCase = imageUseCase
    }
    
    var photoListPublish = CurrentValueSubject<[Photo], Never>([])
    var indexPathPublish = CurrentValueSubject<IndexPath, Never>(IndexPath())
    var tappedfloatButtonPublish = PassthroughSubject<Void, Never>()
    var imageIdListPublish = CurrentValueSubject<[String], Never>([])
    
    func addRealmStoreage(with item: Image, completion: @escaping () -> Void) {
        imageUseCase.save(with: item)
        completion()
    }
    func deleteFromRealmStoreage(with item: Image) {
        imageUseCase.delete(with: item)
    }
    
    private func fetchImageIdList() {
        imageIdListPublish.send(imageUseCase.load().map{$0.id})
    }
}

// MARK: - Input
extension DetailViewModel {
    func tappedFloatingButton() {
        fetchImageIdList()
        tappedfloatButtonPublish.send()
    }
}
