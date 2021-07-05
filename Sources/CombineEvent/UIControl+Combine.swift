import Combine
import UIKit

extension CombineCompatible where Self: UIControl {
    public func publisher(on events: UIControl.Event) -> Publishers.ControlEventPublisher<Self> {
        return Publishers.ControlEventPublisher(control: self, events: events)
    }

    public func publisher<Value>(
        for keyPath: KeyPath<Self, Value>,
        on events: UIControl.Event
    ) -> AnyPublisher<Value, Never> {
        Publishers.ControlEventPublisher(control: self, events: events)
            .map(keyPath)
            .eraseToAnyPublisher()
    }
}
