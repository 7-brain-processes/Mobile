//
//  InviteCodeItem.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//


import Foundation

struct InviteCodeItem: Equatable {
    let code: String
    let maxUses: Int
    let expiresInDays: Int
}