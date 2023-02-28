import UIKit

class AlbumViewController: BaseViewController {
    
    private let selfView = AlbumView()

    private let viewModel: AlbumViewModel
    
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<String, Image>!
    
    var coordinator: AlbumCoordinator?
    
    init(viewModel: AlbumViewModel) {
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
        selfView.collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadImage()
    }
}

extension AlbumViewController: Bindable {
    func bind() {
        viewModel
            .output
            .albumImageList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageList in
                guard let self = self else { return }
                var snapshot = NSDiffableDataSourceSnapshot<String, Image>()
                snapshot.appendSections(["album"])
                snapshot.appendItems(imageList)
                self.collectionViewDataSource.apply(snapshot)
            }
            .store(in: &cancellableBag)
        
        viewModel
            .output
            .didTappedSelectedItemAl
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                guard let self = self else { return }
                let photoList = self.viewModel.albumImageListPublish.value.map { Photo(id: $0.id, width: $0.width, height: $0.height, urls: Urls(regular: $0.url)) }
                self.coordinator?.pushDetailViewController(with: photoList, indexPath: indexPath)
            }
            .store(in: &cancellableBag)
    }
}

extension AlbumViewController {
    private func configureDataSource() {
        let photoCellRegistraion = UICollectionView.CellRegistration<PhotoCell, Image> { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier)
        }
        collectionViewDataSource = .init(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: photoCellRegistraion,
                for: indexPath,
                item: itemIdentifier
            )
            return cell
        }
    }
}

extension AlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.tappedCollectionViewDidSelectItemAt(indexPath: indexPath)
    }
}
