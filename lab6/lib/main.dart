import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 1. Định nghĩa Model cho Movie
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// 2. Dữ liệu mẫu (Sample Data)
final List<Movie> allMovies = [
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi', 'Thriller'],
    posterUrl: 'https://picsum.photos/seed/inception/300/450',
    rating: 8.8,
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama', 'Thriller'],
    posterUrl: 'https://picsum.photos/seed/darkknight/300/450',
    rating: 9.0,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Adventure', 'Drama', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/seed/interstellar/300/450',
    rating: 8.6,
  ),
  Movie(
    title: 'Comedy Central',
    year: 2021,
    genres: ['Comedy'],
    posterUrl: 'https://picsum.photos/seed/comedy/300/450',
    rating: 7.2,
  ),
  Movie(
    title: 'The Hangover',
    year: 2009,
    genres: ['Comedy'],
    posterUrl: 'https://picsum.photos/seed/hangover/300/450',
    rating: 7.7,
  ),
  Movie(
    title: 'Parasite',
    year: 2019,
    genres: ['Drama', 'Thriller'],
    posterUrl: 'https://picsum.photos/seed/parasite/300/450',
    rating: 8.5,
  ),
  Movie(
    title: 'Avengers: Endgame',
    year: 2019,
    genres: ['Action', 'Adventure', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/seed/avengers/300/450',
    rating: 8.4,
  ),
];

final List<String> availableGenres = [
  'Action',
  'Adventure',
  'Comedy',
  'Drama',
  'Sci-Fi',
  'Thriller',
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Genre Browsing',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GenreScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  String searchQuery = '';
  final Set<String> selectedGenres = {};
  String selectedSort = 'A–Z';

  @override
  Widget build(BuildContext context) {
    // 1. Lọc danh sách phim theo từ khóa tìm kiếm và thể loại đã chọn
    List<Movie> filteredMovies = allMovies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesGenre = selectedGenres.isEmpty ||
          movie.genres.any((genre) => selectedGenres.contains(genre));
      return matchesSearch && matchesGenre;
    }).toList();

    // 2. Sắp xếp danh sách phim theo tùy chọn chọn ở Dropdown
    filteredMovies.sort((a, b) {
      switch (selectedSort) {
        case 'Z–A':
          return b.title.compareTo(a.title);
        case 'Year':
          return b.year.compareTo(a.year); // Phim mới hơn lên trước
        case 'Rating':
          return b.rating.compareTo(a.rating); // Đánh giá cao lên trước
        case 'A–Z':
        default:
          return a.title.compareTo(b.title);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Movie'),
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh tìm kiếm (Search Bar)
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search movies by title...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Tiêu đề & Danh sách Chip thể loại (Dùng Wrap để tự động xuống dòng)
              const Text(
                'Genres',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: availableGenres.map((genre) {
                  final isSelected = selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedGenres.add(genre);
                        } else {
                          selectedGenres.remove(genre);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Thanh hiển thị số lượng kết quả và Dropdown sắp xếp (Sort Bar)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Results (${filteredMovies.length})',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: selectedSort,
                    items: ['A–Z', 'Z–A', 'Year', 'Rating']
                        .map((sortOption) => DropdownMenuItem(
                      value: sortOption,
                      child: Text('Sort: $sortOption'),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedSort = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Danh sách phim responsive sử dụng LayoutBuilder và Breakpoint (800px)
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isWideScreen = constraints.maxWidth >= 800;

                    if (filteredMovies.isEmpty) {
                      return const Center(
                        child: Text(
                          'No movies found.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    if (!isWideScreen) {
                      // Giao diện điện thoại màn hình nhỏ (< 800px): ListView 1 cột
                      return ListView.builder(
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          final movie = filteredMovies[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      movie.posterUrl,
                                      width: 80,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                            width: 80,
                                            height: 120,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.broken_image),
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text('Year: ${movie.year}'),
                                        const SizedBox(height: 4),
                                        Text('Rating: ⭐ ${movie.rating}'),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 4,
                                          children: movie.genres
                                              .map((g) => Chip(
                                            label: Text(g,
                                                style: const TextStyle(
                                                    fontSize: 10)),
                                            padding: EdgeInsets.zero,
                                            materialTapTargetSize:
                                            MaterialTapTargetSize
                                                .shrinkWrap,
                                          ))
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      // Giao diện máy tính bảng / web rộng (>= 800px): Lưới 2 cột
                      return GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 2.2,
                        ),
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          final movie = filteredMovies.length > index ? filteredMovies[index] : filteredMovies[0];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      movie.posterUrl,
                                      width: 90,
                                      height: 130,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                            width: 90,
                                            height: 130,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.broken_image),
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          movie.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text('Year: ${movie.year}',
                                            style: const TextStyle(fontSize: 13)),
                                        const SizedBox(height: 4),
                                        Text('Rating: ⭐ ${movie.rating}',
                                            style: const TextStyle(fontSize: 13)),
                                        const SizedBox(height: 6),
                                        Wrap(
                                          spacing: 4,
                                          runSpacing: 2,
                                          children: movie.genres
                                              .map((g) => Chip(
                                            label: Text(g,
                                                style: const TextStyle(
                                                    fontSize: 9)),
                                            padding: EdgeInsets.zero,
                                            materialTapTargetSize:
                                            MaterialTapTargetSize
                                                .shrinkWrap,
                                          ))
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}