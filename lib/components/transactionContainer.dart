import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class TransactionContainer extends StatelessWidget {
  final String type;
  final String color;

  const TransactionContainer(
      {Key? key, required this.type, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color IconColor;
    IconData iconData;

    backgroundColor = Customtext.stringToColor(color);

    switch (type) {
      case 'I01':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.forkKnife(PhosphorIconsStyle.regular);
        break;
      case 'I02':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.tShirt(PhosphorIconsStyle.regular);
        break;
      case 'I03':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.shoppingCart(PhosphorIconsStyle.regular);
        break;
      case 'I04':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.coffee(PhosphorIconsStyle.regular);
        break;
      case 'I05':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.cake(PhosphorIconsStyle.regular);
        break;
      case 'I06':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.gasPump(PhosphorIconsStyle.regular);
        break;
      case 'I07':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.wallet(PhosphorIconsStyle.regular);
        break;
      case 'I08':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.bank(PhosphorIconsStyle.regular);
        break;
      case 'I09':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.gift(PhosphorIconsStyle.regular);
        break;
      case 'I10':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.house(PhosphorIconsStyle.regular);
        break;
      case 'I11':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.basket(PhosphorIconsStyle.regular);
        break;
      case 'I12':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.bookOpen(PhosphorIconsStyle.regular);
        break;
      case 'I13':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.chalkboardTeacher(PhosphorIconsStyle.regular);
        break;
      case 'I14':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.pawPrint(PhosphorIconsStyle.regular);
        break;
      case 'I15':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.airplaneTilt(PhosphorIconsStyle.regular);
        break;
      case 'I16':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.briefcase(PhosphorIconsStyle.regular);
        break;
      case 'I17':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.chartBar(PhosphorIconsStyle.regular);
        break;
      case 'I18':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.heart(PhosphorIconsStyle.regular);
        break;
      case 'I19':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.shieldCheck(PhosphorIconsStyle.regular);
        break;
      case 'I20':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.hamburger(PhosphorIconsStyle.regular);
        break;
      case 'I21':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.pizza(PhosphorIconsStyle.regular);
        break;
      case 'I22':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.musicNote(PhosphorIconsStyle.regular);
        break;
      case 'I23':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.videoCamera(PhosphorIconsStyle.regular);
        break;
      case 'I24':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.ticket(PhosphorIconsStyle.regular);
        break;
      case 'I25':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.globe(PhosphorIconsStyle.regular);
        break;
      case 'I26':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.calendarBlank(PhosphorIconsStyle.regular);
        break;
      case 'I27':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.penNib(PhosphorIconsStyle.regular);
        break;
      case 'I28':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.deviceMobile(PhosphorIconsStyle.regular);
        break;
      case 'I29':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.firstAidKit(PhosphorIconsStyle.regular);
        break;
      case 'I30':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.plugCharging(PhosphorIconsStyle.regular);
        break;
      case 'I31':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.trophy(PhosphorIconsStyle.regular);
        break;
      case 'I32':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.treePalm(PhosphorIconsStyle.regular);
        break;
      case 'I33':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.camera(PhosphorIconsStyle.regular);
        break;
      case 'I34':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.bugBeetle(PhosphorIconsStyle.regular);
        break;
      case 'I35':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.dress(PhosphorIconsStyle.regular);
        break;
      case 'I36':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.armchair(PhosphorIconsStyle.regular);
        break;
      case 'I37':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.trash(PhosphorIconsStyle.regular);
        break;
      case 'I38':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.tag(PhosphorIconsStyle.regular);
        break;
      case 'I39':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.currencyDollar(PhosphorIconsStyle.regular);
        break;
      case 'I40':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.handCoins(PhosphorIconsStyle.regular);
        break;
      case 'I41':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.shoppingBag(PhosphorIconsStyle.regular);
        break;
      case 'I42':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.phoneCall(PhosphorIconsStyle.regular);
        break;
      case 'I43':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.notePencil(PhosphorIconsStyle.regular);
        break;
      case 'I44':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.coins(PhosphorIconsStyle.regular);
        break;
      case 'I45':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.paintBrush(PhosphorIconsStyle.regular);
        break;
      case 'I46':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.bus(PhosphorIconsStyle.regular);
        break;
      case 'I47':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.gameController(PhosphorIconsStyle.regular);
        break;
      case 'I48':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData =
            PhosphorIcons.currencyCircleDollar(PhosphorIconsStyle.regular);
        break;
      case 'I49':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.package(PhosphorIconsStyle.regular);
        break;
      case 'I50':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.jeep(PhosphorIconsStyle.regular);
        break;
      case 'I51':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.laptop(PhosphorIconsStyle.regular);
        break;
      case 'I52':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.lego(PhosphorIconsStyle.regular);
        break;
      case 'I53':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.motorcycle(PhosphorIconsStyle.regular);
        break;
      case 'I54':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.popcorn(PhosphorIconsStyle.regular);
        break;
      case 'I55':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.spotifyLogo(PhosphorIconsStyle.regular);
        break;
      case 'I56':
        backgroundColor;
        IconColor = AppTheme.dynamicIconColor(backgroundColor);
        iconData = PhosphorIcons.taxi(PhosphorIconsStyle.regular);
        break;
      default:
        backgroundColor = AppTheme.primaryColor;
        IconColor = Colors.white;
        iconData = PhosphorIcons.wallet(PhosphorIconsStyle.regular);
    }

    return Container(
      padding: const EdgeInsets.all(8),
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
