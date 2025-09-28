import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/movie_bloc.dart';
import '../blocs/movie_event.dart';
import '../blocs/movie_state.dart';
import '../widgets/movie_grid.dart';
import '../widgets/search_bar_widget.dart';
import 'movie_detail_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Search'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.black87,
            child: SearchBarWidget(
              onSearch: (query) {
                context.read<MovieBloc>().add(SearchMovies(query));
              },
              onClear: () {
                context.read<MovieBloc>().add(ClearSearch());
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state is MovieInitial) {
                  return const _InitialState();
                } else if (state is MovieLoading) {
                  return const _LoadingState();
                } else if (state is MovieLoaded) {
                  return MovieGrid(
                    movies: state.movies,
                    onMovieTap: (movie) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(movie: movie),
                        ),
                      );
                    },
                  );
                } else if (state is MovieEmpty) {
                  return const _EmptyState();
                } else if (state is MovieError) {
                  return _ErrorState(
                    message: state.message,
                    onRetry: () {
                      context.read<MovieBloc>().add(RetrySearch());
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InitialState extends StatelessWidget {
  final bool isCompact;

  const _InitialState({this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie,
            size: isCompact ? 60 : 80,
            color: Colors.grey,
          ),
          SizedBox(height: isCompact ? 8 : 16),
          Text(
            'Search for movies and TV shows',
            style: TextStyle(
              fontSize: isCompact ? 16 : 18,
              color: Colors.grey,
            ),
          ),
          if (!isCompact) ...[
            const SizedBox(height: 8),
            const Text(
              'Use the search bar above to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  final bool isCompact;

  const _LoadingState({this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: isCompact ? 8 : 16),
          const Text(
            'Searching...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isCompact;

  const _EmptyState({this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: isCompact ? 60 : 80,
            color: Colors.grey,
          ),
          SizedBox(height: isCompact ? 8 : 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: isCompact ? 16 : 18,
              color: Colors.grey,
            ),
          ),
          if (!isCompact) ...[
            const SizedBox(height: 8),
            const Text(
              'Try searching with different keywords',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final bool isCompact;
  final VoidCallback? onRetry;

  const _ErrorState({
    required this.message,
    this.isCompact = false,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: isCompact ? 60 : 80,
              color: Colors.red,
            ),
            SizedBox(height: isCompact ? 8 : 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: isCompact ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!isCompact) ...[
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
            SizedBox(height: isCompact ? 12 : 24),
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 16 : 24,
                    vertical: isCompact ? 8 : 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}