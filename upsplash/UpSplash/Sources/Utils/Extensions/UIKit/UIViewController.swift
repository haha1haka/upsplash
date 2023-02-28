import UIKit
import Combine

extension UIViewController {
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.dismiss(animated: true)
        }
    }
    
    func showAlertMessage() -> Future<Void, Never> {
        
        return Future() { promiss in
            let alert = UIAlertController(title: "저장된 이미지", message: "이미 저장된 이미지 입니다. 삭제 하시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                promiss(.success(()))
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
                self.dismiss(animated: true)
            }
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }


    }
}
