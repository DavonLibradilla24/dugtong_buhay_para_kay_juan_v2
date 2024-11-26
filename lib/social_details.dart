import 'package:flutter/material.dart';
import 'package:webfeed_revised/webfeed_revised.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'fullscreen.dart';


class RssDetailPage extends StatelessWidget {
  final RssItem item;

  const RssDetailPage({Key? key, required this.item}) : super(key: key);

  Future<void> _launchUrl(String? url) async {
    if (url == null) {
      debugPrint('URL is null');
      return;
    }

    final uri = Uri.parse(url);
    debugPrint('Attempting to launch: $uri');

    if (await canLaunchUrl(uri)) {
      debugPrint('Launching URL: $uri');
      await launchUrl(uri, mode: LaunchMode.externalApplication); // Open in external browser
    } else {
      debugPrint('Could not launch URL: $url');
    }
  }

  void _shareArticle(BuildContext context) {
    final String shareText = '''
${item.title}

${item.description?.replaceAll(RegExp(r'<[^>]*>'), '')}

Read more: ${item.link}
''';

    Share.share(shareText, subject: item.title);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No Date';
    return timeago.format(date);
  }

  Future<void> _refreshContent() async {
    debugPrint("Refreshing the content...");
    // Add logic to refresh the RSS feed here
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          item.title ?? 'Details',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareArticle(context),
            tooltip: 'Share Article',
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshContent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      _buildTitle(theme),
                      const SizedBox(height: 8.0),
                      _buildMetadata(theme),
                      const SizedBox(height: 16.0),
                      if (item.author != null) _buildAuthor(theme),
                      const SizedBox(height: 16.0),
                      _buildContent(context, theme),
                      const SizedBox(height: 24.0),
                      if (item.categories?.isNotEmpty ?? false)
                        _buildCategories(theme),
                      const SizedBox(height: 32.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      item.title ?? 'No Title',
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMetadata(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 16.0,
          color: theme.textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 4.0),
        Text(
          _formatDate(item.pubDate),
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildAuthor(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.person_outline,
          size: 16.0,
          color: theme.textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 4.0),
        Text(
          'By ${item.author}',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    if (item.description == null) {
      return Text(
        'No content available',
        style: theme.textTheme.bodyMedium,
      );
    }

    final imageUrl = item.media?.contents?.isNotEmpty ?? false
        ? item.media!.contents!.first.url
        : null;

    return Column(
      children: [
        if (imageUrl != null)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImagePage(imageUrl: imageUrl),
                ),
              );
            },
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(Icons.error, size: 100, color: Colors.red),
                      SizedBox(height: 8.0),
                      Text(
                        'Image failed to load',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        Html(
          data: item.description!,
          style: {
            'body': Style(
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
              fontSize: FontSize(16.0),
              lineHeight: LineHeight(1.6),
            ),
            'a': Style(
              color: theme.colorScheme.primary,
              textDecoration: TextDecoration.none,
            ),
            'p': Style(
              margin: Margins(bottom: Margin(8)),
            ),
            'img': Style(
              margin: Margins(bottom: Margin(8), top: Margin(8)),
              alignment: Alignment.centerLeft,
            ),
          },
          onLinkTap: (url, _, __) {
            if (url != null) _launchUrl(url);
          },
        ),
      ],
    );
  }

  Widget _buildCategories(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: item.categories?.map((category) {
            return Chip(
              label: Text(category.value ?? ''),
              backgroundColor: theme.colorScheme.secondaryContainer,
              labelStyle: TextStyle(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            );
          }).toList() ?? [],
        ),
      ],
    );
  }
}
