import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/models/_course_model.dart';
import 'package:joblagbe/app/data/models/_course_lesson_model.dart';
import 'package:joblagbe/app/data/services/_admin_course_service.dart';
import 'package:joblagbe/app/routes/_routing_imports.dart';

class AdminCourseViewController extends GetxController {
  final courseService = AdminCourseService();
  final Course course;
  
  var lessons = <CourseLesson>[].obs;
  var isLoading = false.obs;
  var selectedLesson = Rxn<CourseLesson>();
  var selectedLessonIndex = (-1).obs;
  var isPlaying = false.obs;
  var videoProgress = 0.0.obs;
  var videoDuration = 0.obs;
  var currentTime = 0.obs;
  var isFullscreen = false.obs;

  AdminCourseViewController({required this.course});

  @override
  void onInit() {
    super.onInit();
    // Reset all state when controller is initialized
    resetState();
    loadLessons();
  }

  void resetState() {
    lessons.clear();
    selectedLesson.value = null;
    selectedLessonIndex.value = -1;
    isPlaying.value = false;
    videoProgress.value = 0.0;
    currentTime.value = 0;
    videoDuration.value = 0;
    isFullscreen.value = false;
    isLoading.value = false;
  }

  @override
  void onClose() {
    resetState();
    super.onClose();
  }

  Future<void> loadLessons() async {
    isLoading.value = true;
    try {
      final courseLessons = await courseService.getAllLessonsForCourse(course.id!);
      if (courseLessons != null) {
        // Sort lessons by orderIndex
        courseLessons.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
        lessons.clear(); // Clear existing lessons
        lessons.addAll(courseLessons); // Add new lessons
        if (courseLessons.isNotEmpty) {
          selectLesson(courseLessons.first);
        }
      }
    } catch (e) {
      customDialog("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void selectLesson(CourseLesson lesson) {
    // Update both the lesson and index atomically
    selectedLesson.value = lesson;
    final index = lessons.indexWhere((l) => l.id == lesson.id);
    if (index != -1) {
      selectedLessonIndex.value = index;
    }
    
    // Reset video state when changing lessons
    isPlaying.value = false;
    videoProgress.value = 0.0;
    currentTime.value = 0;
    // Set video duration if available
    videoDuration.value = lesson.duration ?? 0;
  }

  void togglePlayPause() {
    isPlaying.value = !isPlaying.value;
    // TODO: Implement actual video playback
  }

  void updateProgress(double progress) {
    videoProgress.value = progress;
    currentTime.value = (progress * videoDuration.value).round();
  }

  void toggleFullscreen() {
    isFullscreen.value = !isFullscreen.value;
    // TODO: Implement actual fullscreen toggle
  }

  String formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void nextLesson() {
    if (selectedLesson.value == null) return;
    final currentIndex = selectedLessonIndex.value;
    if (currentIndex < lessons.length - 1) {
      selectLesson(lessons[currentIndex + 1]);
    }
  }

  void previousLesson() {
    if (selectedLesson.value == null) return;
    final currentIndex = selectedLessonIndex.value;
    if (currentIndex > 0) {
      selectLesson(lessons[currentIndex - 1]);
    }
  }
}