//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 7/6/19.
//

import Foundation

func print_r(_ p: Any, level: Int = 0) -> String {
	var out = ""
	let tabs = String(repeating: "\t", count: level)
	let tabsn = String(repeating: "\t", count: max(0,level + 1))
	switch p {
	case let a as [Any]:
		for i in a {
			out += tabs + "[\n"
			out += tabs + print_r(i, level: level + 1) + "\n"
			out += tabs + "],"
		}
	case let a as [String: Any]:
		out += (tabs + "{\n")
		for i in a.enumerated() {
			out +=  tabsn + i.element.key + " = " + print_r(i.element.value, level: level + 1) + "\n"
		}
		out += (tabs + "},")
	case is Int:
		out += "Integer"
	case is String:
		out += "String"
	default:
		out += ("TYP!\(p.self)")
	}
	return out
}
