import 'package:dugtong_buhay_para_kay_juan_v2/rss_service.dart';
import 'package:dugtong_buhay_para_kay_juan_v2/social_details.dart';
import 'package:flutter/material.dart';
import 'package:webfeed_revised/webfeed_revised.dart';
import 'package:intl/intl.dart';

const Map<String, String> rssFeeds = {
  'All': 'https://rss.app/feeds/6of1tauymmKAInXC.xml,https://rss.app/feeds/lYkBnJ8XRIPxyjhc.xml,https://rss.app/feeds/wux2D7cV4nGeYZtW.xml',
  'Makati DRRM Office': 'https://rss.app/feeds/6of1tauymmKAInXC.xml',
  'University of Makati': 'https://rss.app/feeds/lYkBnJ8XRIPxyjhc.xml',
  'PAGASA(DOST)': 'https://rss.app/feeds/wux2D7cV4nGeYZtW.xml',
};



class RssFeedPage extends StatefulWidget {
  const RssFeedPage({Key? key}) : super(key: key);

  @override
  _RssFeedPageState createState() => _RssFeedPageState();
}

class _RssFeedPageState extends State<RssFeedPage> {
  final RssService _rssService = RssService();
  late Future<List<RssItem>> _rssFeed;
  String _selectedCategory = 'All';
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _fetchFeed();
  }

  Future<void> _fetchFeed() async {
    setState(() {
      _isRefreshing = true;
      if (_selectedCategory == 'All') {
        _rssFeed = _fetchAllFeeds();
      } else {
        _rssFeed = _rssService.fetchRssFeed(rssFeeds[_selectedCategory]!);
      }
    });

    try {
      await _rssFeed;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load feed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  Future<List<RssItem>> _fetchAllFeeds() async {
    final allFeeds = rssFeeds['All']!
        .split(',')
        .map((url) => _rssService.fetchRssFeed(url.trim()))
        .toList();

    final allRssItems = <RssItem>[];
    for (var feed in allFeeds) {
      try {
        final items = await feed;
        allRssItems.addAll(items);
      } catch (e) {
        print('Error fetching one feed: $e');
      }
    }
    return allRssItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preparedness Feeds'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _fetchFeed,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryButtons(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchFeed,
              child: FutureBuilder<List<RssItem>>(
                future: _rssFeed,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return _buildErrorWidget(snapshot.error.toString());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No RSS feeds found.'));
                  }

                  return _buildFeedList(snapshot.data!);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: rssFeeds.keys.map((key) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: _isRefreshing || _selectedCategory == key
                    ? null
                    : () {
                  setState(() {
                    _selectedCategory = key;
                    _fetchFeed();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedCategory == key
                      ? Colors.blue // Selected button color
                      : Colors.blue, // Default button color
                  foregroundColor: Colors.white,
                ),

                child: Text(key),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading feed',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchFeed,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedList(List<RssItem> items) {
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        final item = items[index];

        final imageUrl = item.media?.contents?.isNotEmpty ?? false
            ? item.media!.contents!.first.url
            : null;

        return Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12.0),
            leading: imageUrl != null
                ? Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object error,
                  StackTrace? stackTrace) {
                return const Icon(Icons.error, size: 60, color: Colors.red);
              },
            )
                : const Icon(Icons.image_not_supported, size: 60),
            title: Text(
              item.title ?? 'No Title',
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  item.pubDate is DateTime
                      ? DateFormat('yyyy-MM-dd HH:mm')
                      .format(item.pubDate as DateTime)
                      : 'No Date',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RssDetailPage(item: item),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
