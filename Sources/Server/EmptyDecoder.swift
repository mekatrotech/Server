//
//  File 2.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 7/5/19.
//

import Foundation

// - decoders all the way down
class EmptyRequestReader<K : CodingKey>: KeyedDecodingContainerProtocol {
	typealias Key = K
	var codingPath: [CodingKey] = []
	var allKeys: [Key] = []
	let parent: EmptyDecoder

	init(_ p: EmptyDecoder) {
		parent = p
	}

	func contains(_ key: Key) -> Bool {
		return true
	}
	func decodeNil(forKey key: Key) throws -> Bool {
		return true
	}
	func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
		return false
	}
	func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
		return 0
	}
	func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
		return 0
	}
	func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
		return 0
	}
	func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
		return 0
	}
	func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
		return 0
	}
	func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
		return 0
	}
	func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
		return 0
	}
	func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
		return 0
	}
	func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
		return 0
	}
	func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
		return 0
	}
	func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
		return 0.0
	}
	func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
		return 0.0
	}
	func decode(_ type: String.Type, forKey key: Key) throws -> String {
		return ""
	}
	func decode<T>(_ t: T.Type, forKey key: Key) throws -> T where T : Decodable {
		return try T.init(from: parent)
	}
	func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
		fatalError("Unimplimented")
	}
	func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
		fatalError("Unimplimented")
	}
	func superDecoder() throws -> Decoder {
		fatalError("Unimplimented")
	}
	func superDecoder(forKey key: Key) throws -> Decoder {
		fatalError("Unimplimented")
	}
}

class EmptyRequestUnkeyedReader: UnkeyedDecodingContainer, SingleValueDecodingContainer {
	let codingPath: [CodingKey] = []
	var count: Int? = 1
	var isAtEnd: Bool { return currentIndex != 0 }
	var currentIndex: Int = 0
	let parent: EmptyDecoder
	var decodedType: Any.Type?
	var typeDecoder: EmptyDecoder?
	init(parent p: EmptyDecoder) {
		parent = p
	}
	func advance(_ t: Any.Type) {
		currentIndex += 1
		decodedType = t
	}
	func decodeNil() -> Bool {
		return false
	}
	func decode(_ type: Bool.Type) throws -> Bool {
		advance(type)
		return false
	}
	func decode(_ type: Int.Type) throws -> Int {
		advance(type)
		return 0
	}
	func decode(_ type: Int8.Type) throws -> Int8 {
		advance(type)
		return 0
	}
	func decode(_ type: Int16.Type) throws -> Int16 {
		advance(type)
		return 0
	}
	func decode(_ type: Int32.Type) throws -> Int32 {
		advance(type)
		return 0
	}
	func decode(_ type: Int64.Type) throws -> Int64 {
		advance(type)
		return 0
	}
	func decode(_ type: UInt.Type) throws -> UInt {
		advance(type)
		return 0
	}
	func decode(_ type: UInt8.Type) throws -> UInt8 {
		advance(type)
		return 0
	}
	func decode(_ type: UInt16.Type) throws -> UInt16 {
		advance(type)
		return 0
	}
	func decode(_ type: UInt32.Type) throws -> UInt32 {
		advance(type)
		return 0
	}
	func decode(_ type: UInt64.Type) throws -> UInt64 {
		advance(type)
		return 0
	}
	func decode(_ type: Float.Type) throws -> Float {
		advance(type)
		return 0
	}
	func decode(_ type: Double.Type) throws -> Double {
		advance(type)
		return 0
	}
	func decode(_ type: String.Type) throws -> String {
		advance(type)
		return ""
	}
	func decode<T: Decodable>(_ type: T.Type) throws -> T {
		advance(type)
		return try T(from: parent)
	}
	func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
		fatalError("Unimplimented")
	}
	func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
		fatalError("Unimplimented")
	}
	func superDecoder() throws -> Decoder {
		currentIndex += 1
		return parent
	}
}

class EmptyDecoder: Decoder {
	var codingPath: [CodingKey] = []
	var userInfo: [CodingUserInfoKey : Any] = [:]

	func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
		return KeyedDecodingContainer<Key>(EmptyRequestReader<Key>(self))
	}
	func unkeyedContainer() throws -> UnkeyedDecodingContainer {
		return EmptyRequestUnkeyedReader(parent: self)
	}
	func singleValueContainer() throws -> SingleValueDecodingContainer {
		return EmptyRequestUnkeyedReader(parent: self)
	}
}


private extension Date {
	func iso8601() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
		let ret = dateFormatter.string(from: self) + "Z"
		return ret
	}
	init?(fromISO8601 string: String) {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.timeZone = TimeZone.current
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		if let d = dateFormatter.date(from: string) {
			self = d
			return
		}
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSx"
		if let d = dateFormatter.date(from: string) {
			self = d
			return
		}
		return nil
	}
}
