import Foundation

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
