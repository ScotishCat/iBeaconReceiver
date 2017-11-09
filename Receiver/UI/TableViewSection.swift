import UIKit

/// A renderer that creates and configures cell for a table view
public protocol TableCellRenderer {
    func renderCell(in tableView: UITableView) -> UITableViewCell
}

/// A section in a table view
public struct TableSection {
    let name: String?
    let cells: [TableCellRenderer]
}

