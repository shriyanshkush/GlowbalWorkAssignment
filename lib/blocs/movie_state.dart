import 'package:equatable/equatable.dart';
import '../models/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final String query;

  const MovieLoaded(this.movies, this.query);

  @override
  List<Object> get props => [movies, query];
}

class MovieError extends MovieState {
  final String message;

  const MovieError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieEmpty extends MovieState {}