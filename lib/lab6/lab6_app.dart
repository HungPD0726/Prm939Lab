import 'package:flutter/material.dart';

class Lab6App extends StatelessWidget {
  const Lab6App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PRM392 Lab 6',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE55C4F),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6EFE8),
      ),
      home: const MovieGenreScreen(),
    );
  }
}

enum MovieSort { az, za, year, rating }

extension MovieSortLabel on MovieSort {
  String get label {
    switch (this) {
      case MovieSort.az:
        return 'A-Z';
      case MovieSort.za:
        return 'Z-A';
      case MovieSort.year:
        return 'Year';
      case MovieSort.rating:
        return 'Rating';
    }
  }
}

class Movie {
  final String title;
  final int year;
  final double rating;
  final List<String> genres;
  final String posterUrl;
  final String synopsis;

  const Movie({
    required this.title,
    required this.year,
    required this.rating,
    required this.genres,
    required this.posterUrl,
    required this.synopsis,
  });
}

class MovieGenreScreen extends StatefulWidget {
  const MovieGenreScreen({super.key});

  @override
  State<MovieGenreScreen> createState() => _MovieGenreScreenState();
}

class _MovieGenreScreenState extends State<MovieGenreScreen> {
  static const List<Movie> _allMovies = [
    Movie(
      title: 'Dune: Part Two',
      year: 2024,
      rating: 8.7,
      genres: ['Action', 'Sci-Fi', 'Drama'],
      posterUrl: 'https://picsum.photos/seed/dune2/500/720',
      synopsis: 'Paul Atreides leads the Fremen while balancing prophecy and revenge.',
    ),
    Movie(
      title: 'Past Lives',
      year: 2023,
      rating: 8.0,
      genres: ['Drama', 'Romance'],
      posterUrl: 'https://picsum.photos/seed/pastlives/500/720',
      synopsis: 'Two childhood friends reconnect years later and confront what could have been.',
    ),
    Movie(
      title: 'Spider-Man: Across the Spider-Verse',
      year: 2023,
      rating: 8.6,
      genres: ['Action', 'Animation', 'Adventure'],
      posterUrl: 'https://picsum.photos/seed/spiderverse/500/720',
      synopsis: 'Miles Morales explores the multiverse and discovers new dimensions of heroism.',
    ),
    Movie(
      title: 'The Holdovers',
      year: 2023,
      rating: 8.1,
      genres: ['Comedy', 'Drama'],
      posterUrl: 'https://picsum.photos/seed/holdovers/500/720',
      synopsis: 'A teacher, a cook, and a grieving student spend an unexpected holiday together.',
    ),
    Movie(
      title: 'Top Gun: Maverick',
      year: 2022,
      rating: 8.3,
      genres: ['Action', 'Drama'],
      posterUrl: 'https://picsum.photos/seed/maverick/500/720',
      synopsis: 'Maverick trains a new generation of pilots for a near-impossible mission.',
    ),
    Movie(
      title: 'Soul',
      year: 2020,
      rating: 8.0,
      genres: ['Animation', 'Comedy', 'Drama'],
      posterUrl: 'https://picsum.photos/seed/soul/500/720',
      synopsis: 'A jazz musician journeys beyond Earth and rediscovers the meaning of living.',
    ),
    Movie(
      title: 'Everything Everywhere All at Once',
      year: 2022,
      rating: 7.8,
      genres: ['Action', 'Comedy', 'Sci-Fi'],
      posterUrl: 'https://picsum.photos/seed/eeaao/500/720',
      synopsis: 'A laundromat owner is pulled into a multiverse battle that becomes deeply personal.',
    ),
    Movie(
      title: 'Knives Out',
      year: 2019,
      rating: 7.9,
      genres: ['Comedy', 'Drama', 'Mystery'],
      posterUrl: 'https://picsum.photos/seed/knivesout/500/720',
      synopsis: 'A detective investigates a wealthy family after a novelist dies under suspicious circumstances.',
    ),
    Movie(
      title: 'Wonka',
      year: 2023,
      rating: 7.1,
      genres: ['Comedy', 'Fantasy', 'Family'],
      posterUrl: 'https://picsum.photos/seed/wonka/500/720',
      synopsis: 'The young chocolatier dreams big and builds his legend from scratch.',
    ),
    Movie(
      title: 'Interstellar',
      year: 2014,
      rating: 8.7,
      genres: ['Drama', 'Sci-Fi', 'Adventure'],
      posterUrl: 'https://picsum.photos/seed/interstellar/500/720',
      synopsis: 'Explorers travel through a wormhole while Earth races against collapse.',
    ),
  ];

  static const List<String> _genres = [
    'Action',
    'Adventure',
    'Animation',
    'Comedy',
    'Drama',
    'Family',
    'Fantasy',
    'Mystery',
    'Romance',
    'Sci-Fi',
  ];

  String searchQuery = '';
  MovieSort selectedSort = MovieSort.az;
  final Set<String> selectedGenres = {};

  List<Movie> _buildVisibleMovies() {
    final normalizedQuery = searchQuery.trim().toLowerCase();

    final visibleMovies = _allMovies.where((movie) {
      final matchesSearch =
          normalizedQuery.isEmpty ||
          movie.title.toLowerCase().contains(normalizedQuery);

      final matchesGenre =
          selectedGenres.isEmpty ||
          movie.genres.any((genre) => selectedGenres.contains(genre));

      return matchesSearch && matchesGenre;
    }).toList();

    visibleMovies.sort((a, b) {
      switch (selectedSort) {
        case MovieSort.az:
          return a.title.compareTo(b.title);
        case MovieSort.za:
          return b.title.compareTo(a.title);
        case MovieSort.year:
          return b.year.compareTo(a.year);
        case MovieSort.rating:
          return b.rating.compareTo(a.rating);
      }
    });

    return visibleMovies;
  }

  void _toggleGenre(String genre) {
    setState(() {
      if (selectedGenres.contains(genre)) {
        selectedGenres.remove(genre);
      } else {
        selectedGenres.add(genre);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTabletLayout = screenWidth >= 800;
    final isCompactPhone = screenWidth < 420;
    final horizontalPadding = screenWidth >= 1200
        ? 40.0
        : isTabletLayout
            ? 28.0
            : 16.0;
    final visibleMovies = _buildVisibleMovies();

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8D7C3), Color(0xFFF6EFE8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  isCompactPhone ? 10 : 16,
                  horizontalPadding,
                  isCompactPhone ? 8 : 12,
                ),
                child: _HeroSection(
                  isTabletLayout: isTabletLayout,
                  isCompactPhone: isCompactPhone,
                  totalMovies: _allMovies.length,
                  visibleMovies: visibleMovies.length,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: TextField(
                  onChanged: (value) => setState(() => searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search by title or keyword',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchQuery.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () => setState(() => searchQuery = ''),
                            icon: const Icon(Icons.close),
                          ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  isCompactPhone ? 12 : 16,
                  horizontalPadding,
                  8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Genres',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: isCompactPhone ? 8 : 10,
                    runSpacing: isCompactPhone ? 8 : 10,
                    children: [
                      for (final genre in _genres)
                        FilterChip(
                          label: Text(genre),
                          selected: selectedGenres.contains(genre),
                          onSelected: (_) => _toggleGenre(genre),
                          showCheckmark: false,
                          selectedColor: const Color(0xFFE55C4F),
                          labelStyle: TextStyle(
                            color: selectedGenres.contains(genre)
                                ? Colors.white
                                : const Color(0xFF46352B),
                            fontWeight: FontWeight.w600,
                          ),
                          backgroundColor: Colors.white,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: isCompactPhone
                              ? const VisualDensity(
                                  horizontal: -2,
                                  vertical: -2,
                                )
                              : VisualDensity.standard,
                          side: BorderSide(
                            color: selectedGenres.contains(genre)
                                ? const Color(0xFFE55C4F)
                                : const Color(0xFFE6D7CB),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  isCompactPhone ? 12 : 16,
                  horizontalPadding,
                  12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _MovieCounter(count: visibleMovies.length),
                    ),
                    const SizedBox(width: 12),
                    _SortDropdown(
                      value: selectedSort,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => selectedSort = value);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    0,
                    horizontalPadding,
                    16,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (visibleMovies.isEmpty) {
                        return _EmptyState(query: searchQuery);
                      }

                      if (constraints.maxWidth < 800) {
                        return ListView.separated(
                          itemCount: visibleMovies.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return MovieCard(movie: visibleMovies[index]);
                          },
                        );
                      }

                      final cardRatio = constraints.maxWidth >= 1200 ? 1.62 : 1.48;

                      return GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: cardRatio,
                        children: [
                          for (final movie in visibleMovies) MovieCard(movie: movie),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final bool isTabletLayout;
  final bool isCompactPhone;
  final int totalMovies;
  final int visibleMovies;

  const _HeroSection({
    required this.isTabletLayout,
    required this.isCompactPhone,
    required this.totalMovies,
    required this.visibleMovies,
  });

  @override
  Widget build(BuildContext context) {
    final headlineStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      height: 1.0,
      fontSize: isTabletLayout ? 48 : 30,
    );
    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Find a Movie', style: headlineStyle),
        SizedBox(height: isCompactPhone ? 8 : 12),
        Text(
          isCompactPhone
              ? 'Browse, filter, and sort movies with a responsive layout.'
              : 'Browse modern favorites, filter by genre, and let the layout adapt from phone to tablet without clipping.',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.45,
          ),
        ),
      ],
    );
    final badges = Wrap(
      alignment: isTabletLayout ? WrapAlignment.end : WrapAlignment.start,
      spacing: isCompactPhone ? 8 : 12,
      runSpacing: isCompactPhone ? 8 : 12,
      children: [
        _HeroBadge(
          title: 'Library',
          value: '$totalMovies titles',
          compact: isCompactPhone,
        ),
        _HeroBadge(
          title: 'Visible',
          value: '$visibleMovies matches',
          compact: isCompactPhone,
        ),
        if (!isCompactPhone)
          const _HeroBadge(title: 'Layout', value: 'Phone / Tablet'),
      ],
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompactPhone ? 16 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF231913), Color(0xFFB74937)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33231913),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: isTabletLayout
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: heading),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: badges),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                heading,
                const SizedBox(height: 16),
                badges,
              ],
            ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final String title;
  final String value;
  final bool compact;

  const _HeroBadge({
    required this.title,
    required this.value,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: compact ? 112 : 132,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 14,
        vertical: compact ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x2EFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFD9C6B8),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 14 : 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieCounter extends StatelessWidget {
  final int count;

  const _MovieCounter({required this.count});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$count movie${count == 1 ? '' : 's'} available',
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: const Color(0xFF6E5A4D),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _SortDropdown extends StatelessWidget {
  final MovieSort value;
  final ValueChanged<MovieSort?> onChanged;

  const _SortDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6D7CB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MovieSort>(
          value: value,
          onChanged: onChanged,
          borderRadius: BorderRadius.circular(18),
          items: [
            for (final sort in MovieSort.values)
              DropdownMenuItem<MovieSort>(
                value: sort,
                child: Text(sort.label),
              ),
          ],
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final posterWidth = cardWidth >= 520
            ? 156.0
            : cardWidth >= 380
                ? 128.0
                : 104.0;
        final posterHeight = posterWidth * 1.45;
        final showCompactMeta = cardWidth < 340;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    movie.posterUrl,
                    width: posterWidth,
                    height: posterHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: posterWidth,
                        height: posterHeight,
                        color: const Color(0xFFF1E7DE),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.movie_creation_outlined,
                          color: Color(0xFF9F8B7E),
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8E1D9),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          movie.genres.first,
                          style: const TextStyle(
                            color: Color(0xFFAF4B3D),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                          fontSize: showCompactMeta ? 18 : 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.synopsis,
                        maxLines: showCompactMeta ? 3 : 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF6E5A4D),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _MetaPill(
                            icon: Icons.calendar_today_outlined,
                            label: '${movie.year}',
                          ),
                          _MetaPill(
                            icon: Icons.star_rounded,
                            label: movie.rating.toStringAsFixed(1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final genre in movie.genres.take(3))
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6EFE8),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                genre,
                                style: const TextStyle(
                                  color: Color(0xFF5D4A3E),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
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
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E7DE),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFFAF4B3D)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF46352B),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;

  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    final caption = query.trim().isEmpty
        ? 'Try clearing some genre filters.'
        : 'No movie title matches "$query".';

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Color(0xFFAF4B3D),
            ),
            const SizedBox(height: 12),
            Text(
              'No movies found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              caption,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF6E5A4D),
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
