import XCTest
@testable import StellarisKit

final class StellarisKitTests: XCTestCase {
    func testExample() throws {
		let url = Bundle.module.url(forResource: "gamestate", withExtension: nil, subdirectory: "savegame")!
		let string = String(data: try! Data(contentsOf: url), encoding: .utf8)!
		let entries = GameStateParser(string).parse()
		entries.forEach { $0.toJSON()}
    }
}
