part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class OnQueryChanged extends SearchEvent {
  const OnQueryChanged(this.query);
  final String query;

  @override
  List<Object?> get props => <Object?>[query];
}
