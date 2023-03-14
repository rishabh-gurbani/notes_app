
// login exceptions

class UserNotFoundAuthException implements Exception{}

class WrongPasswordAuthException implements Exception{}

// register exceptions

class WeakPasswordAuthException implements Exception{}

class EmailAlreadyInUseAuthException implements Exception{}

class InvalidEmailAuthException implements Exception{}

// generic exceptions

class UserNotLoggedInException implements Exception{}

class GenericAuthException implements Exception{}
