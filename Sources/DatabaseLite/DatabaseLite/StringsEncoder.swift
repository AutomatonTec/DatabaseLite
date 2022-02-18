//
//  StringsEncoder.swift
//  StringsEncoder
//
//  Created by Mark Morrill on 2021-08-03.
//

import Foundation

/// An object that encodes instances of a data type
/// as strings following the simple strings file format.
public class StringsEncoder {
    
    public init() {
        
    }
    
    /// Returns a strings file-encoded representation of the specified value.
    public func encode<T: Encodable>(_ value: T) throws -> String {
        let stringsEncoding = StringsEncoding()
        try value.encode(to: stringsEncoding)
        return dotStringsFormat(from: stringsEncoding.data.strings)
    }
    
    private func dotStringsFormat(from strings: [String: String]) -> String {
        var dotStrings = strings.map { "\"\($0)\" = \"\($1)\";" }
        dotStrings.sort()
        dotStrings.insert("/* Generated by StringsEncoder */", at: 0)
        return dotStrings.joined(separator: "\n")
    }
}

fileprivate struct StringsEncoding: Encoder {
    
    /// Stores the actual strings file data during encoding.
    fileprivate final class Data {
        private(set) var strings: [String: String] = [:]
        
        public func encode(key codingKey: [CodingKey], value: String) {
            let key = codingKey.map { $0.stringValue }.joined(separator: ".")
            strings[key] = value
        }
    }
    
    fileprivate var data: Data
    
    init(to encodedData: Data = Data()) {
        self.data = encodedData
    }

    var codingPath: [CodingKey] = []
    
    let userInfo: [CodingUserInfoKey : Any] = [:]
    
    public func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
        var container = StringsKeyedEncoding<Key>(to: data)
        container.codingPath = codingPath
        return KeyedEncodingContainer(container)
    }
    
    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        var container = StringsUnkeyedEncoding(to: data)
        container.codingPath = codingPath
        return container
   }
    
    public func singleValueContainer() -> SingleValueEncodingContainer {
        var container = StringsSingleValueEncoding(to: data)
        container.codingPath = codingPath
        return container
    }
}

fileprivate struct StringsKeyedEncoding<Key: CodingKey>: KeyedEncodingContainerProtocol {

    private let data: StringsEncoding.Data
    
    init(to data: StringsEncoding.Data) {
        self.data = data
    }
    
    var codingPath: [CodingKey] = []
    
    mutating func encodeNil(forKey key: Key) throws {
        data.encode(key: codingPath + [key], value: "nil")
    }
    
    mutating func encode(_ value: Bool, forKey key: Key) throws {
        data.encode(key: codingPath + [key], value: value.description)
    }
    
    mutating func encode(_ value: String, forKey key: Key) throws {
        data.encode(key: codingPath + [key], value: value)
    }
    
    mutating func encode(_ value: Double, forKey key: Key) throws {
        data.encode(key: codingPath + [key], value: value.description)
    }
    
    mutating func encode(_ value: Float, forKey key: Key) throws {
        data.encode(key: codingPath + [key], value: value.description)
    }
    
    mutating func encode(_ value: Int, forKey key: Key) throws {
        data.encode(key: codingPath + [key], value: value.description)
    }
    
    mutating func encode(_ value: Int8, forKey key: Key) throws {
        data.encode(key: codingPath + [key], value: value.description)
    }
    
    mutating func encode(_ value: Int16, forKey key: Key) throws {
        data.encode(key: codingPath + [key], value: value.description)
    }
    
    mutating func encode(_ value: Int32, forKey key: Key) throws {
        data.encode(key: codingPath + [key], value: value.description)
    }
    
    mutating func encode(_ value: Int64, forKey key: Key) throws {
        data.encode(key: codingPath + [key], value: value.description)
    }
    
    mutating func encode(_ value: UInt, forKey key: Key) throws {
        data.encode(key: codingPath + [key], value: value.description)
    }
    
    mutating func encode(_ value: UInt8, forKey key: Key) throws {
        data.encode(key: codingPath + [key], value: value.description)
    }
    
    mutating func encode(_ value: UInt16, forKey key: Key) throws {
        data.encode(key: codingPath + [key], value: value.description)
    }
    
    mutating func encode(_ value: UInt32, forKey key: Key) throws {
        data.encode(key: codingPath + [key], value: value.description)
    }
    
    mutating func encode(_ value: UInt64, forKey key: Key) throws {
        data.encode(key: codingPath + [key], value: value.description)
    }
    
    mutating func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
        var stringsEncoding = StringsEncoding(to: data)
        stringsEncoding.codingPath.append(key)
        try value.encode(to: stringsEncoding)
    }
    
    mutating func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        var container = StringsKeyedEncoding<NestedKey>(to: data)
        container.codingPath = codingPath + [key]
        return KeyedEncodingContainer(container)
    }
    
    mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        var container = StringsUnkeyedEncoding(to: data)
        container.codingPath = codingPath + [key]
        return container
    }
    
    mutating func superEncoder() -> Encoder {
        let superKey = Key(stringValue: "super")!
        return superEncoder(forKey: superKey)
    }
    
    mutating func superEncoder(forKey key: Key) -> Encoder {
        var stringsEncoding = StringsEncoding(to: data)
        stringsEncoding.codingPath = codingPath + [key]
        return stringsEncoding
    }
}

fileprivate struct StringsUnkeyedEncoding: UnkeyedEncodingContainer {

    private let data: StringsEncoding.Data
    
    init(to data: StringsEncoding.Data) {
        self.data = data
    }
    
    var codingPath: [CodingKey] = []

    private(set) var count: Int = 0
    
    private mutating func nextIndexedKey() -> CodingKey {
        let nextCodingKey = IndexedCodingKey(intValue: count)!
        count += 1
        return nextCodingKey
    }
    
    private struct IndexedCodingKey: CodingKey {
        let intValue: Int?
        let stringValue: String

        init?(intValue: Int) {
            self.intValue = intValue
            self.stringValue = intValue.description
        }

        init?(stringValue: String) {
            return nil
        }
    }

    mutating func encodeNil() throws {
        data.encode(key: codingPath + [nextIndexedKey()], value: "nil")
    }
    
    mutating func encode(_ value: Bool) throws {
        data.encode(key: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    mutating func encode(_ value: String) throws {
        data.encode(key: codingPath + [nextIndexedKey()], value: value)
    }
    
    mutating func encode(_ value: Double) throws {
        data.encode(key: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    mutating func encode(_ value: Float) throws {
        data.encode(key: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    mutating func encode(_ value: Int) throws {
        data.encode(key: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    mutating func encode(_ value: Int8) throws {
        data.encode(key: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    mutating func encode(_ value: Int16) throws {
        data.encode(key: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    mutating func encode(_ value: Int32) throws {
        data.encode(key: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    mutating func encode(_ value: Int64) throws {
        data.encode(key: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    mutating func encode(_ value: UInt) throws {
        data.encode(key: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    mutating func encode(_ value: UInt8) throws {
        data.encode(key: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    mutating func encode(_ value: UInt16) throws {
        data.encode(key: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    mutating func encode(_ value: UInt32) throws {
        data.encode(key: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    mutating func encode(_ value: UInt64) throws {
        data.encode(key: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    mutating func encode<T: Encodable>(_ value: T) throws {
        var stringsEncoding = StringsEncoding(to: data)
        stringsEncoding.codingPath = codingPath + [nextIndexedKey()]
        try value.encode(to: stringsEncoding)
    }
    
    mutating func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        var container = StringsKeyedEncoding<NestedKey>(to: data)
        container.codingPath = codingPath + [nextIndexedKey()]
        return KeyedEncodingContainer(container)
    }
    
    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        var container = StringsUnkeyedEncoding(to: data)
        container.codingPath = codingPath + [nextIndexedKey()]
        return container
    }
    
    mutating func superEncoder() -> Encoder {
        var stringsEncoding = StringsEncoding(to: data)
        stringsEncoding.codingPath.append(nextIndexedKey())
        return stringsEncoding
    }
}

fileprivate struct StringsSingleValueEncoding: SingleValueEncodingContainer {
    
    private let data: StringsEncoding.Data
    
    init(to data: StringsEncoding.Data) {
        self.data = data
    }

    var codingPath: [CodingKey] = []
    
    mutating func encodeNil() throws {
        data.encode(key: codingPath, value: "nil")
    }
    
    mutating func encode(_ value: Bool) throws {
        data.encode(key: codingPath, value: value.description)
    }
    
    mutating func encode(_ value: String) throws {
        data.encode(key: codingPath, value: value)
    }
    
    mutating func encode(_ value: Double) throws {
        data.encode(key: codingPath, value: value.description)
    }
    
    mutating func encode(_ value: Float) throws {
        data.encode(key: codingPath, value: value.description)
    }
    
    mutating func encode(_ value: Int) throws {
        data.encode(key: codingPath, value: value.description)
    }
    
    mutating func encode(_ value: Int8) throws {
        data.encode(key: codingPath, value: value.description)
    }
    
    mutating func encode(_ value: Int16) throws {
        data.encode(key: codingPath, value: value.description)
    }
    
    mutating func encode(_ value: Int32) throws {
        data.encode(key: codingPath, value: value.description)
    }
    
    mutating func encode(_ value: Int64) throws {
        data.encode(key: codingPath, value: value.description)
    }
    
    mutating func encode(_ value: UInt) throws {
        data.encode(key: codingPath, value: value.description)
    }
    
    mutating func encode(_ value: UInt8) throws {
        data.encode(key: codingPath, value: value.description)
    }
    
    mutating func encode(_ value: UInt16) throws {
        data.encode(key: codingPath, value: value.description)
    }
    
    mutating func encode(_ value: UInt32) throws {
        data.encode(key: codingPath, value: value.description)
    }
    
    mutating func encode(_ value: UInt64) throws {
        data.encode(key: codingPath, value: value.description)
    }
    
    mutating func encode<T: Encodable>(_ value: T) throws {
        var stringsEncoding = StringsEncoding(to: data)
        stringsEncoding.codingPath = codingPath
        try value.encode(to: stringsEncoding)
    }
}
