import UIKit

public struct UserProfile {
    public let name: String
    public let picture: UIImage
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    public var userProfile: UserProfile? {
        didSet {
            self.update()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func update() {
        let _ = self.view // Make sure the view is loaded
        self.userNameLabel.text = self.userProfile?.name
        self.userPicture.image = self.userProfile?.picture
        self.buildTableData()
    }
    
    private var tableData: [TableSection] = []
    private func buildTableData() {
        let cells1: [ProfileCellRenderer] =
            [
            .text("Name, Phone Numbers, Email"),
            .text("Password & Security"),
            .text("Payment & Shipping")
            ]
        let section1 = TableSection(name: nil, cells: cells1)
        
        let cells2: [ProfileCellRenderer] =
            [
            .textAndImage(text: "iCloud", image: UIImage(named: "Image3")!),
            .textAndImage(text: "iTunes & App Store", image: UIImage(named: "Image4")!),
            .textAndImageModal(text: "Set Up Family Sharing...", image: UIImage(named: "Image1")!)
            ]
        let section2 = TableSection(name: nil, cells: cells2)
        
        self.tableData = [section1, section2]
        self.tableView.reloadData()
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
            shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46.0
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < self.tableData.count else { return 0 }
        return self.tableData[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = self.tableData[indexPath.section].cells[indexPath.row]
        return cellData.renderCell(in: tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0//(section == 0 ? 0 : UITableViewAutomaticDimension)
    }
}
