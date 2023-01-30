import Foundation
import Combine


protocol AlbumViewModelInput {
    func tappedCollectionViewDidSelectItemAt(indexPath: IndexPath)
}
protocol AlbumViewModelOuput {
    var albumImageListPublish: CurrentValueSubject<[Image], Never> { get }
    var didSelectItemAtPublish: PassthroughSubject<IndexPath, Never> { get }
}

protocol AlbumViewModelIO: AlbumViewModelInput, AlbumViewModelOuput {}

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

extension AlbumViewModel {
    func tappedCollectionViewDidSelectItemAt(indexPath: IndexPath) {
        didSelectItemAtPublish.send(indexPath)
    }
}
