import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yansnet/subscription/cubit/channel/channel_cubit.dart';
import 'package:yansnet/subscription/widgets/input_card.dart';
import 'package:yansnet/subscription/widgets/validated_button.dart';

class CreateChannelScreen extends StatelessWidget {
  const CreateChannelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChannelCubit(),
      child: const CreateScreenArea(),
    );
  }
}

class CreateScreenArea extends StatelessWidget {
  const CreateScreenArea({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    return BlocListener<ChannelCubit, ChannelState>(
      listener: (context, state) {
        // TODO: implement listener
        state.maybeWhen(
          error: (error) {
            Navigator.of(context).pop();
            var snackBar = SnackBar(
              content: Text(error,
                  style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.error)),
              backgroundColor: Theme.of(context).colorScheme.onError,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          success: (channels) {
            context.go('/home');
          },
          loading: () {
            Future<void> showMyDialog() async {
              return showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return const AlertDialog(
                    title: Text('Loading'),
                    content: SingleChildScrollView(
                      child: Center(
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: (CircularProgressIndicator()),
                          )),
                    ),
                  );
                },
              );
            }
            showMyDialog();
          },
          orElse: () {
            var snackBar = SnackBar(
              content: Text('une erreur est survenue',
                  style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.error)),
              backgroundColor: Theme.of(context).colorScheme.onError,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },);
      },
      child: BlocBuilder<ChannelCubit, ChannelState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Créer une chaîne',
                style: GoogleFonts.jua(),
              ),
            ),
            body: Column(
              children: [
                InputCard(
                  align: TextAlign.start,
                  controller: titleController,
                  enabled: true,
                  onChanged: (p0) {},
                  validator: (p0) {
                    return '';
                  },
                  obscureText: false,
                  inputType: TextInputType.text,
                  borderEnabled: true,
                  label: 'Nom du groupe',
                ),

                InputCard(
                  align: TextAlign.start,
                  controller: descriptionController,
                  enabled: true,
                  onChanged: (p0) {},
                  validator: (p0) {
                    return '';
                  },
                  obscureText: false,
                  inputType: TextInputType.text,
                  borderEnabled: true,
                  label: 'Description',
                ),

                ValidatedButton(
                  onTap: () {
                    context.read<ChannelCubit>().createChannel(
                      titleController.text,
                      descriptionController.text,
                    );
                  },
                  text: 'Créer',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
