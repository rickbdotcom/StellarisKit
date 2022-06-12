//
//  File.swift
//  
//
//  Created by rickb on 6/10/22.
//

import Foundation

public extension GameStateParser {

	func parse() -> [GameStateEntry] {
		var entries = [GameStateEntry]()
		while let entry = nextEntry() {
			entries.append(entry)
		}
		return entries
	}
}

public class GameStateParser {
	var lines: [String]
	var lineCount = 0
	var skip = false

	public init(_ lines: String) {
		self.lines = lines.components(separatedBy: "\n")
			.lazy
			.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
			.filter { $0.isEmpty == false }
	}

	func nextLine() -> String? {
		guard lineCount < lines.count else {
			return nil
		}
		let line = lines[lineCount]
		lineCount += 1
		return line
	}

	func nextEntry() -> GameStateEntry? {
		if skip {
			skip = false
			return nil
		}
		guard let line = nextLine() else {
			return nil
		}
		return parseLine(line)
	}

	func parseLine(_ line: String) -> GameStateEntry? {
		guard line.isEmpty == false else { return nil }
		let components = line.components(separatedBy: "=")
		if components.count == 1 {
			let value = components[0]
			if value == "{" {
				var entries = [GameStateEntry]()
				while let entry = nextEntry() {
					entries.append(entry)
				}
				return .array(entries)
			} else if value == "}" {
				return nil
			} else {
				return .value(value)
			}
		} else {
			if String(line.suffix(1)) == "}" {
				let entries = line.components(separatedBy: .whitespacesAndNewlines).dropLast().compactMap {
					parseLine($0)
				}
				skip = true
				return .array(entries)
			}

			let key = components[0]
			let value = components.dropFirst().joined(separator: "")
			if value == "{" {
				var entries = [GameStateEntry]()
				while let entry = nextEntry() {
					entries.append(entry)
				}
				return .keyArray(key, entries)
			} else if value == "}" {
				return nil
			} else {
				return .keyValue(key, value)
			}
		}
	}
}

