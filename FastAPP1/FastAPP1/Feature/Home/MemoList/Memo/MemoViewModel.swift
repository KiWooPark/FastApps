//
//  MemoViewModel.swift
//  FastAPP1
//
//  Created by PKW on 12/2/24.
//

import Foundation

class MemoViewModel: ObservableObject {
    @Published var memo: MemoModel
    
    init(memo: MemoModel) {
        self.memo = memo
    }
}
