import Foundation
import Contacts

class ContactsManager: ObservableObject {
    @Published var matchedContacts: [String] = []
    @Published var permissionDenied = false
    
    private let store = CNContactStore()
    
    func requestAndFetchContacts() {
        store.requestAccess(for: .contacts) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    self.fetchContacts()
                } else {
                    self.permissionDenied = true
                }
            }
        }
    }
    
    private func fetchContacts() {
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        var names: [String] = []
        do {
            try store.enumerateContacts(with: request) { contact, stop in
                let fullName = "\(contact.givenName) \(contact.familyName)".trimmingCharacters(in: .whitespaces)
                if !fullName.isEmpty {
                    names.append(fullName)
                }
            }
            self.matchedContacts = names
        } catch {
            print("Failed to fetch contacts:", error)
        }
    }
} 