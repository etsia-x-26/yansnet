import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yansnet/app/view/app_dev.dart';
import 'package:yansnet/bootstrap.dart';
import 'package:yansnet/core/network/dio.dart';
import 'package:yansnet/publication/api/publication_client.dart';
import 'package:yansnet/publication/cubit/publication_cubit.dart';

void main() {
  bootstrap(() => BlocProvider<PublicationCubit>(
    create: (context) => PublicationCubit(PublicationClient(http)),
    child: const AppDev(),
  ),);
}
