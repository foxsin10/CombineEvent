import Combine
import Foundation

#if canImport(UIKit)
import UIKit

extension Publishers {
    public struct GesturePublisher<Gesture: GestureRecognizer>: Publisher {
        public typealias Output = Gesture
        public typealias Failure = Never

        private let view: PlatFormView
        private let gesture: Gesture

        public init(gesture: Gesture, targetView: PlatFormView) {
            self.gesture = gesture
            self.view = targetView
        }

        public func receive<S>(subscriber: S) where
            S: Subscriber,
            S.Failure == Never,
            S.Input == Gesture {
            let subscription = GestureSubscription(subscriber: subscriber, gesture: gesture, view: view)
            subscriber.receive(subscription: subscription)
        }
    }

    private final class GestureSubscription<S: Subscriber, G: GestureRecognizer, V: PlatFormView>: Subscription where
        S.Input == G {
        private weak var gesture: G?
        private weak var targetView: V?
        private var subscriber: S?

        let selector = #selector(GestureSubscription.gestureHandler(_:))

        init(subscriber: S, gesture: G, view: V) {
            self.subscriber = subscriber
            self.gesture = gesture
            self.targetView = view
            view.addGestureRecognizer(gesture)
            #if os(iOS) || os(tvOS)
            view.isUserInteractionEnabled = true
            gesture.addTarget(self, action: selector)
            #endif
        }

        @objc
        private func gestureHandler(_ sender: GestureRecognizer) {
            guard let gesture = gesture else { return }
            _ = subscriber?.receive(gesture)
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            gesture?.removeTarget(self, action: selector)
            subscriber = nil
        }
    }
}

extension Combine where Base: PlatFormView {
    public func gesture<Gesture: GestureRecognizer>(_ gesture: Gesture) -> Publishers.GesturePublisher<Gesture> {

        Publishers.GesturePublisher(
            gesture: gesture,
            targetView: base
        )
    }

    public func tapGesture<Tap: UITapGestureRecognizer>(
        _ gesture: Tap = Tap()
    ) -> Publishers.GesturePublisher<Tap> {
        Publishers.GesturePublisher(
            gesture: gesture,
            targetView: base
        )
    }

    public func panGesture<Pan: UIPanGestureRecognizer>(_ gesture: Pan = .init()) -> Publishers.GesturePublisher<Pan> {
        Publishers.GesturePublisher(
            gesture: gesture,
            targetView: base
        )
    }
}

extension Publishers.GesturePublisher {
    public func when(_ states: GestureRecognizerState...) -> AnyPublisher<Gesture, Never> {
        filter { states.contains($0.state) }.eraseToAnyPublisher()
    }
}

extension AnyPublisher where Output: GestureRecognizer, Failure == Never {
    public func location(in view: TargetView = .view) -> AnyPublisher<Point, Never> {
        map { $0.location(in: view.targetView(for: $0)) }.eraseToAnyPublisher()
    }
}

extension AnyPublisher where Output: UIPanGestureRecognizer, Failure == Never {
    public func velocityAndlocation(in view: TargetView = .view) -> AnyPublisher<(loction: Point, velocity: Point), Never> {
        map {
            let targetView = view.targetView(for: $0)
            let location = $0.location(in: targetView)
            let velocity = $0.velocity(in: targetView)
            return (location, velocity)
        }
        .eraseToAnyPublisher()
    }
}
#endif
