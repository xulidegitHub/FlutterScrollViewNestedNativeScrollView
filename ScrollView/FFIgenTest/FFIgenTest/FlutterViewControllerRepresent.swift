//
//  FlutterViewControllerRepresent.swift
//  FlutterScrollView
//
//  Created by 徐丽 on 2023/7/6.
//
import Foundation
import SwiftUI
import Flutter
import FlutterPluginRegistrant

typealias OnChannelInvoke = (_ call:FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
typealias OnDrag = (_ state: UIPanGestureRecognizer.State, _ offset: Double) -> Void

public struct FlutterViewControllerRepresent: UIViewControllerRepresentable {
  public typealias UIViewControllerType = PCFlutterViewController
  
  private let initialRouter: String?
  private let onChannelInvoke: OnChannelInvoke?
  private let data: Double?
  private let showFlutterNavigationBar: Bool
  private let onDrag: OnDrag?
  
  init(initialRouter: String? = nil,
       data: Double? = nil,
       showFlutterNavigationBar: Bool = false,
       onChannelInvoke: OnChannelInvoke? = nil,
       onDrag: OnDrag? = nil) {
    self.initialRouter = initialRouter
    self.onChannelInvoke = onChannelInvoke
    self.data = data
    self.showFlutterNavigationBar = showFlutterNavigationBar
    self.onDrag = onDrag
  }
  
  public func makeUIViewController(context: Context) -> PCFlutterViewController {
    let vc = PCFlutterViewController(project: nil, initialRoute: initialRouter, nibName: nil, bundle: nil, onChannelInvoke: onChannelInvoke, onDrag: onDrag)
    print("viewDidLoad\(CACurrentMediaTime())")
    return vc
  }
  
  public func updateUIViewController(_ uiViewController: PCFlutterViewController, context: Context) {
  }
}

extension FlutterViewControllerRepresent {
  public class PCFlutterViewController: FlutterViewController {
    private let onChannelInvoke: OnChannelInvoke?
    private var channel: FlutterMethodChannel?
    private let onDrag: OnDrag?
    private var panGesture: UIPanGestureRecognizer?
    
    init(project: FlutterDartProject?,
         initialRoute: String?,
         nibName: String?,
         bundle nibBundle: Bundle?,
         onChannelInvoke: OnChannelInvoke?,
         onDrag: OnDrag?) {
      self.onChannelInvoke = onChannelInvoke
      self.onDrag = onDrag
      super.init(project: project, initialRoute: initialRoute, nibName: nibName, bundle: nibBundle)
      channel = FlutterMethodChannel(name: "flutter.com/channel",
                                     binaryMessenger: self.binaryMessenger)
      
      channel?.setMethodCallHandler {(call:FlutterMethodCall, result: @escaping FlutterResult) in
        DispatchQueue.main.async {
          onChannelInvoke?(call, result)
        }
      }
      self.splashScreenView = UIView()
      
      GeneratedPluginRegistrant.register(with: self)
      let panGesture = UIPanGestureRecognizer()
      panGesture.cancelsTouchesInView = false
      self.view.addGestureRecognizer(panGesture)
      self.panGesture = panGesture

      let tap = UITapGestureRecognizer()
      tap.cancelsTouchesInView = false
      self.view.addGestureRecognizer(tap)
    }
    
    required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}
