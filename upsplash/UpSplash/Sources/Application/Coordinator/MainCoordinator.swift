//
//  MainCoordinator.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/25.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let session = UnsplashServiceImpl.shared
        let topicRepositoryImpl = TopicRepositoryImpl(session: session)
        let photoRepositoryImpl = PhotoRepositoryImpl(session: session)
        let topicUseCaseImpl = TopicUseCaseImpl(topicRepository: topicRepositoryImpl)
        let photoUseCaseImpl = PhotoUserCaseImpl(photoRepository: photoRepositoryImpl)
        let viewModel = MainViewModel(topicUseCase: topicUseCaseImpl, photoUseCase: photoUseCaseImpl)
        let vc = MainViewController(viewModel: viewModel)
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
