//
//  File.swift
//  
//
//  Created by rickb on 6/10/22.
//

import Foundation

public enum GameStateEntry {
	case keyArray(String, [GameStateEntry])
	case array([GameStateEntry])
	case keyValue(String, String)
	case value(String)
}

public extension GameStateEntry {

	func toJSON() -> Any {
		switch self {
		case let .keyArray(key, entries):
			return [key: entries.map { $0.toJSON() }]
		case let .array(entries):
			return entries.map { $0.toJSON() }
		case let .keyValue(key, value):
			return [key: value]
		case let .value(value):
			return value
		}
	}
}
