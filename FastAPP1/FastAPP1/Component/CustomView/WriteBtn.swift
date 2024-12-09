//
//  WriteBtn.swift
//  FastAPP1
//
//  Created by PKW on 12/6/24.
//

import SwiftUI

// 3가지 방법으로 쓰기 버튼 재사용 뷰로 만들기

// MARK: - 모디파이어
public struct WriteBtnViewModifire: ViewModifier {
    let action: () -> ()
    
    public init(action: @escaping () -> ()) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(
                        action: action ,
                        label: { Image("writeBtn") }
                    )
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}

// MARK: - 뷰 확장
extension View {
    public func writeBtn(preform action: @escaping () -> ()) -> some View {
        ZStack {
            self
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(
                        action: action ,
                        label: { Image("writeBtn") }
                    )
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}

// MARK: - 새로운 뷰 생성
public struct WriteBtn<Content: View>: View {
    let content: Content
    let action: () -> ()
    
    public init(
        @ViewBuilder content: () -> Content,
        action: @escaping () -> ()
    ) {
        self.content = content()
        self.action = action
    }
    
    public var body: some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(
                        action: action ,
                        label: { Image("writeBtn") }
                    )
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}


