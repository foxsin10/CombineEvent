import Combine
import UIKit

extension Combine where Base: UIControl {
    public func publisher(on events: UIControl.Event) -> Publishers.ControlEventPublisher<Base> {
        Publishers.ControlEventPublisher(control: base, events: events)
    }

    public func publisher<Value>(
        for keyPath: KeyPath<Base, Value>,
        on events: UIControl.Event
    ) -> AnyPublisher<Value, Never> {
        Publishers.ControlEventPublisher(control: base, events: events)
            .map(keyPath)
            .eraseToAnyPublisher()
    }
}

extension Combine where Base: UIButton {
    public func tap() -> AnyPublisher<Void, Never> {
        publisher(on: .touchUpInside)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
