import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_hand_app/bloc/my_detail_order/my_order_detail_event.dart';
import 'package:second_hand_app/bloc/my_detail_order/my_order_detail_state.dart';
import 'package:second_hand_app/repositories/market_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrderDetailBloc extends Bloc<MyOrderDetailEvent, MyOrderDetailState> {
  final MarketRepository _repository;
  MyOrderDetailBloc(this._repository) : super(MyOrderDetailInitState()) {
    on<GetMyOrderDetail>(_getMyMyOrderDetail);
    on<PutMyBidPrice>(_putMyMyOrderDetail);
    on<DeleteMyOrder>(_deleteMyMyOrderDetail);
  }

  Future<void> _getMyMyOrderDetail(
      GetMyOrderDetail event, Emitter<MyOrderDetailState> emit) async {
    emit(MyOrderDetailLoadingState());
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final data = await _repository.getMyOrderDetail(
          accessToken: accessToken!, orderId: event.id);
      emit(MyOrderDetailLoadedState(data));
    } catch (e) {
      emit(MyOrderDetailErrorState(e.toString()));
    }
  }

  Future<void> _putMyMyOrderDetail(
      PutMyBidPrice event, Emitter<MyOrderDetailState> emit) async {
    emit(MyOrderDetailLoadingState());
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final data = await _repository.putMyOrderDetail(
          accessToken: accessToken!,
          orderId: event.id,
          bidPrice: event.bidPrice);
      emit(PatchBidSuccessState(data));
    } catch (e) {
      emit(MyOrderDetailErrorState(e.toString()));
    }
  }

  Future<void> _deleteMyMyOrderDetail(
      DeleteMyOrder event, Emitter<MyOrderDetailState> emit) async {
    emit(MyOrderDetailLoadingState());
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final data = await _repository.deleteMyOrderDetail(
          accessToken: accessToken!, orderId: event.id);
      emit(DeleteOrderSuccessState(data));
    } catch (e) {
      emit(MyOrderDetailErrorState(e.toString()));
    }
  }
}
