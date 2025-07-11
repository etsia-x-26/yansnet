import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yansnet/app/theme/app_theme.dart';
import 'package:yansnet/subscription/cubit/channel/channel_cubit.dart';
import 'package:yansnet/subscription/models/channel.dart';

class ChannelCard extends StatelessWidget {
  const ChannelCard(this.channel, {super.key});
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 7, bottom: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                channel.title,
                style: GoogleFonts.aBeeZee(),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                channel.description,
                style: GoogleFonts.aBeeZee(color: kSecondaryColor),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '${channel.totalFollowers.toString()} followers',
                style: GoogleFonts.aBeeZee(color: kSecondaryColor),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 54,
              //width: 275,
              margin: const EdgeInsets.only(
                top: 4,
                bottom: 4,
                left: 5,
                right: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: kPrimaryColor,
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () => context.read<ChannelCubit>().followChannels(
                    channel.id,
                    1,
                  ),
                  child: Text(
                    'Suivre',
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
