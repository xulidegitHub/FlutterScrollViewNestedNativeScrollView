//
//  ScrollViewContentOffset.swift
//  FlutterScrollView
//
//  Created by 徐丽 on 2023/7/7.
//
import SwiftUI

extension View {

  public func observerOffSet(onObserveOffSet: @escaping (CGFloat) -> Void) -> some View {
    self.modifier(Observer(onObserveOffSet: onObserveOffSet))
  }
  
  public func geometryReader(scrollDirection: Axis.Set = .vertical) -> some View {
    self.modifier(ScrolGeometryReader(scrollDirection: scrollDirection))
  }
  
  public func headAnimation(scrollOffSet: Double, isSuspend: Bool = false) -> some View {
    self.modifier(HeaderAnimation(offSet: scrollOffSet, isSuspend: isSuspend))
  }
  
  public func observeScrollContentSize() -> some View {
    self.modifier(ScrollViewContentSizeGeometryRender())
  }

  public func getScrollViewContentSize(withContentSize: @escaping (CGFloat) -> Void) -> some View {
    self.modifier(ScrollViewContentSize(withContentSize: withContentSize))
  }
  
  public func getScrollViewContentSizeOnAppear(withContentSize: @escaping (CGFloat) -> Void) -> some View {
    self.modifier(ScrollViewContentSizeOnAppear(withContentSize: withContentSize))
  }
}

private struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

 struct ContentSizePreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

private struct ScrolGeometryReader: ViewModifier {
  private let scrollDirection: Axis.Set
  init(scrollDirection: Axis.Set = .vertical) {
    self.scrollDirection = scrollDirection
  }
  
  var offsetReader: some View {
    GeometryReader { proxy in
      Color.clear
        .preference(
          key: OffsetPreferenceKey.self,
          value: scrollDirection == .vertical ? proxy.frame(in: .named("scroll")).minY : proxy.frame(in: .named("scroll")).minX
        )
    }
  }
  
  func body(content: Content) -> some View {
    content.background {
      offsetReader
    }
  }
}

private struct Observer: ViewModifier {
  
  private var onObserveOffSet: (CGFloat) -> Void
  
  init(onObserveOffSet: @escaping (CGFloat) -> Void) {
    self.onObserveOffSet = onObserveOffSet
  }
  
  func body(content: Content) -> some View {
    content
      .coordinateSpace(name: "scroll")
      .onPreferenceChange(OffsetPreferenceKey.self, perform: onObserveOffSet)
  }
}

private var lastOffSet = 0.0

private struct HeaderAnimation: ViewModifier {
  private var headerOffSet = 0.0
  private var isSuspend = false
  private var offSet: Double {
    get {
      headerOffSet
    }
    set {
      if newValue >= 0 { // 下拉
        headerOffSet = 0
      } else if newValue > lastOffSet { // 下划
        withAnimation {
          headerOffSet = 0
        }
      } else { // 上划
        headerOffSet = min(newValue, 0)
      }
      lastOffSet = newValue
    }
  }
  
  init(offSet: Double, isSuspend: Bool) {
    self.offSet = offSet
    self.isSuspend = isSuspend
  }
  
  func body(content: Content) -> some View {
      content
      .offset(y: isSuspend ? 0 : headerOffSet)
        .animation(.easeInOut(duration: 0.15), value: headerOffSet)
  }
}

private struct ScrollViewContentSizeGeometryRender: ViewModifier {
  func body(content: Content) -> some View {
    content.overlay {
      GeometryReader { proxy in
        Color.clear.preference(key: ContentSizePreferenceKey.self, value: proxy.size.height)
      }
    }
  }
}

private struct ScrollViewContentSize: ViewModifier {
  var withContentSize: (CGFloat) -> Void
  
  func body(content: Content) -> some View {
    content.onPreferenceChange(ContentSizePreferenceKey.self) { value in
      DispatchQueue.main.async {
        withContentSize(value)
      }
    }
  }
}

private struct ScrollViewContentSizeOnAppear: ViewModifier {
  var withContentSize: (CGFloat) -> Void

   func body(content: Content) -> some View {
    content
      .background(GeometryReader(content: { proxy in
      Color.clear.onAppear {
        print(proxy.size.height)
        withContentSize(proxy.size.height)
      }
    }))

  }
}
