import Combine
import UIKit

extension CombineCompatible where Self: UITextView {
    public func textPublisher() -> AnyPublisher<String, Never> {
        valueWhenEditting(for: \.text)
            .eraseToAnyPublisher()
    }

    public func whenEditting() -> Publishers.TextViewTextPublisher<Self> {
        Publishers.TextViewTextPublisher(self)
    }

    public func valueWhenEditting<Value>(for keyPath: KeyPath<Self, Value>) -> AnyPublisher<Value, Never> {
        whenEditting()
            .map(keyPath)
            .eraseToAnyPublisher()
    }
}
