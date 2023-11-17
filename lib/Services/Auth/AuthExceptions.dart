//Login Exceptions

class InvalidUserCredentialsAuthException implements Exception {}

//Register Exceptions

class EmailAlreadyInUseAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//Generic Exceptions

class GenericAuthExceptions implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
