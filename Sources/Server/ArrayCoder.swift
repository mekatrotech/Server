//
//  ArrayCoder.swift
//  UlakAPI
//
//  Created by Muhammet Mehmet Emin Kartal on 6/26/19.
//  Copyright © 2019 ilao.co. All rights reserved.
//

import Foundation

class ArrayCoder: NSObject {
	static func encode<T: Decodable>(object: Any, to: T.Type) throws -> T {
		return try JSONDecoder().decode(T.self, from: try JSONSerialization.data(withJSONObject: object, options: []))
	}

	static func decode<T: Encodable>(object: T) throws -> Any {
		return try JSONSerialization.jsonObject(with: try JSONEncoder().encode(object), options: [])
	}
}
