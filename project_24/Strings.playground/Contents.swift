import UIKit

let name = "Taylor"

for letter in name {
    print("Give me a \(letter)!")
}

let letter = name[name.index(name.startIndex, offsetBy: 3)]

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }

    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }

    func deletingSufix(_ sufix: String) -> String {
        guard self.hasSuffix(sufix) else { return self }
        return String(self.dropFirst(sufix.count))
    }

    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }

    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}

let letter2 = name[3] // this can be doe because of the extension above

let password = "12345"
password.hasPrefix("123")
password.hasSuffix("456")

let weather = "it's going to rain"
print(weather.capitalized) // Capitalize first letter of each word

// Contains return true if a string contains another string
let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Swift", "Ruby"]
languages.contains("Swift")

languages.contains(where: input.contains) // Work same as the extension 'containsAny'

// NSAttributedString
let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)
let mutableString = NSMutableAttributedString(string: string)
mutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
mutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
mutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
mutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
mutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))
