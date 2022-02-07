import Shakuro_iOS_Toolbox
import UIKit

class StyleSheet {

    static let sharedInstance = StyleSheet()

    let font = Font()
    let color = Color()
    let cornerRadius = CornerRadius()

    let blueArrowButton: BlueArrowButton = BlueArrowButton()
    let blueBorderButton: BlueBorderButton = BlueBorderButton()
    let logOutButton: LogOutButton = LogOutButton()
    let facebookButton: FacebookButton = FacebookButton()

    let standardButton = StandardButton()
    let standardAttributedButton = StandardAttributedButton()

    struct Color {
        let customBlue: UIColor = UIColor(uint8Red: 41, green: 98, blue: 255)
        let customLightBlue: UIColor = UIColor(uint8Red: 33, green: 150, blue: 243)
        let customGray: UIColor = UIColor(uint8Red: 119, green: 130, blue: 150)
        let customDarkGray: UIColor = UIColor(uint8Red: 67, green: 75, blue: 92)
        let customOrange: UIColor = UIColor(uint8Red: 255, green: 87, blue: 34)
        let customGreen: UIColor = UIColor(uint8Red: 76, green: 175, blue: 80)
        let facebookBlue: UIColor = UIColor(uint8Red: 74, green: 104, blue: 173)

        let border: UIColor = UIColor(uint8Red: 228, green: 227, blue: 230)

        let primaryTextColor: UIColor = UIColor.black
        let color2: UIColor = UIColor.black
        let secondaryTextColor: UIColor = UIColor(white: 0.7, alpha: 1)

        let cellSelectionColor: UIColor = UIColor(white: 0.85, alpha: 1)
    }

    enum FontFace: String {
        case interUIRegular = "InterUI-Regular"
        case interUIBold = "InterUI-Bold"
        case helveticaNeue = "HelveticaNeue"
        case helveticaNeueLight = "HelveticaNeue-Light"
        case helveticaNeueBold = "HelveticaNeue-Bold"

        static let interUIRegular11 = unwrap({ UIFont.systemFont(ofSize: 11, weight: .regular) })
        static let interUIRegular14 = unwrap({ UIFont.systemFont(ofSize: 14, weight: .regular) })
        static let interUIRegular16 = unwrap({ UIFont.systemFont(ofSize: 16, weight: .regular) })
        static let interUIRegular22 = unwrap({ UIFont.systemFont(ofSize: 22, weight: .regular) })
        static let interUIRegular24 = unwrap({ UIFont.systemFont(ofSize: 24, weight: .regular) })
        static let interUIRegular32 = unwrap({ UIFont.systemFont(ofSize: 32, weight: .regular) })

        static let interUIBold14 = unwrap({ UIFont.systemFont(ofSize: 14, weight: .bold) })
        static let interUIBold16 = unwrap({ UIFont.systemFont(ofSize: 16, weight: .bold) })
        static let interUIBold24 = unwrap({ UIFont.systemFont(ofSize: 24, weight: .bold) })
        static let interUIBold32 = unwrap({ UIFont.systemFont(ofSize: 32, weight: .bold) })

        static let buttonAttributedTitleFont = FontDescriptor(name: interUIBold.rawValue, size: 14, letterSpacing: 0, lineHeight: 0)
        static let titleFont = helveticaNeueLight.fontWithSize(22)
        static let attributedTitle = FontDescriptor(name: helveticaNeueBold.rawValue, size: 30, letterSpacing: 0, lineHeight: 14)
    }

    struct Font {
        internal let interUIRegular11 = FontFace.interUIRegular11
        internal let interUIRegular14 = FontFace.interUIRegular14
        internal let interUIRegular16 = FontFace.interUIRegular16
        internal let interUIRegular22 = FontFace.interUIRegular22
        internal let interUIRegular24 = FontFace.interUIRegular24
        internal let interUIRegular32 = FontFace.interUIRegular32
        internal let interUIBold14 = FontFace.interUIBold14
        internal let interUIBold16 = FontFace.interUIBold16
        internal let interUIBold24 = FontFace.interUIBold24
        internal let interUIBold32 = FontFace.interUIBold32

        internal let titleFont1 = FontFace.titleFont
        internal let attributedFont1 = FontFace.attributedTitle
    }

    struct FontDescriptor {
        let name: String
        let size: CGFloat
        let letterSpacing: Float
        let lineHeight: CGFloat

        func attributedString(_ text: String?,
                              alignment: NSTextAlignment = .natural,
                              foregroundColor: UIColor? = nil,
                              monospacedNumbers: Bool = false,
                              linebreakMode: NSLineBreakMode = .byWordWrapping,
                              strikethroughColor: UIColor? = nil,
                              useLineHeight: Bool = true) -> NSAttributedString? {
            guard let realText = text else {
                return nil
            }
            let result = NSAttributedString(string: realText,
                                            attributes: attributes(alignment: alignment,
                                                                   foregroundColor: foregroundColor,
                                                                   monospacedNumbers: monospacedNumbers,
                                                                   linebreakMode: linebreakMode,
                                                                   strikethroughColor: strikethroughColor,
                                                                   useLineHeight: useLineHeight))
            return result
        }

        func attributes(alignment: NSTextAlignment = .natural,
                        foregroundColor: UIColor? = nil,
                        monospacedNumbers: Bool = false,
                        linebreakMode: NSLineBreakMode = .byWordWrapping,
                        strikethroughColor: UIColor? = nil,
                        useLineHeight: Bool = true) -> [NSAttributedString.Key: Any] {
            let font = self.font(monospacedNumbers: monospacedNumbers)
            let paragraphStyle = NSMutableParagraphStyle()
            if useLineHeight {
                paragraphStyle.minimumLineHeight = lineHeight
                paragraphStyle.maximumLineHeight = lineHeight
            }
            paragraphStyle.alignment = alignment
            paragraphStyle.lineBreakMode = linebreakMode
            var result: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.kern: NSNumber(value: letterSpacing)
            ]
            if let color = foregroundColor {
                result[NSAttributedString.Key.foregroundColor] = color
            }
            if let color = strikethroughColor {
                result[NSAttributedString.Key.baselineOffset] = 0.0 // workground to show strikethrough line
                result[NSAttributedString.Key.strikethroughStyle] = NSUnderlineStyle.single.rawValue
                result[NSAttributedString.Key.strikethroughColor] = color
            }
            return result
        }

        func font(monospacedNumbers: Bool = false) -> UIFont {
            var fontDescriptor = UIFontDescriptor(name: name, size: size)
            if monospacedNumbers {
                fontDescriptor = fontDescriptor.addingAttributes([
                    UIFontDescriptor.AttributeName.featureSettings: [
                        [
                            UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                            UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector
                        ]
                    ]
                    ])
            }
            let font = UIFont(descriptor: fontDescriptor, size: size)
            return font
        }
    }

    struct CornerRadius {
        internal let radius2: CGFloat = 2.0
        internal let radius4: CGFloat = 4.0
        internal let radius5: CGFloat = 5.0
        internal let radius6: CGFloat = 6.0
        internal let radius8: CGFloat = 8.0
        internal let radius10: CGFloat = 10.0
    }

    struct FacebookButton {
        internal var font: UIFont { return StyleSheet.sharedInstance.font.interUIRegular14 }
        internal var backgroundColor: UIColor { return StyleSheet.sharedInstance.color.facebookBlue }
        internal var textColor: UIColor { return UIColor.white }
        internal var cornerRadius: CGFloat { return StyleSheet.sharedInstance.cornerRadius.radius4 }
    }

    struct LogOutButton {
        internal var font: UIFont { return StyleSheet.sharedInstance.font.interUIBold14 }
        internal var backgroundColor: UIColor { return UIColor.clear }
        internal var textColor: UIColor { return StyleSheet.sharedInstance.color.customGray }
        internal let borderWidth: CGFloat = 0.0
    }

    struct BlueArrowButton {
        internal var font: UIFont { return StyleSheet.sharedInstance.font.interUIBold14 }
        internal var enableBackgroundColor: UIColor { return StyleSheet.sharedInstance.color.customBlue }
        internal var disableBackgroundColor: UIColor { return StyleSheet.sharedInstance.color.customGray }
        internal var textColor: UIColor { return UIColor.white }
        internal var cornerRadius: CGFloat { return StyleSheet.sharedInstance.cornerRadius.radius4 }
        internal let borderWidth: CGFloat = 0.0
    }

    struct BlueBorderButton {
        internal var font: UIFont { return StyleSheet.sharedInstance.font.interUIBold14 }
        internal var backgroundColor: UIColor { return UIColor.white }
        internal var textColor: UIColor { return StyleSheet.sharedInstance.color.customLightBlue }
        internal var cornerRadius: CGFloat { return StyleSheet.sharedInstance.cornerRadius.radius4 }
        internal let borderWidth: CGFloat = 1.0
        internal var borderColor: UIColor { return StyleSheet.sharedInstance.color.customBlue }
    }

    struct StandardButton {
        internal var font: UIFont { return StyleSheet.sharedInstance.font.titleFont1 }
        internal var backgroundColor: UIColor { return StyleSheet.sharedInstance.color.customBlue }
        internal var textColor: UIColor { return StyleSheet.sharedInstance.color.customBlue }
        internal var borderColor: UIColor { return StyleSheet.sharedInstance.color.color2 }
        internal var cornerRadius: CGFloat { return StyleSheet.sharedInstance.cornerRadius.radius4 }
        internal let borderWidth: CGFloat = 0.0
    }

    struct StandardAttributedButton {
        internal var font: FontDescriptor { return StyleSheet.sharedInstance.font.attributedFont1 }
        internal var backgroundColor: UIColor { return StyleSheet.sharedInstance.color.color2 }
        internal var textColor: UIColor { return StyleSheet.sharedInstance.color.customBlue }
        internal var borderColor: UIColor { return StyleSheet.sharedInstance.color.color2 }
        internal var cornerRadius: CGFloat { return StyleSheet.sharedInstance.cornerRadius.radius4 }
        internal let borderWidth: CGFloat = 1.0
    }
}

private extension StyleSheet.FontFace {

    static func unwrap<T>(_ block: () -> T?) -> T {
        if let result = block() {
            return result
        } else {
            fatalError("Controller is nil.")
        }
    }

    func fontWithSize(_ size: CGFloat) -> UIFont {
        guard let actualFont: UIFont = UIFont(name: self.rawValue, size: size) else {
            debugPrint("Can't load font with name \(self.rawValue)")
            return UIFont.systemFont(ofSize: size)
        }
        return actualFont
    }

    static func printAvailableFonts() {
        for name in UIFont.familyNames {
            debugPrint("<<<<<<< Font Family: \(name)")
            for fontName in UIFont.fontNames(forFamilyName: name) {
                debugPrint("Font Name: \(fontName)")
            }
        }
    }

}
