import Combine
import UIKit

extension Publishers {
    public struct ControlEventPublisher<Control: UIControl>: Publisher {
        public typealias Output = Control
        public typealias Failure = Never

        public let control: Control
        public let controlEvents: UIControl.Event

        public init(control: Control, events: UIControl.Event) {
            self.control = control
            self.controlEvents = events
        }

        public func receive<S>(subscriber: S) where
            S: Subscriber,
            S.Failure == Failure,
            S.Input == Output {
            let subscription = ControlSubscription(subscriber: subscriber, control: control, event: controlEvents)
            subscriber.receive(subscription: subscription)
        }
    }

    private final class ControlSubscription<S: Subscriber, C: UIControl>: Subscription where
        S.Input == C {
        private var subscriber: S?
        private let control: C
        private let event: UIControl.Event

        init(subscriber: S, control: C, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            self.event = event
            control.addTarget(self, action: #selector(eventHandler), for: event)
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            control.removeTarget(self, action: #selector(eventHandler), for: event)
            subscriber = nil
        }

        @objc private func eventHandler() {
            _ = subscriber?.receive(control)
        }
    }
}
