//
//  File.swift
//  
//
//  Created by rickb on 6/10/22.
//

import Foundation

public enum ParadoxFileEntry {
	case keyArray(String, [ParadoxFileEntry])
	case array([ParadoxFileEntry])
	case keyValue(String, String)
	case value(String)
}

public extension ParadoxFileEntry {

	var key: String? {
		switch self {
		case let .keyArray(key, _):
			return key
		case .array:
			return nil
		case let .keyValue(key, _):
			return key
		case .value:
			return nil
		}
	}

	var value: String? {
		switch self {
		case .keyArray:
			return key
		case .array:
			return nil
		case let .keyValue(_, value):
			return value
		case let .value(value):
			return value
		}
	}

	var entries: [ParadoxFileEntry]? {
		switch self {
		case let .keyArray(_, entries):
			return entries
		case let .array(entries):
			return entries
		case .keyValue:
			return nil
		case .value:
			return nil
		}
	}

	func entry(forKey key: String) -> ParadoxFileEntry? {
		switch self {
		case let .keyArray(_, entries):
			return entries.first { $0.key == key }
		case let .array(entries):
			return entries.first { $0.key == key }
		case .keyValue:
			return nil
		case .value:
			return nil
		}
	}

	func entry(atIndex index: Int) -> ParadoxFileEntry? {
		switch self {
		case let .keyArray(_, entries):
			if index >= 0 && index < entries.count {
				return entries[index]
			} else {
				return nil
			}
		case let .array(entries):
			if index >= 0 && index < entries.count {
				return entries[index]
			} else {
				return nil
			}
		case .keyValue:
			return nil
		case .value:
			return nil
		}
	}

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
