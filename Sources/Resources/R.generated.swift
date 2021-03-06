//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 1 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.color` struct is generated, and contains static references to 4 colors.
  struct color {
    /// Color `primaryColor`.
    static let primaryColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "primaryColor")
    /// Color `subtitle`.
    static let subtitle = Rswift.ColorResource(bundle: R.hostingBundle, name: "subtitle")
    /// Color `tableViewBackground`.
    static let tableViewBackground = Rswift.ColorResource(bundle: R.hostingBundle, name: "tableViewBackground")
    /// Color `title`.
    static let title = Rswift.ColorResource(bundle: R.hostingBundle, name: "title")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "primaryColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func primaryColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.primaryColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "subtitle", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func subtitle(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.subtitle, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "tableViewBackground", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func tableViewBackground(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.tableViewBackground, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "title", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func title(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.title, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.file` struct is generated, and contains static references to 1 files.
  struct file {
    /// Resource file `swiftlint.yml`.
    static let swiftlintYml = Rswift.FileResource(bundle: R.hostingBundle, name: "swiftlint", pathExtension: "yml")

    /// `bundle.url(forResource: "swiftlint", withExtension: "yml")`
    static func swiftlintYml(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.swiftlintYml
      return fileResource.bundle.url(forResource: fileResource)
    }

    fileprivate init() {}
  }

  /// This `R.id` struct is generated, and contains static references to accessibility identifiers.
  struct id {
    struct eventShimmerCell {
      /// Accessibility identifier `CommunityShimmerCell`.
      static let communityShimmerCell: String = "CommunityShimmerCell"

      fileprivate init() {}
    }

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 4 images.
  struct image {
    /// Image `caution`.
    static let caution = Rswift.ImageResource(bundle: R.hostingBundle, name: "caution")
    /// Image `eventDefault`.
    static let eventDefault = Rswift.ImageResource(bundle: R.hostingBundle, name: "eventDefault")
    /// Image `event`.
    static let event = Rswift.ImageResource(bundle: R.hostingBundle, name: "event")
    /// Image `info`.
    static let info = Rswift.ImageResource(bundle: R.hostingBundle, name: "info")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "caution", bundle: ..., traitCollection: ...)`
    static func caution(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.caution, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "event", bundle: ..., traitCollection: ...)`
    static func event(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.event, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "eventDefault", bundle: ..., traitCollection: ...)`
    static func eventDefault(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.eventDefault, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "info", bundle: ..., traitCollection: ...)`
    static func info(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.info, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.nib` struct is generated, and contains static references to 4 nibs.
  struct nib {
    /// Nib `CheckinView`.
    static let checkinView = _R.nib._CheckinView()
    /// Nib `EventCell`.
    static let eventCell = _R.nib._EventCell()
    /// Nib `EventDetailView`.
    static let eventDetailView = _R.nib._EventDetailView()
    /// Nib `EventShimmerCell`.
    static let eventShimmerCell = _R.nib._EventShimmerCell()

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "CheckinView", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.checkinView) instead")
    static func checkinView(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.checkinView)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "EventCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.eventCell) instead")
    static func eventCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.eventCell)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "EventDetailView", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.eventDetailView) instead")
    static func eventDetailView(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.eventDetailView)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "EventShimmerCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.eventShimmerCell) instead")
    static func eventShimmerCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.eventShimmerCell)
    }
    #endif

    static func checkinView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> CheckinView? {
      return R.nib.checkinView.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? CheckinView
    }

    static func eventCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> EventCell? {
      return R.nib.eventCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? EventCell
    }

    static func eventDetailView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> EventDetailView? {
      return R.nib.eventDetailView.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? EventDetailView
    }

    static func eventShimmerCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> EventShimmerCell? {
      return R.nib.eventShimmerCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? EventShimmerCell
    }

    fileprivate init() {}
  }

  /// This `R.reuseIdentifier` struct is generated, and contains static references to 1 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `EventShimmerCell`.
    static let eventShimmerCell: Rswift.ReuseIdentifier<EventShimmerCell> = Rswift.ReuseIdentifier(identifier: "EventShimmerCell")

    fileprivate init() {}
  }

  /// This `R.string` struct is generated, and contains static references to 1 localization tables.
  struct string {
    /// This `R.string.localizable` struct is generated, and contains static references to 8 localization keys.
    struct localizable {
      /// en translation: Eventos
      ///
      /// Locales: en
      static let events = Rswift.StringResource(key: "events", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Não foi possivel fazer Parse do objeto
      ///
      /// Locales: en
      static let errorParse = Rswift.StringResource(key: "errorParse", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Ops... Algo deu errado!
      ///
      /// Locales: en
      static let somethingWrong = Rswift.StringResource(key: "somethingWrong", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Registrado
      ///
      /// Locales: en
      static let registred = Rswift.StringResource(key: "registred", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Sem permissão
      ///
      /// Locales: en
      static let errorUnauthorized = Rswift.StringResource(key: "errorUnauthorized", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Tentar novamente
      ///
      /// Locales: en
      static let tryAgain = Rswift.StringResource(key: "tryAgain", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Url da api é invalida
      ///
      /// Locales: en
      static let errorInvalidUrl = Rswift.StringResource(key: "errorInvalidUrl", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: ok
      ///
      /// Locales: en
      static let ok = Rswift.StringResource(key: "ok", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)

      /// en translation: Eventos
      ///
      /// Locales: en
      static func events(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("events", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "events"
        }

        return NSLocalizedString("events", bundle: bundle, comment: "")
      }

      /// en translation: Não foi possivel fazer Parse do objeto
      ///
      /// Locales: en
      static func errorParse(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("errorParse", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "errorParse"
        }

        return NSLocalizedString("errorParse", bundle: bundle, comment: "")
      }

      /// en translation: Ops... Algo deu errado!
      ///
      /// Locales: en
      static func somethingWrong(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("somethingWrong", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "somethingWrong"
        }

        return NSLocalizedString("somethingWrong", bundle: bundle, comment: "")
      }

      /// en translation: Registrado
      ///
      /// Locales: en
      static func registred(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("registred", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "registred"
        }

        return NSLocalizedString("registred", bundle: bundle, comment: "")
      }

      /// en translation: Sem permissão
      ///
      /// Locales: en
      static func errorUnauthorized(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("errorUnauthorized", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "errorUnauthorized"
        }

        return NSLocalizedString("errorUnauthorized", bundle: bundle, comment: "")
      }

      /// en translation: Tentar novamente
      ///
      /// Locales: en
      static func tryAgain(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("tryAgain", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "tryAgain"
        }

        return NSLocalizedString("tryAgain", bundle: bundle, comment: "")
      }

      /// en translation: Url da api é invalida
      ///
      /// Locales: en
      static func errorInvalidUrl(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("errorInvalidUrl", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "errorInvalidUrl"
        }

        return NSLocalizedString("errorInvalidUrl", bundle: bundle, comment: "")
      }

      /// en translation: ok
      ///
      /// Locales: en
      static func ok(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("ok", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "ok"
        }

        return NSLocalizedString("ok", bundle: bundle, comment: "")
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try nib.validate()
    #endif
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct nib: Rswift.Validatable {
    static func validate() throws {
      try _CheckinView.validate()
    }

    struct _CheckinView: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "CheckinView"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> CheckinView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? CheckinView
      }

      static func validate() throws {
        if UIKit.UIImage(named: "envelope.circle.fill", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'envelope.circle.fill' is used in nib 'CheckinView', but couldn't be loaded.") }
        if UIKit.UIImage(named: "person.crop.circle.fill", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'person.crop.circle.fill' is used in nib 'CheckinView', but couldn't be loaded.") }
        if UIKit.UIImage(named: "x.circle", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'x.circle' is used in nib 'CheckinView', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
          if UIKit.UIColor(named: "primaryColor", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'primaryColor' is used in storyboard 'CheckinView', but couldn't be loaded.") }
        }
      }

      fileprivate init() {}
    }

    struct _EventCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "EventCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> EventCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? EventCell
      }

      fileprivate init() {}
    }

    struct _EventDetailView: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "EventDetailView"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> EventDetailView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? EventDetailView
      }

      fileprivate init() {}
    }

    struct _EventShimmerCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = EventShimmerCell

      let bundle = R.hostingBundle
      let identifier = "EventShimmerCell"
      let name = "EventShimmerCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> EventShimmerCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? EventShimmerCell
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }
  #endif

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if UIKit.UIImage(named: "event", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'event' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
          if UIKit.UIColor(named: "primaryColor", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'primaryColor' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
        }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
