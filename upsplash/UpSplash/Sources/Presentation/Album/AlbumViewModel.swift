import Foundation
import Combine

protocol AlbumViewModelInput {
    func tappedCollectionViewDidSelectItemAt(indexPath: IndexPath)
}

protocol AlbumViewModelOuput {
    var albumImageList: AnyPublisher<[Image], Never> { get }
    var didTappedSelectedItemAl: AnyPublisher<IndexPath, Never> { get }
}

protocol AlbumViewModelIO {
    var input: AlbumViewModelInput { get }
    var output: AlbumViewModelOuput { get }
}

final class AlbumViewModel: AlbumViewModelIO {
    
    private var imageRepository: ImageRepository
    
    init(imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
    }
        
    var albumImageListPublish = CurrentValueSubject<[Image], Never>([])
    var didSelectItemAtPublish = PassthroughSubject<IndexPath, Never>()
    
    func loadImage() {
        albumImageListPublish.send(imageRepository.fetchImage())
    }
}

extension AlbumViewModel: AlbumViewModelInput {
    var input: AlbumViewModelInput { self }
    
    func tappedCollectionViewDidSelectItemAt(indexPath: IndexPath) {
        didSelectItemAtPublish.send(indexPath)
    }
}

extension AlbumViewModel: AlbumViewModelOuput {
    var output: AlbumViewModelOuput { self }
    
    var albumImageList: AnyPublisher<[Image], Never> { albumImageListPublish.eraseToAnyPublisher() }
    var didTappedSelectedItemAl: AnyPublisher<IndexPath, Never> { didSelectItemAtPublish.eraseToAnyPublisher() }
    
}
