//
//  AlbumCoordinator.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/25.
//

import UIKit

final class AlbumCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let imageRepositoryImpl = ImageRepositoryImpl()
        let viewModel = AlbumViewModel(imageRepository: imageRepositoryImpl)
        let vc = AlbumViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func pushDetailViewController(with item: [Photo], indexPath: IndexPath) {
        let child = DetailCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.startDetail(with: item, indexPath: indexPath)
    }
    
}
