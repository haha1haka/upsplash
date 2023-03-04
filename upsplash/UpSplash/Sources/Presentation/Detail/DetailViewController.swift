import UIKit
import Combine

class DetailViewController: BaseViewController {
    
    private let selfView = DetailView()
    
    let viewModel: DetailViewModel
    
    private var anyCancellable = Set<AnyCancellable>()
    
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<String, Photo>!
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = selfView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureDataSource()
        selfView.butonTriggerDelegate = self
    }
}

extension DetailViewController: Bindable {
    func bind() {
        viewModel
            .output
            .photoList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photoList in
                guard let self = self else { return }
                var snapshot = NSDiffableDataSourceSnapshot<String, Photo>()
                snapshot.appendSections(["detail"])
                snapshot.appendItems(photoList)
                self.collectionViewDataSource.apply(snapshot)
            }
            .store(in: &cancellableBag)

        
        viewModel
            .output
            .currentIndexPath
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                guard let self = self else { return }
                let currentPhotoItemIndex = indexPath.item
                let indexPath = IndexPath(item: currentPhotoItemIndex, section: 0)
                self.selfView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
            .store(in: &cancellableBag)
        
        viewModel
            .output
            .didTappedFloatingButton
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }         
                guard let pageIndex = self.selfView.pageIndex else { return }
                let selecteditem = self.viewModel.photoListPublish.value[pageIndex]
                if !self.viewModel.imageIdListPublish.value.contains(selecteditem.id) {

                    self.viewModel.addRealmStoreage(with: Image(
                        id: selecteditem.id,
                        width: selecteditem.width,
                        height: selecteditem.height,
                        url: selecteditem.urls.regular)
                    )
                    .sink {
                        self.showAlert(message: "이미지가 저장 되었습니다.")
                    }
                    .store(in: &self.anyCancellable)
                    
                } else {
                    self.showAlertMessage()
                        .sink {
                            self.viewModel.deleteFromRealmStoreage(with: Image(
                                id: selecteditem.id,
                                width: selecteditem.width,
                                height: selecteditem.height,
                                url: selecteditem.urls.regular)
                            )
                            self.showAlert(message: "삭제 되었습니다.")
                        }.store(in: &self.anyCancellable)
                }
            }
            .store(in: &cancellableBag)
    }
}

extension DetailViewController {
    private func configureDataSource() {
        let photoCellRegistration = UICollectionView.CellRegistration<PhotoCell, Photo> { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier)
        }
        collectionViewDataSource = UICollectionViewDiffableDataSource<String, Photo>(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: photoCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
}

extension DetailViewController: DetailFloatButtonDelegatge {
    func tappedFloatingButton() {
        viewModel.input.tappedFloatingButton()
    }
}
