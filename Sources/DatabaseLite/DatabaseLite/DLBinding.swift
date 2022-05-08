//
//  DLBinding.swift
//  DLBinding
//
//  Created by Mark Morrill on 2021-08-06.
//

import Foundation

public typealias DLBindings = [DLBinding]

public struct DLBinding : CustomStringConvertible {
    public enum Flavour : CustomStringConvertible {
        case null
        case bool(Bool)
        case signed(Int64)
        case unsigned(UInt64)
        case real(Double)
        case text(String)
        
        public var description: String {
            switch self {
            case .null:
                return "null"
            case .bool(let bool):
                return bool.description
            case .signed(let int64):
                return int64.description
            case .unsigned(let uInt64):
                return uInt64.description
            case .real(let double):
                return double.description
            case .text(let string):
                return string
            }
        }
    }
    fileprivate let raw: String
    var column : String {
        return raw.sqliteName
    }
    let flavour: Flavour
    
    public var description: String {
        return raw + ": " + flavour.description
    }
    
    public init(_ col:String) {
        raw = col
        flavour = .null
    }
    public init(_ col: String, _ value:Bool) {
        raw = col
        flavour = .bool(value)
    }
    public init(_ col: String, _ value:Int) {
        raw = col
        flavour = .signed(Int64(value))
    }
    public init(_ col: String, _ value:Int8) {
        raw = col
        flavour = .signed(Int64(value))
    }
    public init(_ col: String, _ value:Int16) {
        raw = col
        flavour = .signed(Int64(value))
    }
    public init(_ col: String, _ value:Int32) {
        raw = col
        flavour = .signed(Int64(value))
    }
    public init(_ col: String, _ value:Int64) {
        raw = col
        flavour = .signed(value)
    }
    public init(_ col: String, _ value:UInt) {
        raw = col
        flavour = .unsigned(UInt64(value))
    }
    public init(_ col: String, _ value:UInt8) {
        raw = col
        flavour = .unsigned(UInt64(value))
    }
    public init(_ col: String, _ value:UInt16) {
        raw = col
        flavour = .unsigned(UInt64(value))
    }
    public init(_ col: String, _ value:UInt32) {
        raw = col
        flavour = .unsigned(UInt64(value))
    }
    public init(_ col: String, _ value:UInt64) {
        raw = col
        flavour = .unsigned(value)
    }
    public init(_ col: String, _ value:Double) {
        raw = col
        flavour = .real(value)
    }
    public init(_ col: String, _ value:Float) {
        raw = col
        flavour = .real(Double(value))
    }
    public init(_ col: String, _ value:String) {
        raw = col
        flavour = .text(value)
    }

    
    public func bind(with stmt:DLStatement, at postion:Int) throws {
        switch flavour {
        case .null:
            try stmt.bindNull(position: postion)
        case .bool(let bool):
            try stmt.bind(position: postion, bool)
        case .signed(let int):
            try stmt.bind(position: postion, int)
        case .unsigned(let int):
            try stmt.bind(position: postion, int)
        case .real(let double):
            try stmt.bind(position: postion, double)
        case .text(let string):
            try stmt.bind(position: postion, string)
        }
    }
}
