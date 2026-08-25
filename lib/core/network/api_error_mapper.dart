import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A friendly version of a network error, ready to show on screen.
/// Splitting this from the raw exception means the UI never has to
/// know what a "503" is — it just gets a message and a color.
class FriendlyError {
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final bool canRetry;

  const FriendlyError({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    this.canRetry = true,
  });
}

/// This is the "room for creativity" part of the brief: instead of
/// dumping a raw status code at a student, we translate it into
/// plain language that explains what actually happened.
class ApiErrorMapper {
  ApiErrorMapper._();

  static FriendlyError map(Object error) {
    if (error is! DioException) {
      return const FriendlyError(
        title: 'Something went wrong',
        message: 'That was unexpected. Please try again.',
        icon: Icons.error_outline_rounded,
        color: AppColors.error,
      );
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const FriendlyError(
          title: 'Taking too long',
          message: 'Your connection is a bit slow right now. We kept trying, '
              'but it timed out. Try again once your signal is stronger.',
          icon: Icons.hourglass_bottom_rounded,
          color: AppColors.warning,
        );

      case DioExceptionType.connectionError:
        return const FriendlyError(
          title: 'No connection',
          message: 'Looks like you\'re offline. You can still open anything '
              'you\'ve already downloaded from your bookmarks.',
          icon: Icons.wifi_off_rounded,
          color: AppColors.info,
        );

      case DioExceptionType.badResponse:
        return _mapStatusCode(error.response?.statusCode);

      case DioExceptionType.cancel:
        return const FriendlyError(
          title: 'Cancelled',
          message: 'That request was cancelled.',
          icon: Icons.block_rounded,
          color: AppColors.textMuted,
          canRetry: false,
        );

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const FriendlyError(
          title: 'Connection problem',
          message: 'We couldn\'t reach MatricConnect. Check your data or wifi '
              'and try again.',
          icon: Icons.signal_wifi_bad_rounded,
          color: AppColors.error,
        );
    }
  }

  static FriendlyError _mapStatusCode(int? status) {
    switch (status) {
      case 400:
        return const FriendlyError(
          title: 'Something looks off',
          message: 'That request didn\'t make sense to the server. '
              'Try going back and opening the resource again.',
          icon: Icons.report_gmailerrorred_rounded,
          color: AppColors.warning,
        );

      case 401:
        return const FriendlyError(
          title: 'You\'ve been signed out',
          message: 'Your session expired for your safety. Please log in again '
              'to keep downloading resources.',
          icon: Icons.lock_outline_rounded,
          color: AppColors.warning,
          canRetry: false,
        );

      case 403:
        return const FriendlyError(
          title: 'Not available for you yet',
          message: 'This resource is limited to a different grade or subject. '
              'Ask your teacher if you think this is wrong.',
          icon: Icons.no_accounts_rounded,
          color: AppColors.warning,
          canRetry: false,
        );

      case 404:
        return const FriendlyError(
          title: 'We couldn\'t find that',
          message: 'This past paper or guide may have been moved or removed. '
              'Pull down to refresh the list.',
          icon: Icons.search_off_rounded,
          color: AppColors.error,
        );

      case 408:
        return const FriendlyError(
          title: 'Took too long',
          message: 'The download stalled. This usually happens on weak wifi — '
              'try again closer to your router.',
          icon: Icons.timer_off_rounded,
          color: AppColors.warning,
        );

      case 429:
        return const FriendlyError(
          title: 'Slow down a little',
          message: 'You\'re downloading quite fast! Wait a few seconds and '
              'try again.',
          icon: Icons.speed_rounded,
          color: AppColors.info,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return const FriendlyError(
          title: 'Our servers are having a moment',
          message: 'This isn\'t your fault — MatricConnect\'s servers are '
              'struggling right now. We already tried a couple of times '
              'automatically. Please try again shortly.',
          icon: Icons.cloud_off_rounded,
          color: AppColors.error,
        );

      default:
        return const FriendlyError(
          title: 'Unexpected error',
          message: 'Something went wrong on our end. Please try again.',
          icon: Icons.error_outline_rounded,
          color: AppColors.error,
        );
    }
  }
}
