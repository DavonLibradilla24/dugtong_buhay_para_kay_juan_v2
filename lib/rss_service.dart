import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:webfeed_revised/webfeed_revised.dart';

class RssServiceException implements Exception {
  final String message;
  final dynamic originalError;

  RssServiceException(this.message, [this.originalError]);

  @override
  String toString() => 'RssServiceException: $message${originalError != null ? ' ($originalError)' : ''}';
}

class RssService {
  final http.Client _client;
  final Duration timeout;
  final int maxRetries;
  final Duration retryDelay;

  RssService({
    http.Client? client,
    this.timeout = const Duration(seconds: 10),
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  }) : _client = client ?? http.Client();

  Future<List<RssItem>> fetchRssFeed(String url) async {
    int attempts = 0;
    late dynamic lastError;

    while (attempts < maxRetries) {
      try {
        return await _fetchWithTimeout(url);
      } on SocketException catch (e) {
        lastError = e;
        if (_shouldRetry(attempts)) {
          await Future.delayed(retryDelay * (attempts + 1));
          attempts++;
          continue;
        }
        throw RssServiceException('Network connection error', e);
      } on TimeoutException catch (e) {
        lastError = e;
        if (_shouldRetry(attempts)) {
          await Future.delayed(retryDelay * (attempts + 1));
          attempts++;
          continue;
        }
        throw RssServiceException('Request timed out', e);
      } on FormatException catch (e) {
        // Don't retry on parse errors
        throw RssServiceException('Invalid RSS feed format', e);
      } catch (e) {
        lastError = e;
        if (_shouldRetry(attempts)) {
          await Future.delayed(retryDelay * (attempts + 1));
          attempts++;
          continue;
        }
        throw RssServiceException('Failed to fetch RSS feed', e);
      }
    }

    throw RssServiceException(
      'Failed to fetch RSS feed after $maxRetries attempts',
      lastError,
    );
  }

  Future<List<RssItem>> _fetchWithTimeout(String url) async {
    final response = await _client.get(Uri.parse(url))
        .timeout(timeout, onTimeout: () {
      throw TimeoutException('Request timed out after ${timeout.inSeconds} seconds');
    });

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw RssServiceException('Empty response received from server');
      }

      try {
        final feed = RssFeed.parse(response.body);
        return feed.items ?? [];
      } on FormatException catch (e) {
        throw RssServiceException('Failed to parse RSS feed', e);
      }
    } else {
      throw RssServiceException('Failed to load RSS feed');
    }
  }



  bool _shouldRetry(int currentAttempt) {
    return currentAttempt < maxRetries - 1;
  }

  void dispose() {
    _client.close();
  }
}

// Extension method for more descriptive error messages
extension RssServiceExceptionHelper on RssServiceException {
  String get userFriendlyMessage {
    if (message.contains('Network connection error')) {
      return 'Please check your internet connection and try again.';
    } else if (message.contains('timed out')) {
      return 'The server is taking too long to respond. Please try again later.';
    } else if (message.contains('Invalid RSS feed format')) {
      return 'The RSS feed appears to be invalid or corrupted.';
    } else if (message.contains('404')) {
      return 'The RSS feed could not be found. Please verify the URL.';
    } else if (message.contains('500')) {
      return 'The server encountered an error. Please try again later.';
    }
    return 'An error occurred while loading the RSS feed. Please try again.';
  }
}