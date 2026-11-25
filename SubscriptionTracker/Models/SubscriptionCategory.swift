import Foundation

enum SubscriptionCategory: String, CaseIterable, Identifiable, Codable  {

    case entertainment = "Entertainment"
    case music = "Music"
    case education = "Education"
    case cloudStorage = "Cloud Storage"
    case news = "News"
    case other = "Other"

    var id: String {
        rawValue
    }
}
