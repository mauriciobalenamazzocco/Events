import Foundation
import UIKit

/**
 
 Each view controller that participates in the coordinator or MVVM needs to implement
 this protocol.

*/
protocol BindableType {
    associatedtype ViewModelType

    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

// MARK: - UIViewController
extension BindableType where Self: UIViewController {
    mutating func bind(to model: Self.ViewModelType) {
        self.viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}

// MARK: - UITableViewCell
extension BindableType where Self: UITableViewCell {
    mutating func bind(to model: Self.ViewModelType) {
        self.viewModel = model
        bindViewModel()
    }

}
