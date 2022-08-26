import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/app/pages/home/home_controller.dart';
import 'package:foxbit_hiring_test_template/domain/entities/price_entity.dart';

class HomePage extends View {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends ViewState<HomePage, HomeController> {
  HomePageState() : super(HomeController());

  @override
  Widget get view {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: globalKey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * .025),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Cotação',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: size.height * .025),
          SizedBox(
            height: size.height * .90,
            child: ControlledWidgetBuilder<HomeController>(
                builder: (context, controller) {
              if (controller.list.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.separated(
                  itemBuilder: (context, index) =>
                      buildItem(controller.list[index]),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8,
                  ),
                  itemCount: controller.list.length,
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Widget buildItem(PriceEntity e) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: constraints.maxWidth,
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 40,
              offset: const Offset(0, 12), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth * .28,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Image.asset(
                      e.pathImage,
                      height: 50,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Text('${e.name[0]}${e.name[1]}');
                      },
                    ),
                  ),
                  const SizedBox(width: 4),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        e.type,
                        style: const TextStyle(
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth * .18,
              ),
              child: Text(
                e.appreciation.toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(
                      e.appreciation.isNegative ? 0xFFc22f33 : 0xFF2d8a44,
                    )),
              ),
            ),
            Expanded(
              child: Text(
                'R\$ ${e.currentValue.toStringAsFixed(2)}',
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
