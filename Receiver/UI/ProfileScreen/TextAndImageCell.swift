import UIKit

class TextAndImageCell: UITableViewCell {

    @IBOutlet weak var systemImage: UIImageView!
    
    @IBOutlet weak var textName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
