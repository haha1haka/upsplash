import UIKit
import SnapKit
import Kingfisher

final class TopicCell: BaseCollectionViewCell {
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.layer.opacity = 0.7
        return view
    }()
    
    private let topicTitleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemFont(
            ofSize: 15,
            weight: .semibold
        )
        view.numberOfLines = .zero
        return view
    }()
    
    override func setHierarchy() {
        addSubview(imageView)
        addSubview(topicTitleLabel)
    }
    
    override func setLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        topicTitleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setAttributes() {
        backgroundColor = .black
        layer.cornerRadius = 8
    }
    
    func configureAttributes(with item: Topic) {
        topicTitleLabel.text = item.title
        let imageUrl = URL(string: item.coverPhoto.urls.regular)
        imageView.kf.setImage(with: imageUrl)
    }
}
