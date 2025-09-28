import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/movie_service.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieService movieService;
  String _lastQuery = '';

  MovieBloc(this.movieService) : super(MovieInitial()) {
    on<SearchMovies>(_onSearchMovies);
    on<ClearSearch>(_onClearSearch);
    on<RetrySearch>(_onRetrySearch);
  }

  Future<void> _onSearchMovies(
      SearchMovies event,
      Emitter<MovieState> emit,
      ) async {
    if (event.query.isEmpty) {
      emit(MovieEmpty());
      return;
    }

    _lastQuery = event.query;
    emit(MovieLoading());

    try {
      final movies = await movieService.searchMovies(event.query);
      if (movies.isEmpty) {
        emit(MovieEmpty());
      } else {
        emit(MovieLoaded(movies, event.query));
      }
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<MovieState> emit) {
    _lastQuery = '';
    emit(MovieInitial());
  }

  Future<void> _onRetrySearch(
      RetrySearch event,
      Emitter<MovieState> emit,
      ) async {
    if (_lastQuery.isNotEmpty) {
      add(SearchMovies(_lastQuery));
    }
  }

  String get lastQuery => _lastQuery;
}