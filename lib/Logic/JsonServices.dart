import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

String tempLink =
    'https://raw.githubusercontent.com/bvaughn/infinite-list-reflow-examples/master/books.json';

List tempsList = List();

Future<String> decodeJson() async {
  final response = await http.get(tempLink);
  tempsList = jsonDecode(response.body) as List;
  print(tempsList.length);
  print(tempsList);
  // print(tempsList[0]['country']);
  // print(tempsList[0]['city']);
  // print(tempsList[0]['imageLink']);
  Firestore.instance.runTransaction((transaction) async {
    CollectionReference reference = Firestore.instance.collection('book');
    tempsList.forEach((element) async {
      // String flavorText = '${element['name']} is a pokemon of primary type ${element['type'][0]}, his weight is ${element['weight']} and height ${element['height']} '+
      // '\nYou can find him at ${element['spawn_time']}';
      if (element['thumbnailUrl'] == null) {
        print('ignoring ${element['title']} ');
        return;
      } else if (element['shortDescription'] == null) {
        if (element['longDescription'] != null) {
          await reference.add({
            'name': element['title'],
            'imageUrl': element['thumbnailUrl'],
            'description': element['longDescription'],
            'page count': element['pageCount'],
            'authors': element['authors'],
            'category': element['categories'] ?? 'uncategorized',
          });
          print('added ${element['title']} ');
        } else {
          print('ignoring ${element['title']} ');
          return;
        }
        return;
      } else if (element['pageCount'].toString() == '0') {
        print('ignoring ${element['title']} ');
        return;
      } else {
        await reference.add({
          'name': element['title'],
          'imageUrl': element['thumbnailUrl'],
          'description': element['shortDescription'],
          'page count': element['pageCount'],
          'authors': element['authors'],
          'category': element['categories'] ?? 'uncategorized',
        });
        print('added ${element['title']} ');
      }
    });
  });

  // String length = await Firestore.instance.collection('test').getDocuments().then((value) => value.documents.length.toString());
  // print('all elements added, the size og this is $length \nLest create the category for it');
  // Firestore.instance.collection('categories').add(
  //   {
  //     'name': tempsList[0]['name'],
  //     'searchKey': tempsList[0]['name'].substring(0, 1).toUpperCase(),
  //   }
  // );
  return 'done';
}
