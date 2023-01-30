import UIKit
import Combine

final class MainViewController: BaseViewController {
    
    enum SectionItem: Hashable {
        case topic(Topic)
        case topicPhoto(Photo)
    }
    
    private let selfView = MainView()
    
    private let viewModel: MainViewModel
    
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<String, SectionItem>!
    
    var coordinator: MainCoordinator?
    
    init(viewModel: MainViewModel) {
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
        viewModel.fetchTopic()
        selfView.collectionView.delegate = self
    }
}

extension MainViewController: Bindable {
    func bind() {
        viewModel.topicListPublish
            .receive(on: DispatchQueue.main)
            .sink { [weak self] topicList in
                guard let self = self else { return }
                var snapshot = NSDiffableDataSourceSnapshot<String, SectionItem>()
                snapshot.appendSections(["Topic"])
                snapshot.appendItems(topicList.map(SectionItem.topic))
                self.collectionViewDataSource.apply(snapshot)
            }
            .store(in: &cancellableBag)
        
        viewModel.photoListPublish
            .receive(on: DispatchQueue.main)
            .sink { [weak self] topicPhoto in
                guard let self = self else { return }
                var snapshot = self.collectionViewDataSource.snapshot()
                if !snapshot.sectionIdentifiers.isEmpty {
                    snapshot.deleteSections(["TopicPhoto"])
                    snapshot.deleteItems(topicPhoto.map(SectionItem.topicPhoto))
                }
                snapshot.appendSections(["TopicPhoto"])
                snapshot.appendItems(topicPhoto.map(SectionItem.topicPhoto))
                self.collectionViewDataSource.apply(snapshot)
            }
            .store(in: &cancellableBag)
        
        viewModel.didSelectItemAtPublish
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                guard let self = self else { return }
                let selectedItem = self.collectionViewDataSource.itemIdentifier(for: indexPath)
                switch selectedItem {
                case .topic(let topic):
                    self.viewModel.fetchTopicPhoto(id: topic.id)
                case .topicPhoto:
                    self.coordinator?.pushDetailViewController(with: self.viewModel.photoListPublish.value, indexPath: indexPath)
                default:
                    return
                }
            }
            .store(in: &cancellableBag)
    }
}

extension MainViewController {
    private func configureDataSource() {
        let topicCellRegistraion = UICollectionView.CellRegistration<TopicCell, Topic> { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier)
        }
        let photoCellRegistraion = UICollectionView.CellRegistration<PhotoCell, Photo> { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier)
        }
        collectionViewDataSource = .init(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .topic(let topic):
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: topicCellRegistraion,
                    for: indexPath, item: topic
                )
                return cell
            case .topicPhoto(let topicPhoto):
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: photoCellRegistraion,
                    for: indexPath,
                    item: topicPhoto
                )
                return cell
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.tappedCollectionViewDidSelectItemAt(indexPath: indexPath)
    }
}
