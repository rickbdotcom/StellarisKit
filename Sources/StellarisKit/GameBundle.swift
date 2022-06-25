//
//  File.swift
//  
//
//  Created by rickb on 6/12/22.
//

import Foundation

public class GameBundle {
	public let baseURL: URL

	public init(baseURL: URL) {
		self.baseURL = baseURL
	}
}

public extension GameBundle {

	var commonURL: URL {
		baseURL.appendingPathComponent("common")
	}

	var traitsURL: URL {
		commonURL.appendingPathComponent("traits")
	}
}
