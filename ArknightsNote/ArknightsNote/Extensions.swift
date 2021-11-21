//
//  Extensions.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 21.11.21.
//

import Combine
import Foundation

class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() { cancellable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}
