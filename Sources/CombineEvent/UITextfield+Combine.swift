import Combine
import UIKit

extension Combine where Base: UITextField {
    public func textPublisher() -> AnyPublisher<String, Never> {
        self.publisher(for: \.text, on: [.allEditingEvents])
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    public func attributedStringPublisher() -> AnyPublisher<NSAttributedString, Never> {
        publisher(for: \.attributedText, on: [.allEditingEvents])
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
}
