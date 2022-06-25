import XCTest
@testable import StellarisKit

final class StellarisKitTests: XCTestCase {
    func testExample() throws {
		let url = Bundle.module.url(forResource: "gamestate", withExtension: nil, subdirectory: "savegame")!
		let gameState = try GameState(url: url)
		print(gameState.planets(ownedBy: "0").count)
    }
}
