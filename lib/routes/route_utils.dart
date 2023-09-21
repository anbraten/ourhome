enum PAGES {
  login,
  pinboard,
  error,
}

extension AppPageExtension on PAGES {
  String get screenPath {
    switch (this) {
      case PAGES.pinboard:
        return "/";
      case PAGES.login:
        return "/login";
      case PAGES.error:
        return "/error";
      default:
        return "/";
    }
  }
}
