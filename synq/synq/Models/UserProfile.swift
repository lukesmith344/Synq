import Foundation
import FirebaseFirestore

struct UserProfile: Codable, Identifiable {
    let id: String // This will be the Firebase UID
    let uid: String
    let name: String
    let username: String
    let birthday: Date
    let createdAt: Timestamp
    let onboardingComplete: Bool
    
    init(id: String, uid: String, name: String, username: String, birthday: Date, onboardingComplete: Bool = false) {
        self.id = id
        self.uid = uid
        self.name = name
        self.username = username
        self.birthday = birthday
        self.createdAt = Timestamp()
        self.onboardingComplete = onboardingComplete
    }
    
    // Custom coding keys to handle the id field mapping
    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case name
        case username
        case birthday
        case createdAt
        case onboardingComplete
    }
    
    // Custom initializer for Firestore decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        uid = try container.decode(String.self, forKey: .uid)
        name = try container.decode(String.self, forKey: .name)
        username = try container.decode(String.self, forKey: .username)
        birthday = try container.decode(Date.self, forKey: .birthday)
        createdAt = try container.decode(Timestamp.self, forKey: .createdAt)
        onboardingComplete = try container.decode(Bool.self, forKey: .onboardingComplete)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(uid, forKey: .uid)
        try container.encode(name, forKey: .name)
        try container.encode(username, forKey: .username)
        try container.encode(birthday, forKey: .birthday)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(onboardingComplete, forKey: .onboardingComplete)
    }
} 