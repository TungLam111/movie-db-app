part of 'search_bloc.dart';

abstract class SearchEvent {}

class OnQueryChanged extends SearchEvent {
  OnQueryChanged(this.query);
  final String query;
}
