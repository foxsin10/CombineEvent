import Combine
import UIKit

extension Publishers {
    public struct TextViewTextPublisher<V: UITextView>: Publisher {
        public typealias Output = V
        public typealias Failure = Never

        private let textView: V

        public init(_ view: V) {
            textView = view
        }

        public func receive<S>(subscriber: S) where
            S: Subscriber,
            S.Failure == Never,
            S.Input == V {
            let subscription = TextViewTextSubscription(subscriber: subscriber, textView: textView)
            subscriber.receive(subscription: subscription)
        }
    }

    private final class TextViewTextSubscription<S: Subscriber, V: UITextView>: Subscription where S.Input == V {
        private var subscriber: S?
        private weak var textView: V?
        private let textProxy = TextViewWrapper()
        private var set: Set<AnyCancellable> = []

        init(subscriber: S, textView: V) {
            self.subscriber = subscriber
            self.textView = textView

            textView.textStorage.delegate = textProxy
            textProxy.textSignal
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self, let view = self.textView else { return }
                    _ = self.subscriber?.receive(view)
                }
                .store(in: &set)
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            textView?.textStorage.delegate = nil
            subscriber = nil
        }
    }

    private final class TextViewWrapper: NSObject, NSTextStorageDelegate {
        private(set) lazy var textSignal = PassthroughSubject<Void, Never>()

        func textStorage(_ textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {

        }

        func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
            textSignal.send(())
        }
    }
}
