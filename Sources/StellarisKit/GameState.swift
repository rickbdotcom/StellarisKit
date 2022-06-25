//
//  File.swift
//  
//
//  Created by rickb on 6/12/22.
//

import Foundation

public class GameState {
	let entry: ParadoxFileEntry

	public init(url: URL) throws {
		entry = try ParadoxFileParser(url: url).parse()
	}
}

public extension GameState {

	func planet(byId planetId: String) -> ParadoxFileEntry? {
		entry.entry(forKey: "planets")?.entry(forKey: "planet")?.entry(forKey: planetId)
	}

	func planets(ownedBy ownerId: String) -> [ParadoxFileEntry] {
		entry.entry(forKey: "planets")?.entry(forKey: "planet")?.entries?.filter {
			$0.entry(forKey: "owner")?.value == ownerId
		} ?? []
	}

	func pop(byId popId: String) -> ParadoxFileEntry? {
		entry.entry(forKey: "pop")?.entry(forKey: popId)
	}

	func species(byId speciesId: String) -> ParadoxFileEntry? {
		entry.entry(forKey: "species_db")?.entry(forKey: speciesId)
	}
}
