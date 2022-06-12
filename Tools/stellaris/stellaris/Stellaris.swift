//
//  main.swift
//  stellaris
//
//  Created by rickb on 6/11/22.
//

import ArgumentParser
import Foundation
import StellarisKit

@main
struct Stellaris: ParsableCommand {
    @Argument var inputFile: String

	@Option(name: [.long])
	var json: String?

    mutating func run() throws {
		let data = try Data(contentsOf: URL(fileURLWithPath: inputFile))
		guard let string = String(data: data, encoding: .utf8) else {
			return
		}
		let entries = GameStateParser(string).parse()

		if let json = json {
			try convertToJson(entries: entries, path: json)
		}
   }

   func convertToJson(entries: [GameStateEntry], path: String) throws {
	   let json = entries[0...6].map { $0.toJSON() }
	   let data = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .fragmentsAllowed])
	   try data.write(to: URL(fileURLWithPath: path))
   }
}
