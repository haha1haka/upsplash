//
//  AlbumCoordinator.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/25.
//

import UIKit

class DetailCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let imageRepositoryImpl = ImageRepositoryImpl()
        let imageUseCaseImpl = ImageUseCaseImpl(imageRepository: imageRepositoryImpl)
        let viewModel = DetailViewModel(imageUseCase: imageUseCaseImpl)
        let vc = DetailViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func startDetail(with item: [Photo], indexPath: IndexPath) {
        let imageRepositoryImpl = ImageRepositoryImpl()
        let imageUseCaseImpl = ImageUseCaseImpl(imageRepository: imageRepositoryImpl)
        let viewModel = DetailViewModel(imageUseCase: imageUseCaseImpl)
        let vc = DetailViewController(viewModel: viewModel)
        vc.viewModel.photoListPublish.send(item)
        vc.viewModel.indexPathPublisher.send(indexPath)
        navigationController.pushViewController(vc, animated: true)
    }
    
}
