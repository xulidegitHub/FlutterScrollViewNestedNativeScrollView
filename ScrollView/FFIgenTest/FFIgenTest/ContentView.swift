//
//  ContentView.swift
//  FlutterScrollView
//
//  Created by 徐丽 on 2023/7/6.
//

import SwiftUI
import SwiftUIIntrospect

enum Segment: String, CaseIterable, Identifiable {
  var id: String {
    rawValue
  }
  
  case one
  case two
  case three
  case four
}
struct ContentView: View {
  @State private var selectedSegmentTag = Segment.one
  @State private var offset = 0.0
  
    var body: some View {
      NavigationView {
        ScrollView {
          LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders, .sectionFooters]) {
            Group {
              VStack {
                Rectangle()
                  .fill(Color.red)
                  .frame(width: UIScreen.main.bounds.size.width, height: 300)
//                Rectangle()
//                  .fill(Color.green)
//                  .frame(width: UIScreen.main.bounds.size.width, height: 300)
              }
              Section(content: {
                switch selectedSegmentTag {
                case .one:
                  VStack {
                    Rectangle()
                      .fill(Color.blue)
                      .frame(width: UIScreen.main.bounds.size.width, height: 600)
                    
                    Rectangle()
                      .fill(Color.gray)
                      .frame(width: UIScreen.main.bounds.size.width, height: 600)
                  }
                
                case .two:
                  Text("asdf")

                case .three:
                  Text("asdf")

                case .four:
                  FlutterViewControllerRepresent(data: 0, onChannelInvoke: { call, result in
                    if let method = call.method as? String, method == "setContentOffset" {
                      if let argument =  call.arguments as? Double {
                        print("argument\(argument)")
                        offset = argument
                        result(0)
                      }
                    }
                  })
                  .background(Color.gray)
                  .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                }
              }, header: {
                SegmentedPicker(Segment.allCases, selection: $selectedSegmentTag) { item, selected in
                  Text(item.rawValue)
                }
              })
            }
          }
        }
        .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { scrollView in
          print("contentoffset\(offset)")
          print("scrollView.contentOffset.y\(scrollView.contentOffset.y)")
          //上拉
          if offset > 0 {
            if scrollView.contentOffset.y <= 310 && scrollView.contentOffset.y >= 0 {
              scrollView.contentOffset.y += offset
            } else {
              
            }
          } else {
            if scrollView.contentOffset.y > 0 {
              scrollView.contentOffset.y += offset
            } else {
              scrollView.contentOffset.y = 0

            }
          }
        
       
        }
        .ignoresSafeArea()
      }
    }
  
  func deliverable() {
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
