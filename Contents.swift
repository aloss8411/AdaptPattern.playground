import UIKit

struct UserInfomation: Codable {
    var id: Int
    var name: String
    var birth: Date?
    var email: String
    var company: String
}

protocol UserNameAndEmailCompatible {
    var name: String { get }
    var email: String { get }
}

class UserAdapter: UserNameAndEmailCompatible {
    
    private let user: UserInfomation
    
    var name: String {
        return user.name
    }
    
    var email: String {
        return user.email
    }
    
    init(user: UserInfomation) {
        self.user = user
    }
  
}

class UserManager {
    func fetchUsers(completion: @escaping ([UserInfomation]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let users = [
                UserInfomation(id: 1, name: "John", email: "aa", company: "ic")
            ]
            completion(users)
        }
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var adaptedUsers: [UserNameAndEmailCompatible] = []
    private let apiService = UserManager()
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        apiService.fetchUsers { [weak self] apiUsers in
            self?.adaptedUsers = apiUsers.map { UserAdapter(user: $0) }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adaptedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "UserCell")
        
        let user = adaptedUsers[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        return cell
    }
}
