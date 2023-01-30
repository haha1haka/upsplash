import UIKit
import Combine

class BaseViewController: UIViewController {
    
    // MARK: Initialize
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    // MARK: Combine Property
    
    var cancellableBag = Set<AnyCancellable>()
    
    // MARK: Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        setHierarchy()
        setLayout()
    }
    
    // MARK: - Override Methods
    
    func setAttributes() {}     // 속성 설정
    func setHierarchy() {}      // 계층 설정
    func setLayout() {}         // 레이아웃 설정
}
