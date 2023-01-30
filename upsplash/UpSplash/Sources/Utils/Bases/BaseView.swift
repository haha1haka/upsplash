import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        setAttributes()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttributes() {}     // 속성 설정
    func setHierarchy() {}      // 계층 설정
    func setLayout() {}         // 레이아웃 설정
    
}
