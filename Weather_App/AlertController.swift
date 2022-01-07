//
//  AlertController.swift
//  Weather_App
//
//  Created by 洛奇 on 2021/9/23.
//  Copyright © 2021 Yrocky. All rights reserved.
//

import Foundation
import UIKit

@objcMembers
class DemoRHAlertController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: RHAlertController

public class RHAlertController: NSObject {

    private(set) var style: UIAlertController.Style

    deinit {
        print("AlertController deinit")
    }

    public init<B: ContentsBuildable>(style: UIAlertController.Style, @ContentsBuilder builder: () -> B) {
        self.style = style
        self.contents = builder().buildContents().flatMap{ $0.buildContents() }
    }

    public func present(from source: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        source?.present(self.alertController, animated: animated, completion: completion)
    }

    private var contents: [ContentsBuildable]

    private lazy var alertController: UIAlertController = {

        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style
        )
        
        textFieldContents.forEach { textFieldContent in
            if let config = textFieldContent.configurationHandler {
                // 将失去为UITextField设置text
                alertController.addTextField(configurationHandler: config)
            } else {
                alertController.addTextField { textField in
                    textField.text = textFieldContent.text
                    textField.placeholder = textFieldContent.placeholder
                    textField.keyboardType = textFieldContent.keyboardType
                }
            }
        }
        actionContents.forEach { actionContent in
            var inner = ActionContent(actionContent.text, style: actionContent.style, enable: actionContent.enable, textColor: actionContent.textColor, handler: actionContent.handler)
            inner.bind(textFields: alertController.textFields)
            alertController.addAction(inner.asUIAlertAction())
        }
        
        return alertController
    }()

    private var title: String? {
        let titleContents = contents.filter { $0 is TitleContent }
        assert(titleContents.count < 2, "最多设置一个TitleContent")
        return filter(content: TitleContent.self)?.text
    }

    private var message: String? {
        let messageContents = contents.filter { $0 is MessageContent }
        assert(messageContents.count < 2, "最多设置一个MessageContent")
        return filter(content: MessageContent.self)?.text
    }

    private var textFieldContents: [TextFieldContent] {
        contents.filter { $0 is TextFieldContent }.compactMap { $0 as? TextFieldContent }
    }
    
    private var actionContents: [ActionContent] {

        let result: [ActionContent] = contents
            .filter { $0 is ActionContent }
            .compactMap { $0 as? ActionContent }
        
        assert(!result.isEmpty, "请至少设置一个Action")
        
        assert(result.filter { $0.style == .cancel }.count <= 1, "最多只有一个style为cancel的ActionContent")

        return result
    }

    private func filter<T>(content: T.Type) -> T? {
        contents.filter { $0 is T }.first as? T
    }
}

extension UIViewController {
    
    public func present(_ alertController: RHAlertController, animated: Bool = true, completion: (() -> Void)? = nil) {
        alertController.present(from: self, animated: animated, completion: completion)
    }
}

// MARK: Content

public struct TitleContent: ContentsBuildable {
    
    fileprivate var text: String
    
    public init(_ text: String) {
        self.text = text
    }

    public func buildContents() -> [ContentsBuildable] {
        [self]
    }
}

public struct MessageContent: ContentsBuildable {
    
    fileprivate var text: String
    
    public init(_ text: String) {
        self.text = text
    }

    public func buildContents() -> [ContentsBuildable] {
        [self]
    }
}

public struct TextFieldContent: ContentsBuildable {
    
    fileprivate var text: String?
    fileprivate var placeholder: String?
    fileprivate var keyboardType: UIKeyboardType
    
    fileprivate var configurationHandler: ((UITextField) -> Void)?
    
    public init(_ text: String? = nil, placeholder: String? = nil, keyboardType: UIKeyboardType = .default) {
        self.text = text
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.configurationHandler = nil
    }
    
    public init(_ text: String? = nil, configurationHandler: ((UITextField) -> Void)? = nil) {
        self.text = text
        self.placeholder = nil
        self.keyboardType = .default
        self.configurationHandler = configurationHandler
    }
    
    public func buildContents() -> [ContentsBuildable] {
        [self]
    }
}

public struct ActionContent: ContentsBuildable {

    public typealias Style = UIAlertAction.Style

    public private(set) var text: String
    fileprivate var style: Style
    fileprivate var enable: Bool
    fileprivate var textColor: UIColor?
    fileprivate var handler: ((ActionContent) -> Void)?

    private(set) var textFields: [UITextField]?
    
    public init(_ text: String, style: Style = .default, enable: Bool = true, textColor: UIColor? = nil, handler: ((ActionContent) -> Void)? = nil) {
        self.text = text
        self.style = style
        self.enable = enable
        self.textColor = textColor
        self.handler = handler
    }

    fileprivate mutating func bind(textFields: [UITextField]?) {
        self.textFields = textFields
    }
    
    public func buildContents() -> [ContentsBuildable] {
        [self]
    }
}

private extension ContentsBuildable where Self == ActionContent {

    func asUIAlertAction() -> UIAlertAction {
        let action = UIAlertAction(title: self.text, style: self.style) { _ in
            self.handler?(self)
        }
        action.setValue(self.textColor, forKey: "titleTextColor")
        action.isEnabled = self.enable
        return action
    }
}

// MARK: resultBuilder

public protocol ContentsBuildable {
    func buildContents() -> [ContentsBuildable]
}

@resultBuilder
public struct ContentsBuilder: ContentsBuildable {

    private(set) var contents: [ContentsBuildable]

    public func buildContents() -> [ContentsBuildable] {
        contents
    }

    public static func buildOptional<C: ContentsBuildable>(_ c: C?) -> C? {
        c
    }

    @inlinable
    public static func buildIf<C: ContentsBuildable>(_ c: C?) -> C? {
        c
    }

    @inlinable
    public static func buildEither<C: ContentsBuildable>(first: C) -> C {
        first
    }

    @inlinable
    public static func buildEither<C: ContentsBuildable>(second: C) -> C {
        second
    }

    public static func buildBlock() -> ContentsBuilder {
        ContentsBuilder()
    }

    public static func buildBlock<C: ContentsBuildable>(_ c: C) -> ContentsBuilder {
        ContentsBuilder(c)
    }

    public static func buildArray(_ components: [ContentsBuildable]) -> ContentsBuilder {
        ContentsBuilder(contents: components)
    }
    
    public static func buildBlock<C0: ContentsBuildable, C1: ContentsBuildable>(_ c0: C0, _ c1: C1) -> ContentsBuilder {
        ContentsBuilder(c0, c1)
    }

    public static func buildBlock<C0: ContentsBuildable, C1: ContentsBuildable, C2: ContentsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2) -> ContentsBuilder {
        ContentsBuilder(c0, c1, c2)
    }
    
    public static func buildBlock<C0: ContentsBuildable, C1: ContentsBuildable, C2: ContentsBuildable, C3: ContentsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> ContentsBuilder {
        ContentsBuilder(c0, c1, c2, c3)
    }
    
    public static func buildBlock<C0: ContentsBuildable, C1: ContentsBuildable, C2: ContentsBuildable, C3: ContentsBuildable, C4: ContentsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> ContentsBuilder {
        ContentsBuilder(c0, c1, c2, c3, c4)
    }
    
    public static func buildBlock<C0: ContentsBuildable, C1: ContentsBuildable, C2: ContentsBuildable, C3: ContentsBuildable, C4: ContentsBuildable, C5: ContentsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> ContentsBuilder {
        ContentsBuilder(c0, c1, c2, c3, c4, c5)
    }
}

private extension ContentsBuilder {

    init() {
        contents = []
    }

    init<C: ContentsBuildable>(_ c: C) {
        contents = c.buildContents()
    }

    init<C: ContentsBuildable>(contents: [C]) {
        self.contents = contents.buildContents()
    }
    
    init<C0: ContentsBuildable, C1: ContentsBuildable>(_ c0: C0, _ c1: C1) {
        contents = c0.buildContents() + c1.buildContents()
    }

    init<C0: ContentsBuildable, C1: ContentsBuildable, C2: ContentsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2) {
        contents = c0.buildContents() + c1.buildContents() + c2.buildContents()
    }
    
    init<C0: ContentsBuildable, C1: ContentsBuildable, C2: ContentsBuildable, C3: ContentsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) {
        let contents1 = c0.buildContents() + c1.buildContents() + c2.buildContents()
        contents = contents1 + c3.buildContents()
    }
    
    init<C0: ContentsBuildable, C1: ContentsBuildable, C2: ContentsBuildable, C3: ContentsBuildable, C4: ContentsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) {
        let contents1 = c0.buildContents() + c1.buildContents() + c2.buildContents()
        contents = contents1 + c3.buildContents() + c4.buildContents()
    }
    
    init<C0: ContentsBuildable, C1: ContentsBuildable, C2: ContentsBuildable, C3: ContentsBuildable, C4: ContentsBuildable, C5: ContentsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) {
        let contents1 = c0.buildContents() + c1.buildContents() + c2.buildContents()
        let contents2 = c3.buildContents() + c4.buildContents() + c5.buildContents()
        contents = contents1 + contents2
    }
}

extension Array: ContentsBuildable where Element: ContentsBuildable {

    public func buildContents() -> [ContentsBuildable] {
        self
    }
}

extension Optional: ContentsBuildable where Wrapped: ContentsBuildable {
    
    public func buildContents() -> [ContentsBuildable] {
        self?.buildContents() ?? []
    }
}
