import UIKit

enum ProfileCellRenderer: TableCellRenderer {
    case text(String)
    case textAndImage(text: String, image: UIImage)
    case textAndImageModal(text: String, image: UIImage) // Text and image without disclosure

    var identifier: String {
        switch self {
            case .text(_):
                return "TextCell"
            case .textAndImage(text: _, image: _):
                return "TextAndImageCell"
            case .textAndImageModal(text: _, image: _):
                return "CextAndImageModalCell"
        }
    }
    
    private func renderTextCell(with text: String, in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
             ?? UITableViewCell(style: .value1, reuseIdentifier: identifier)
        cell.textLabel?.text = text
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    private func renderTextAndImageCell(with text: String, image: UIImage,
            in tableView: UITableView) -> TextAndImageCell {
        
        var cell: TextAndImageCell
        if let reusedCell =
                tableView.dequeueReusableCell(withIdentifier: identifier)
                as? TextAndImageCell {
            cell = reusedCell
        } else {
            cell = Bundle.main.loadFromXib("TextAndImageCell", owner: nil)!
        }

        cell.textName.text = text
        cell.systemImage.image = image
        cell.imageView?.contentMode = .scaleAspectFit
        
        return cell
    }

    func renderCell(in tableView: UITableView) -> UITableViewCell {
        switch self {
            case .text(let text):
                return self.renderTextCell(with: text, in: tableView)
            case .textAndImage(text: let text, image: let image):
                let cell = self.renderTextAndImageCell(with: text, image: image, in: tableView)
                cell.accessoryType = .disclosureIndicator
                return cell
            case .textAndImageModal(text: let text, image: let image):
                let cell = self.renderTextAndImageCell(with: text, image: image, in: tableView)
                cell.accessoryType = .none
                cell.textName.textColor = UIColor.blue
                return cell
        }
    }
}
