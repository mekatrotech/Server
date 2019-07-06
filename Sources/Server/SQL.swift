//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 7/3/19.
//

import Foundation
import MySQLDriver

public struct SQLString<PType> {
	let sqlData: String
	let params: [PartialKeyPath<PType>]
}

extension SQLString: ExpressibleByStringLiteral {
	public init(stringLiteral value: String) {
		self.sqlData = value
		self.params = []
	}
}

public struct SQLStatement {
	var sql: String
	var values: [Any]
}

extension SQLString: CustomStringConvertible {
	public var description: String {
		return "SQL<\(params.count) Parameters>\(self.sqlData)"
	}
}

extension SQLString: ExpressibleByStringInterpolation {
	public struct StringInterpolation: StringInterpolationProtocol {
		var parts: [String]

		var parameters: [PartialKeyPath<PType>]

		public init(literalCapacity: Int, interpolationCount: Int) {
			self.parts = []
			self.parameters = []
			self.parts.reserveCapacity(2*interpolationCount+1)
		}

		mutating public func appendLiteral(_ literal: String) {
			self.parts.append(literal)
		}

		mutating public func appendInterpolation(_ keypath: PartialKeyPath<PType>) {
			self.parts.append("?")
			self.parameters.append(keypath)
		}

	}

	public init(stringInterpolation: StringInterpolation) {
		self.sqlData = stringInterpolation.parts.joined()
		self.params = stringInterpolation.parameters
	}

	func generateStatement(from container: PType) -> SQLStatement {
		var values: [Any] = []
		values.reserveCapacity(params.count)

		for i in params.enumerated() {
			values.append(container[keyPath: i.element])
		}
		return SQLStatement(sql: self.sqlData, values: values)
	}
}

public protocol SQLAction: Codable {
	static var SQLString: SQLString<Self> { get }
}

public extension SQLAction {
	var statement: SQLStatement {
		return Self.SQLString.generateStatement(from: self)
	}

	func run(with connection: MySQL.Connection = .default) throws {
		let statements = self.statement
//		print(statements)

		statements.values.count == 0 ? try connection.exec(statements.sql) :
			try connection.prepare(statements.sql).exec(statements.values)

	}
}

public protocol SQLView {
	static var SQLString: SQLString<Self> { get }
	associatedtype Result: Decodable

}

enum DataRetrivalError: Error {
	case noDataFound
}

public extension SQLView {
	var statement: SQLStatement {
		return Self.SQLString.generateStatement(from: self)
	}

	func getOne(with connection: MySQL.Connection = .default) throws -> Result? {
		let statements = self.statement

		let result: MysqlResult = statements.values.count == 0 ? try connection.query(statements.sql) :
			try connection.prepare(statements.sql).query(statements.values)


		if let row = try result.readRow() {
			return try Self.decode(row: row)
		}

		return nil
	}

	private static func decode(row: MySQL.Row) throws -> Self.Result{
//		print("Decoding: row \(row)")
		return try ArrayCoder.encode(object: row as Any, to: Result.self)
	}

	func getAll(with connection: MySQL.Connection = .default) throws -> [Result] {
		let statements = self.statement

		let result: MysqlResult = statements.values.count == 0 ? try connection.query(statements.sql) :
			try connection.prepare(statements.sql).query(statements.values)

		var output: [Result] = []
		while let row = try result.readRow() {
			output.append(try Self.decode(row: row))
		}
		return output
	}
}


public extension MySQL {
	static var `default` = MySQL.Connection()
}

public extension MySQL.Connection {
	static var `default` = MySQL.default
}
