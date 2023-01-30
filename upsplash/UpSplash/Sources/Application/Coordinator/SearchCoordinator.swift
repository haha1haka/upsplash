//
//  SearchCoordinator.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/25.
//

import UIKit

final class SearchCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let session = UnsplashServiceImpl.shared
        let searchRepositoryImpl = SearchRepositoryImpl(session: session)
        let searchLogRepositoryImpl = SearchLogRepositoryImpl()
        let searchUseCaseImpl = SearchUseCaseImpl(searchRepository: searchRepositoryImpl)
        let searchLogUseCaseImpl = SearchLogUseCaseImpl(searchLogRepository: searchLogRepositoryImpl)
        let viewModel = SearchViewModel(searchUseCase: searchUseCaseImpl, searchLogUseCase: searchLogUseCaseImpl)
        let vc = SearchViewController(viewModel: viewModel)
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
