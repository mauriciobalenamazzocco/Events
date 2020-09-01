import Foundation

extension String {
    func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    func validateName() -> Bool {
        return self.range(of: "\\A\\w{7,18}\\z", options: .regularExpression) != nil
    }
}
