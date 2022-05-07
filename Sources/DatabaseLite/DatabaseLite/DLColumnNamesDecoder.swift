//
//  DLColumnNamesDecoder.swift
//  DLColumnNamesDecoder
//
//  Created by Mark Morrill on 2021-08-03.
//

import Foundation

extension String {
    var columnName : String {
        return "`\(self)`"
    }
}

public struct DLColumn: CustomStringConvertible {
    fileprivate let raw: String
    let isOptional: Bool
    let type: Any.Type

    var name: String {
        return raw.columnName
    }

    public var description: String {
        return "\(raw): \(type)\(isOptional ? "?" : "")"
    }
}


// the first column is presumed to be the primary index
public typealias DLColumnNames = [DLColumn]


public class DLColumnNamesDecoder {
    public func decode<T:Decodable>(_ type: T.Type) throws -> DLColumnNames {
        let decoder = DLColumnNamesDecoding()
        let _ = try type.init(from: decoder)
        return decoder.collected
    }
}

public class DLColumnNamesDecoding: Decoder {
    public var codingPath: [CodingKey] = []
    public let userInfo: [CodingUserInfoKey : Any] = [:]
    public var collected: DLColumnNames = []
    
    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer<Key>(DLColumnNamesReader<Key>(self))
    }
    
    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw DLDecoderError("Not doing this yet")
    }
    
    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw DLDecoderError("Not doing this yet")
    }
}

public class DLColumnNamesReader<K: CodingKey>: KeyedDecodingContainerProtocol {
    public typealias Key = K
    public var allKeys: [Key] = []
    public var codingPath: [CodingKey] = []
    
    let parent: DLColumnNamesDecoding
    var isOptional = false
    var knownKeys = Set<String>()
    
    init(_ p: DLColumnNamesDecoding) {
        parent = p
    }
    
    public func appendKey(_ key:Key, _ type:Any.Type) {
        let name = key.stringValue
        if !knownKeys.contains(name) {
            parent.collected.append(DLColumn(raw: name, isOptional: isOptional, type: type))
            knownKeys.insert(name)
        }
        isOptional = false
    }
    
    // we will examine every key, so this is always true
    public func contains(_ key: K) -> Bool {
        true
    }
    
    public func decodeNil(forKey key: K) throws -> Bool {
        isOptional = true
        return false
    }
    
    public func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        appendKey(key, type)
        return true
    }
    public func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        appendKey(key, type)
        return 0
    }
    public func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        appendKey(key, type)
        return 0
    }
    public func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        appendKey(key, type)
        return 0
    }
    public func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        appendKey(key, type)
        return 0
    }
    public func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        appendKey(key, type)
        return 0
    }
    public func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        appendKey(key, type)
        return 0
    }
    public func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        appendKey(key, type)
        return 0
    }
    public func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        appendKey(key, type)
        return 0
    }
    public func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        appendKey(key, type)
        return 0
    }
    public func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        appendKey(key, type)
        return 0
    }
    public func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        appendKey(key, type)
        return 0
    }
    public func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        appendKey(key, type)
        return 0
    }
    public func decode(_ type: String.Type, forKey key: Key) throws -> String {
        appendKey(key, type)
        return ""
    }

    public func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
        // this is where we can handle things like latency min, max, ave
        throw DLDecoderError("Not yet!")
    }

    public func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> {
        throw DLDecoderError("Unimplimented nestedContainer")
    }
    public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        throw DLDecoderError("Unimplimented nestedUnkeyedContainer for \(key)")
    }
    public func superDecoder() throws -> Decoder {
        throw DLDecoderError("Unimplimented superDecoder")
    }
    public func superDecoder(forKey key: Key) throws -> Decoder {
        throw DLDecoderError("Unimplimented superDecoder for \(key)")
    }
}

