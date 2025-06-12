import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class TransactionContainer extends StatelessWidget {
  final String type;
  final String color;

  const TransactionContainer({Key? key, required this.type, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color IconColor;
    IconData iconData;
    
    backgroundColor = Customtext.stringToColor(color);

    switch (type) {
  case 'I00':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.card;
    break;
  case 'I01':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.ticket_star;
    break;
  case 'I02':
    backgroundColor;
    IconColor = const Color(0xFF003A12);
    iconData = Iconsax.video;
    break;
  case 'I03':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.music;
    break;
  case 'I04':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.video_play;
    break;
  case 'I05':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.bank;
    break;
  case 'I06':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.briefcase;
    break;
  case 'I07':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.calendar;
    break;
  case 'I08':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.chart_1;
    break;
  case 'I09':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.chart_2;
    break;
  case 'I10':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.emoji_happy;
    break;
  case 'I11':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.game;
    break;
  case 'I12':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.gift;
    break;
  case 'I13':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.global;
    break;
  case 'I14':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.heart;
    break;
  case 'I15':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.home;
    break;
  case 'I16':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.security;
    break;
  case 'I17':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.shop;
    break;
  case 'I18':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.star;
    break;
  case 'I19':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.tag;
    break;
  case 'I20':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.trash;
    break;
  case 'I21':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.airplane;
    break;
  case 'I22':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.gas_station;
    break;
  case 'I23':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.shopping_cart;
    break;
  case 'I24':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.book;
    break;
  case 'I25':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.teacher;
    break;
  case 'I26':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.rulerpen;
    break;
  case 'I27':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.cake;
    break;
  case 'I28':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.coffee;
    break;
  case 'I29':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.pet;
    break;
  case 'I30':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.mobile;
    break;
  case 'I31':
    backgroundColor;
    IconColor = AppTheme.whiteColor;
    iconData = Iconsax.gameboy;
    break;
  default:
    backgroundColor = Colors.grey;
    IconColor = Colors.white;
    iconData = Iconsax.refresh_left_square;
}


    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Icon(
        iconData,
        color: IconColor,
        size: 24,
      ),
    );
  }
}
