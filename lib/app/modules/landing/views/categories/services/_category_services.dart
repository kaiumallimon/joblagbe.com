import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joblagbe/app/modules/landing/views/categories/model/_categories_model.dart';

class CategoryServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('db_categories').get();
      return snapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching categories: $e');
      throw Exception('Failed to load categories: $e');
    }
  }
}
