import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/models/_course_model.dart';
import 'package:joblagbe/app/data/models/_course_lesson_model.dart';
import 'package:joblagbe/app/data/models/_course_progress_model.dart';
import 'package:joblagbe/app/data/services/_applicant_course_service.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ApplicantCourseViewController extends GetxController {
  final ApplicantCourseService _courseService = ApplicantCourseService();
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
  var courseProgress = Rxn<CourseProgressModel>();

  ApplicantCourseViewController({required this.course});

  @override
  void onInit() {
    super.onInit();
    resetState();
    loadLessons();
    loadCourseProgress();
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
          await _courseService.getAllLessonsForCourse(course.id!);
      if (courseLessons != null) {
        // Sort lessons by orderIndex
        courseLessons.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
        lessons.clear();
        lessons.addAll(courseLessons);
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

  Future<void> loadCourseProgress() async {
    try {
      final progress = await _courseService.getCourseProgress(course.id!);
      courseProgress.value = progress;
    } catch (e) {
      print('Error loading course progress: $e');
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
      currentYoutubeController.value = null;
    }
  }

  void togglePlayPause() {
    isPlaying.value = !isPlaying.value;
    if (currentYoutubeController.value != null) {
      if (isPlaying.value) {
        currentYoutubeController.value!.playVideo();
      } else {
        currentYoutubeController.value!.pauseVideo();
      }
    }
  }

  void updateProgress(double progress) {
    videoProgress.value = progress;
    currentTime.value = (progress * videoDuration.value).round();
  }

  void toggleFullscreen() {
    isFullscreen.value = !isFullscreen.value;
    if (currentYoutubeController.value != null) {
      // currentYoutubeController.value!.toggleFullscreen();
    }
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

  var isMarkingAsCompleted = false.obs;

  Future<void> markLessonAsCompleted() async {
    if (selectedLesson.value == null || courseProgress.value == null) return;
    isMarkingAsCompleted.value = true;
    try {
      bool isComplete = await _courseService.markLessonAsCompleted(
        course.id!,
        selectedLesson.value!.id!,
      );
      // Reload course progress after marking lesson as completed

      if (isComplete) {
        return;
      }

      await loadCourseProgress();
    } catch (e) {
      customDialog("Error", e.toString());
    } finally {
      isMarkingAsCompleted.value = false;
    }
  }
}
