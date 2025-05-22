import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joblagbe/app/data/models/_job_category_model.dart';

class AdminCategoryServices {
  final jobCollection = FirebaseFirestore.instance.collection('jobCategories');

  // Add a new category
  Future<Map<String, dynamic>> addCategory(JobCategory category) async {
    try {
      final response = await jobCollection.add(category.toJson());

      return {
        'success': true,
        'message': 'Category added successfully',
        'data': response.id,
      };
    } catch (error) {
      return {
        'success': false,
        'message': error.toString(),
      };
    }
  }

  // Get all categories
  Future<List<JobCategory>?> getAllCategories() async {
    try {
      final response = await jobCollection.get();
      return response.docs
          .map((doc) => JobCategory.fromJson(json: doc.data(), id: doc.id))
          .toList();
    } catch (error) {
      return null;
    }
  }
  
}
