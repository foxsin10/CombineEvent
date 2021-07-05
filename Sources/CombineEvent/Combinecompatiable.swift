import UIKit

/// Extending the `UIControl` types to be able to produce a `UIControl.Event` publisher.
public protocol CombineCompatible {}
extension UIControl: CombineCompatible {}
