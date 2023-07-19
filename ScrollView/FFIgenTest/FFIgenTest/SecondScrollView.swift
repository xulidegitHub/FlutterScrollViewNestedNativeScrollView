//
//  SecondScrollView.swift
//  FlutterScrollView
//
//  Created by 徐丽 on 2023/7/10.
//

import Foundation
import SwiftUI

struct SecondScrollView: View {
  let offset: Double
  let completed: (_ offSet: Double) -> Void
  
  init(offset: Double, completed: @escaping (_ offSet: Double) -> Void) {
    print("childOffset\(offset)")
    self.offset = offset
    self.completed = completed
  }
  
  var body: some View {
    ScrollView() {
      VStack {
        Rectangle()
          .fill(Color.green)
          .frame(width: UIScreen.main.bounds.size.width, height: 300)
        
        Rectangle()
          .fill(Color.secondary)
          .frame(width: UIScreen.main.bounds.size.width, height: 300)
        
        Rectangle()
          .fill(Color.gray)
          .frame(width: UIScreen.main.bounds.size.width, height: 300)
        
        Rectangle()
          .fill(Color.yellow)
          .frame(width: UIScreen.main.bounds.size.width, height: 300)
        
        Rectangle()
          .fill(Color.blue)
          .frame(width: UIScreen.main.bounds.size.width, height: 300)
        
        Rectangle()
          .fill(Color.red)
          .frame(width: UIScreen.main.bounds.size.width, height: 300)
        
        Rectangle()
          .fill(Color.purple)
          .frame(width: UIScreen.main.bounds.size.width, height: 300)
        
        Rectangle()
          .fill(Color.yellow)
          .frame(width: UIScreen.main.bounds.size.width, height: 300)
        
        Rectangle()
          .fill(Color.blue)
          .frame(width: UIScreen.main.bounds.size.width, height: 300)
      }
      .geometryReader()
      .observeScrollContentSize()
    }
    .observerOffSet(onObserveOffSet: {
      completed($0)
    })
    .disabled(true)
    .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { scrollView in
      print("offset\(offset)")
      scrollView.contentOffset = CGPoint(x: 0, y: offset)
    }
  }
}
