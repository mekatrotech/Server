//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 7/6/19.
//

import Foundation

import PerfectHTTP
import PerfectHTTPServer
import MySQLDriver


public struct Empty: Codable {
	public init() {

	}
}
public struct Successful: Codable {
	public init() {

	}
}

public protocol Endpoint {
	static var method: HTTPMethod { get }
	static var uri: String { get }

	func handle(request: HTTPRequest, with parameters: Parameters) throws -> Responce
	associatedtype Responce: Codable = Successful
	associatedtype Parameters: Codable = Empty
	init()
}


/// Root object that returns from the API
public enum APIResponce<Type: Codable>: Codable {


	enum CodingKeys: CodingKey {
		case success
		case failed
	}


	/// When request is successful
	case success(data: Type)
	/// When the server responded with failure message
	// case failed(message: String, code: Int)
	/// When other errors occur (Network connectivity etc..)
	case failed(message: String)
	case errored(error: Error)

	enum PostTypeCodingError: Error {
		case decoding(String)
		case encoding(String)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		switch self {
		case .success(let data):
			try container.encode(data, forKey: .success)
		case .failed(let message):
			try container.encode(message, forKey: .failed)
		case .errored(_):
			throw PostTypeCodingError.encoding("Cannot encode errored state!")
		}
	}


	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)


		if let value = try? values.decode(String.self, forKey: .failed) {
			self = .failed(message: value)
			return
		}

		let value = try values.decode(Type.self, forKey: .success)
		self = .success(data: value)

		// throw PostTypeCodingError.decoding("Error Decoding! \(dump(values))")
	}

	init(catching f: (() throws -> Type) ) {
		do {
			self = .success(data: try f())
		} catch {
			self = .errored(error: error)
		}
	}
}
