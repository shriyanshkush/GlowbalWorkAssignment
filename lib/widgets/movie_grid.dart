import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'movie_card.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie) onMovieTap;

  const MovieGrid({
    super.key,
    required this.movies,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double childAspectRatio;

        if (constraints.maxWidth < 600) {
          // Phone
          crossAxisCount = 2;
          childAspectRatio = 0.7;
        } else if (constraints.maxWidth < 900) {
          // Small tablet
          crossAxisCount = 3;
          childAspectRatio = 0.75;
        } else {
          // Large tablet
          crossAxisCount = 4;
          childAspectRatio = 0.8;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return MovieCard(
              movie: movie,
              onTap: () => onMovieTap(movie),
            );
          },
        );
      },
    );
  }
}