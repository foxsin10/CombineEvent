import Combine
import UIKit

extension Combine where Base: UITextView {
    public func textPublisher() -> AnyPublisher<String, Never> {
        valueWhenEditting(for: \.text)
            .eraseToAnyPublisher()
    }

    public func whenEditting() -> Publishers.TextViewTextPublisher<Base> {
        Publishers.TextViewTextPublisher(base)
    }

    public func valueWhenEditting<Value>(for keyPath: KeyPath<Base, Value>) -> AnyPublisher<Value, Never> {
        whenEditting()
            .map(keyPath)
            .eraseToAnyPublisher()
    }
}
