import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:yansnet/subscription/cubit/channel/channel_cubit.dart';
import 'package:yansnet/subscription/models/channel.dart';
import 'package:yansnet/subscription/widgets/channel_card.dart';

class ChannelScreen extends StatelessWidget {
  const ChannelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChannelCubit()..getChannels(),
      child: const ChannelArea(),
    );
  }
}

class ChannelArea extends StatelessWidget {
  const ChannelArea({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChannelCubit, ChannelState>(
      listener: (context, state) {
        state.maybeWhen(
          followed: () => context.go('/home'),
          orElse: () {

        },);
        // TODO: implement listener
      },
      child: BlocBuilder<ChannelCubit, ChannelState>(
        builder: (context, state) {
          return state.maybeWhen(
            success: (channels) => Scaffold(
              body: Column(
                children: List.generate(
                  channels.length,
                  (index) => ChannelCard(
                    Channel(
                      id: channels[index].id,
                      title: channels[index].title,
                      description: channels[index].description,
                      totalFollowers: channels[index].totalFollowers,
                    ),
                  ),
                ),
              ),
            ),
            loading: () => Skeletonizer(
              child: Scaffold(
                body: Column(
                  children: List.generate(
                    3,
                    (index) => ChannelCard(
                      Channel(
                        id: 1,
                        title: 'title',
                        description: 'description',
                        totalFollowers: 100,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            orElse: () => Center(
              // Centre le contenu dans le corps de la page
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centre verticalement
                children: [
                  Icon(
                    Icons.wifi_off, // Icône de Wi-Fi barré
                    size: 80, // Taille de l'icône
                    color: Colors.grey[600], // Couleur de l'icône
                  ),
                  const SizedBox(
                    height: 20,
                  ), // Espacement entre l'icône et le texte
                  Text(
                    'Oups !!! tu n\'es pas connecté', // Le texte de l'image
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
