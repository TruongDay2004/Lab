import 'package:flutter/material.dart';

void main() {
  runApp(const MovieApp());
}

// ==========================================
// 1. DATA MODELS
// ==========================================
class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<String> trailers;
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
    this.isFavorite = false,
  });
}

// Dữ liệu mẫu (Static sample data) bám sát hình ảnh yêu cầu
List<Movie> sampleMovies = [
  Movie(
    id: '1',
    title: 'Dune: Part Two',
    posterUrl: 'https://picsum.photos/seed/dune/600/300',
    overview: 'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.',
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    rating: 8.6,
    trailers: ['Official Trailer #1', 'IMAX Sneak Peek'],
  ),
  Movie(
    id: '2',
    title: 'Deadpool & Wolverine',
    posterUrl: 'https://picsum.photos/seed/deadpool/600/300',
    overview: 'The multiverse gets messy when Wade Wilson teams up with Wolverine for a not-so-family-friendly mission.',
    genres: ['Action', 'Comedy'],
    rating: 8.3,
    trailers: ['Red Band Trailer', 'Behind the Scenes'],
  ),
];

// ==========================================
// 2. MAIN APPLICATION WIDGET
// ==========================================
class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Detail App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ==========================================
// 3. HOME SCREEN (Danh sách phim)
// ==========================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: sampleMovies.length,
        itemBuilder: (context, index) {
          final movie = sampleMovies[index];
          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                // Điều hướng sang trang chi tiết và nhận lại dữ liệu cập nhật (nếu có)
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movie),
                  ),
                );
                setState(() {}); // Cập nhật lại giao diện Home khi quay lại (trạng thái Favorite)
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Poster thumbnail nhỏ ở danh sách
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        movie.posterUrl,
                        width: 90,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Tiêu đề, rating và thể loại
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '⭐ ${movie.rating} • ${movie.genres.join(', ')}',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// 4. MOVIE DETAIL SCREEN (Chi tiết phim)
// ==========================================
class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Banner với Stack và Gradient hiệu ứng chữ đè lên ảnh
            Stack(
              children: [
                Image.network(
                  widget.movie.posterUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Text(
                    widget.movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 2. Thể loại phim dạng Chip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                children: widget.movie.genres.map((genre) {
                  return Chip(
                    label: Text(genre),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // 3. Overview text (Nội dung tóm tắt)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.movie.overview,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            ),
            const SizedBox(height: 20),

            // 4. Action Buttons (Favorite / Rate / Share)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Nút Favorite có cập nhật trạng thái toggle
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        widget.movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: widget.movie.isFavorite ? Colors.red : Colors.black87,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.movie.isFavorite = !widget.movie.isFavorite;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(widget.movie.isFavorite
                                ? 'Added to favorites'
                                : 'Removed from favorites'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    const Text('Favorite', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.star_rate),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Rate button tapped!'), duration: Duration(seconds: 1)),
                        );
                      },
                    ),
                    const Text('Rate', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Share button tapped!'), duration: Duration(seconds: 1)),
                        );
                      },
                    ),
                    const Text('Share', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            const Divider(height: 30),

            // 5. Danh sách Trailers
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Trailers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.movie.trailers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.black87,
                    child: Icon(Icons.play_arrow, color: Colors.white),
                  ),
                  title: Text(widget.movie.trailers[index]),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Playing: ${widget.movie.trailers[index]}'), duration: const Duration(seconds: 1)),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}