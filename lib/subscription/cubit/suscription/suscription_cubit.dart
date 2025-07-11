import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'suscription_state.dart';
part 'suscription_cubit.freezed.dart';

class SuscriptionCubit extends Cubit<SuscriptionState> {
  SuscriptionCubit() : super(const SuscriptionState.initial());
}
