import Foundation

enum ProjectText {
    static func make(project: Project) -> String {
        var lines: [String] = []
        lines.append(AppTheme.displayName)
        lines.append(project.name)
        lines.append(project.summary)
        lines.append("")
        let items = project.lineItems.sorted(by: { $0.createdAt < $1.createdAt })
        for item in items {
            lines.append("• \(item.title)")
            lines.append("  \(item.summary)")
            lines.append("")
        }
        lines.append(EstimateNote.text)
        return lines.joined(separator: "\n")
    }
}

enum JSONPretty {
    static func fields(from detailJSON: String) -> [(String, String)] {
        guard let data = detailJSON.data(using: .utf8),
              let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return [] }
        var pairs: [(String, String)] = []
        if let inputs = object["inputs"] as? [String: Any] {
            for key in inputs.keys.sorted() {
                pairs.append((key, stringify(inputs[key])))
            }
        }
        if let outputs = object["outputs"] as? [String: Any] {
            for key in outputs.keys.sorted() {
                pairs.append((key, stringify(outputs[key])))
            }
        }
        return pairs
    }

    private static func stringify(_ value: Any?) -> String {
        guard let value else { return "—" }
        if let n = value as? NSNumber { return n.stringValue }
        if let s = value as? String { return s }
        if let b = value as? Bool { return b ? "yes" : "no" }
        return String(describing: value)
    }
}
