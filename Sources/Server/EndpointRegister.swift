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


public extension Endpoint {
	var name: String {
		return String(describing: Self.self)
	}

	static func register(to routes: inout Routes) {


//		print("My Params Are: \(print_r(try! ArrayCoder.decode(object: try! Self.Parameters.init(from: EmptyDecoder()))))")
//		print("My Responce Is: \(print_r(try! ArrayCoder.decode(object: try! Self.Responce.init(from: EmptyDecoder()))))")

		print("Registering for: \(Self.method) \(Self.uri)")
		routes.add(method: Self.method, uri: Self.uri) { (request, responce) in

			let result = APIResponce.init { () -> Self.Responce in
				let decoded = try request.decode(Self.Parameters.self)
				print(decoded)
				return try Self.init().handle(request: request, with: decoded)
			}
			do {

				try responce.setBody(json: result)
				responce.completed(status: .ok)

			} catch {
				responce.completed(status: .internalServerError)
			}
		}
	}
}
