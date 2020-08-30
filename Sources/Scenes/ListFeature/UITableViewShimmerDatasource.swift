import Foundation
import UIKit

class UITableViewShimmerDatasource<T: UITableViewCell>: NSObject, UITableViewDataSource where T: ClassIdentifiable {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withCellType: T.self)
    }
}
