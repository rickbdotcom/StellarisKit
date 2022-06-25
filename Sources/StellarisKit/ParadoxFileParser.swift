//
//  File.swift
//  
//
//  Created by rickb on 6/10/22.
//

import Foundation

public extension ParadoxFileParser {

	func parse() -> ParadoxFileEntry {
		var entries = [ParadoxFileEntry]()
		while let entry = nextEntry() {
			entries.append(entry)
		}
		return .array(entries)
	}
}

public class ParadoxFileParser {
	var lines: [String]
	var lineCount = 0
	var skip = false

	public convenience init(url: URL) throws {
		let lines = String(data: try Data(contentsOf: url), encoding: .utf8) ?? ""
		self.init(lines)
	}

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

	func nextEntry() -> ParadoxFileEntry? {
		if skip {
			skip = false
			return nil
		}
		guard let line = nextLine() else {
			return nil
		}
		return parseLine(line)
	}

	func parseLine(_ line: String) -> ParadoxFileEntry? {
		guard line.isEmpty == false else { return nil }

		let components = line.components(separatedBy: "=")
		if components.count == 1 {
			let value = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
			if value == "{" {
				var entries = [ParadoxFileEntry]()
				while let entry = nextEntry() {
					entries.append(entry)
				}
				return .array(entries)
			} else if value == "}" {
				return nil
			} else if String(line.suffix(1)) == "{" { // has no =
				let key = line.components(separatedBy: .whitespacesAndNewlines)[0].trimmingCharacters(in: .whitespacesAndNewlines)
				var entries = [ParadoxFileEntry]()
				while let entry = nextEntry() {
					entries.append(entry)
				}
				return .keyArray(key, entries)
			} else {
				return .value(value)
			}
		} else {
			let key = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
			let value = components.dropFirst().joined(separator: "=").trimmingCharacters(in: .whitespacesAndNewlines)
			if value == "{" {
				var entries = [ParadoxFileEntry]()
				while let entry = nextEntry() {
					entries.append(entry)
				}
				return .keyArray(key, entries)
			} else if value.prefix(1) == "{" && value.suffix(1) == "}" {
				return .keyValue(key, value)
			} else if value.suffix(1) == "}" { // } is not on separate line
				skip = true
				return .keyValue(key, value[value.startIndex...value.index(value.endIndex, offsetBy: -1)].trimmingCharacters(in: .whitespacesAndNewlines))
			} else {
				return .keyValue(key, value)
			}
		}
	}
}

