class HttpResources {
  static FirestoreResources firestoreDB = FirestoreResources();
}

class FirestoreResources {
  String url({String sufix = '', String collection = 'products'}) =>
      'https://reworked-flutter-course.firebaseio.com/$collection$sufix.json';
}
