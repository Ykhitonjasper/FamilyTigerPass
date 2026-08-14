import Foundation
import UIKit

enum ProjectPDF {
    static func make(project: Project) -> Data {
        let page = CGRect(x: 0, y: 0, width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: page)
        let items = project.lineItems.sorted(by: { $0.createdAt < $1.createdAt })
        return renderer.pdfData { ctx in
            ctx.beginPage()
            var y: CGFloat = 36
            y = draw(AppThemePDF.displayName, font: .boldSystemFont(ofSize: 18), at: 36, y: y, width: 540)
            y = draw(project.name, font: .systemFont(ofSize: 16), at: 36, y: y + 8, width: 540)
            y = draw(project.summary, font: .systemFont(ofSize: 12), at: 36, y: y + 6, width: 540)
            y += 16
            for item in items {
                if y > 700 {
                    draw(EstimateNote.text, font: .italicSystemFont(ofSize: 10), at: 36, y: 750, width: 540)
                    ctx.beginPage()
                    y = 36
                }
                y = draw(item.title, font: .boldSystemFont(ofSize: 13), at: 36, y: y, width: 540)
                y = draw(item.summary, font: .systemFont(ofSize: 12), at: 36, y: y + 4, width: 540)
                for pair in JSONPretty.fields(from: item.detailJSON).prefix(6) {
                    y = draw("\(pair.0): \(pair.1)", font: .systemFont(ofSize: 10), at: 48, y: y + 2, width: 520)
                }
                y += 14
            }
            draw(EstimateNote.text, font: .italicSystemFont(ofSize: 10), at: 36, y: min(y + 12, 750), width: 540)
        }
    }

    @discardableResult
    private static func draw(_ text: String, font: UIFont, at x: CGFloat, y: CGFloat, width: CGFloat) -> CGFloat {
        let ns = text as NSString
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black,
        ]
        let bound = ns.boundingRect(
            with: CGSize(width: width, height: 200),
            options: [.usesLineFragmentOrigin],
            attributes: attrs,
            context: nil
        )
        ns.draw(in: CGRect(x: x, y: y, width: width, height: ceil(bound.height)), withAttributes: attrs)
        return y + ceil(bound.height)
    }
}

enum AppThemePDF {
    static var displayName: String { AppTheme.displayName }
}

enum ProjectCSV {
    static func make(project: Project) -> Data {
        var lines = ["title,calculatorType,summary,createdAt"]
        let formatter = ISO8601DateFormatter()
        for item in project.lineItems.sorted(by: { $0.createdAt < $1.createdAt }) {
            let title = escape(item.title)
            let kind = escape(item.calculatorType)
            let summary = escape(item.summary)
            let created = formatter.string(from: item.createdAt)
            lines.append("\(title),\(kind),\(summary),\(created)")
        }
        return (lines.joined(separator: "\n") + "\n").data(using: .utf8) ?? Data()
    }

    private static func escape(_ raw: String) -> String {
        if raw.contains(",") || raw.contains("\"") {
            return "\"\(raw.replacingOccurrences(of: "\"", with: "\"\""))\""
        }
        return raw
    }
}
