import XCTest
@testable import FamilyTigerPass

final class DecodeRouteTests: XCTestCase {
    func testPackDecodes() {
        let link = "https://example.test/go"
        let route = AppSession.decodePayload(AppConfig.encodePack(link))
        XCTAssertEqual(route?.url, link)
        XCTAssertEqual(route?.enabled, true)
    }

    func testPlainLinkIsIgnored() {
        XCTAssertNil(AppSession.decodePayload(Data("https://example.test/go".utf8)))
    }

    func testQuotedJSONStringIsIgnored() {
        XCTAssertNil(AppSession.decodePayload(Data("\"https://example.test/go?ref=abc\"".utf8)))
    }

    func testPackKeepsQuery() {
        let raw = "https://example.test/v3/route/?ref=6a918336a256a10001818e1b&q=keep"
        XCTAssertEqual(AppSession.decodePayload(AppConfig.encodePack(raw))?.url, raw)
    }

    func testPackAllowsTrailingNewline() {
        let link = "https://example.test/go"
        var pack = AppConfig.encodePack(link)
        pack.append(contentsOf: "\n".utf8)
        XCTAssertEqual(AppSession.decodePayload(pack)?.url, link)
    }

    func testBareBase64IsIgnored() {
        let mixed = Data("https://example.test/go".utf8).base64EncodedString()
        XCTAssertNil(AppSession.decodePayload(Data(mixed.utf8)))
    }

    func testNeighborMarkIsIgnored() {
        let link = "https://example.test/go"
        let pack = AppConfig.encodePack(link)
        guard let raw = String(data: pack, encoding: .utf8) else {
            return XCTFail("pack should be utf8")
        }
        let blob = String(raw.dropFirst(AppKeys.packMark.count))
        XCTAssertNil(AppSession.decodePayload(Data(("p1." + blob).utf8)))
        XCTAssertNil(AppSession.decodePayload(Data(("k9." + blob).utf8)))
    }

    func testEmptyObjectIsIgnored() {
        XCTAssertNil(AppSession.decodePayload(Data("{}".utf8)))
    }

    func testGarbageIsIgnored() {
        XCTAssertNil(AppSession.decodePayload(Data("not-json".utf8)))
        XCTAssertNil(AppSession.decodePayload(Data("".utf8)))
    }

    func testNestedObjectsAreIgnored() {
        XCTAssertNil(AppSession.decodePayload(Data("{\"content\":\"https://example.test/go\"}".utf8)))
        XCTAssertNil(AppSession.decodePayload(Data("{\"dest\":\"https://example.test/go\"}".utf8)))
        let nested = Data("{\"pages\":{\"start\":{\"enabled\":true,\"url\":\"https://example.test/go\"}}}".utf8)
        XCTAssertNil(AppSession.decodePayload(nested))
    }

    func testRelativePathIsIgnored() {
        XCTAssertNil(AppSession.decodePayload(Data("/privacy/".utf8)))
    }

    func testBrandContract() {
        XCTAssertEqual(AppKeys.headerName(), "Authorization")
        XCTAssertEqual(AppKeys.authScheme, "Bearer ")
        XCTAssertNotEqual(AppKeys.headerName(), "content")
        XCTAssertEqual(AppKeys.packMark, "kcal.")
        XCTAssertNotEqual(AppKeys.packMark, "p1.")
        XCTAssertNotEqual(AppKeys.packMark, "k9.")
        XCTAssertTrue(AppKeys.cacheEntryKey.hasPrefix("ftp_"))
        let headers = AppConfig.headers
        XCTAssertEqual(headers?.first?.name, "Authorization")
        XCTAssertTrue(headers?.first?.value.hasPrefix("Bearer ") == true)
        XCTAssertGreaterThan(headers?.first?.value.count ?? 0, "Bearer ".count)
        XCTAssertEqual(
            AppConfig.serviceURL,
            "https://familytigerpass.pages.dev/privacy/"
        )
    }
}
