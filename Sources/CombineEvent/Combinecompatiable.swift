import UIKit

public protocol CombineCompatible {
    associatedtype CombineBase
    // short for combined visible
    static var cv: Combine<CombineBase>.Type { get set }
    var cv: Combine<CombineBase> { get set }
}

public struct Combine<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

extension CombineCompatible {
    /// Reactive extensions.
    public static var cv: Combine<Self>.Type {
        get {
            return Combine<Self>.self
        }
        set {}
    }

    /// Reactive extensions.
    public var cv: Combine<Self> {
        get {
            return Combine(self)
        }
        set {}
    }
}

extension UIView: CombineCompatible {}
