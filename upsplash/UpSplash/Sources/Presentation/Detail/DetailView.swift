import UIKit
import SnapKit


protocol DetailFloatButtonDelegatge: AnyObject {
    func tappedFloatingButton()
}

final class DetailView: BaseView {
        
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        view.alwaysBounceVertical = false
        return view
    }()
    
    private var floatingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.backgroundColor = .black
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.orange, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "tray.and.arrow.down"), for: .normal)
        button.addTarget(self, action: #selector(tappedFloatingButton), for: .touchUpInside)
        return button
    }()
    
    var pageIndex: Int?
    weak var butonTriggerDelegate: DetailFloatButtonDelegatge?
    
    override func setHierarchy() {
        addSubview(collectionView)
        addSubview(floatingButton)
    }
    
    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        floatingButton.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(10)
        }
    }
}

extension DetailView {
    private func createLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let sctionSize = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            subitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: sctionSize)
        
        section.orthogonalScrollingBehavior = .paging
        
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, contentOffset, environment in
            guard let self = self else { return }
            self.pageIndex = Int(contentOffset.x / environment.container.contentSize.width)
        }
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension DetailView {
    @objc func tappedFloatingButton() {
        butonTriggerDelegate?.tappedFloatingButton()
    }
}


