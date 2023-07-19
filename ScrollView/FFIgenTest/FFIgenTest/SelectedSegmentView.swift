//
//  SelectedSegmentView.swift
//  FlutterScrollView
//
//  Created by 徐丽 on 2023/7/6.
//

import Foundation
import SwiftUI
import Combine

extension Font {
    
    public static let size25 = Font.system(size: 25)
    public static let size24 = Font.system(size: 24)
    public static let size22 = Font.system(size: 22)
    public static let size20 = Font.system(size: 20)
    public static let size18 = Font.system(size: 18)
    public static let size17 = Font.system(size: 17)
    public static let size16 = Font.system(size: 16)
    public static let size15 = Font.system(size: 15)
    public static let size14 = Font.system(size: 14)
    public static let size13 = Font.system(size: 13)
    public static let size12 = Font.system(size: 12)
    public static let size11 = Font.system(size: 11)
    public static let size10 = Font.system(size: 10)
    
}

public struct SegmentedPicker<Data, ID, Content: View>: View where Data: RandomAccessCollection, ID : Hashable {

  private let scrollable: Bool
  private let showIndicator: Bool
  private let data: Data
  private let id: KeyPath<Data.Element, ID>
  private let onItemTap: ((Data.Element) -> Void)?
  private let content: (_ item: Data.Element, _ selected: Bool) -> Content
  @Binding private var selection: Data.Element
  @State private var selectedFrame: CGRect = .zero

  @State private var itemFreams: [ID: CGRect] = [:]

  public init(_ data: Data,
              id: KeyPath<Data.Element, ID>,
              selection: Binding<Data.Element>,
              scrollable: Bool = false,
              showIndicator: Bool = true,
              onItemTap: ((Data.Element) -> Void)? = nil,
              @ViewBuilder content: @escaping (_ item: Data.Element, _ selected: Bool) -> Content) {
    self.scrollable = scrollable
    self.showIndicator = showIndicator
    self.data = data
    self.id = id
    self.onItemTap = onItemTap
    self.content = content

    _selection = selection
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      let items = HStack(spacing: 16) {
        ForEach(data, id: id) { item in
          let isSelected = selection[keyPath: id] == item[keyPath: id]

          content(item, isSelected)
            .font(.size14)
            .foregroundColor(isSelected ? .blue : .red)
          
            .modifier(ViewFrameReader(.init(get: {
              .zero
            }, set: { react in
              _itemFreams.wrappedValue[item[keyPath: id]] = react
            })))
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
            .onTapGesture {
              withAnimation {
                if isSelected {
                  onItemTap?(item)
                } else {
                  selection = item
                }
              }
            }
        }
      }

      if scrollable {
        ScrollView(.horizontal, showsIndicators: false) {
          items
        }
      } else {
        items
      }

      if showIndicator {
        GeometryReader { g in
          Rectangle()
            .frame(width: itemFreams[selection[keyPath: id]]?.size.width ?? 0, height: 2)
            .offset(x: (itemFreams[selection[keyPath: id]]?.minX ?? 0) - g.frame(in: .global).minX)
            .foregroundColor(.blue)
        }
        .frame(height: 2)
      }

      Divider().opacity(0.5)
    }
  }
}

public extension SegmentedPicker where ID == Data.Element.ID, Content: View, Data.Element: Identifiable {
  init(_ data: Data,
       selection: Binding<Data.Element>,
       scrollable: Bool = false,
       showIndicator: Bool = true,
       onItemTap: ((Data.Element) -> Void)? = nil,
       @ViewBuilder content: @escaping (_ item: Data.Element, _ selected: Bool) -> Content) {
    self.init(data,
              id: \.id,
              selection: selection,
              scrollable: scrollable,
              showIndicator: showIndicator,
              onItemTap: onItemTap,
              content: content)
  }
}


import SwiftUI

public struct ViewFrameReader: ViewModifier {
  @Binding private var viewFrame: CGRect

  public init(_ viewFrame: Binding<CGRect>) {
    _viewFrame = viewFrame
  }

  public func body(content: Content) -> some View {
    content
      .background(
        GeometryReader { g -> Color in
          let frame = g.frame(in: .global)
          if viewFrame != frame {
            DispatchQueue.main.async {
              $viewFrame.wrappedValue = frame
            }
          }
          return Color.clear
        }
      )
  }
}
