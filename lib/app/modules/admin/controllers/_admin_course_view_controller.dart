import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/models/_course_model.dart';
import 'package:joblagbe/app/data/models/_course_lesson_model.dart';
import 'package:joblagbe/app/data/services/_admin_course_service.dart';
import 'package:joblagbe/app/routes/_routing_imports.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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
  var currentYoutubeController = Rxn<YoutubePlayerController>();

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
    currentYoutubeController.value?.close();
    currentYoutubeController.value = null;
  }

  @override
  void onClose() async {
    if (currentYoutubeController.value != null) {
      await currentYoutubeController.value!.pauseVideo();
      currentYoutubeController.value!.close();
      currentYoutubeController.value = null;
    }
    resetState();
    super.onClose();
  }

  Future<void> loadLessons() async {
    isLoading.value = true;
    try {
      final courseLessons =
          await courseService.getAllLessonsForCourse(course.id!);
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
    // Don't do anything if the same lesson is selected
    if (selectedLesson.value?.id == lesson.id) return;

    // Update the lesson and index first
    selectedLesson.value = lesson;
    final index = lessons.indexWhere((l) => l.id == lesson.id);
    if (index != -1) {
      selectedLessonIndex.value = index;
    }

    // Reset video state
    isPlaying.value = false;
    videoProgress.value = 0.0;
    currentTime.value = 0;
    videoDuration.value = lesson.duration ?? 0;

    // Handle the video controller
    _handleVideoController(lesson);
  }

  void _handleVideoController(CourseLesson lesson) async {
    try {
      // Close existing controller
      if (currentYoutubeController.value != null) {
        await currentYoutubeController.value!.pauseVideo();
        currentYoutubeController.value!.close();
        currentYoutubeController.value = null;
      }

      // Create new controller if there's a video URL
      if (lesson.videoUrl.isNotEmpty) {
        final videoId = getVideoId(lesson.videoUrl);
        if (videoId.isNotEmpty) {
          currentYoutubeController.value = YoutubePlayerController.fromVideoId(
            videoId: videoId,
            autoPlay: false,
            params: const YoutubePlayerParams(
              showFullscreenButton: true,
              showControls: true,
              showVideoAnnotations: false,
              strictRelatedVideos: true,
            ),
          );
        }
      }
    } catch (e) {
      print('Error handling video controller: $e');
      // Reset controller state on error
      currentYoutubeController.value = null;
    }
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

  String getVideoId(String url) {
    if (url.contains('youtube.com/watch?v=')) {
      final uri = Uri.parse(url);
      return uri.queryParameters['v'] ?? '';
    } else if (url.contains('youtu.be/')) {
      final uri = Uri.parse(url);
      return uri.pathSegments.last;
    } else if (url.length == 11) {
      return url;
    }
    return '';
  }
}
