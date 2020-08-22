public enum Access: String {
  case _public = "public"
  case _private = "private"
  case _internal = "internal"
  case _filePrivate = "filePrivate"

  func isPublic() -> Bool {
    return self == ._public
  }

  func isPrivate() -> Bool {
    return self == ._private
  }

  func isInternal() -> Bool {
    return self == ._internal
  }

  func isFilePrivate() -> Bool {
    return self == ._filePrivate
  }
}
