import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/home_page_repository.dart';
import 'home_page_events.dart';
import 'home_page_states.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final HomePageRepository _repository;

  HomePageBloc(this._repository) : super(HomePageLoadingState()) {
    on<LoadHomePageEvent>((event, emit) async {
      emit(HomePageLoadingState());
      try {
        final data = await _repository.getProducts();
        emit(HomePageLoadedState(data));
      } catch (e) {
        emit(HomePageErrorState(e.toString()));
      }
    });
  }
}
