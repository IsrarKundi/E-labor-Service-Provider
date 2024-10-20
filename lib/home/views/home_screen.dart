import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../helper/customcard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  var height, width;
  String searchQuery = '';

  final List<Map<String, dynamic>> category = [
    {'title': 'Plumber', 'subtitle': 'Experienced plumber for all your plumbing needs', 'icon': Icons.plumbing},
    {'title': 'Meson', 'subtitle': 'Professional mesons for building and renovation', 'icon': Icons.construction},
    {'title': 'Labour', 'subtitle': 'Skilled labourers for construction and maintenance', 'icon': Icons.pan_tool},
    {'title': 'Carpenter', 'subtitle': 'Expert carpenters for furniture and woodwork', 'icon': Icons.carpenter},
    {'title': 'Electrician', 'subtitle': 'Certified electricians for electrical installations and repairs', 'icon': Icons.electric_bolt},
    {'title': 'Painter', 'subtitle': 'Expert painter to pain your walls', 'icon': Icons.format_paint},
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color :Color(0xffffa45b), ),
        child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 22, right: 22),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Center(
                    child:
                      Image.asset('images/logo.png', height: 33,),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location', style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16
                        ),
                        ),
                        Text('Saddar, Peshawar', style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        ),
                      ],
                    ),
                    // SizedBox(width: 130,),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 30.0, // Adjust the radius as needed
                          backgroundImage: AssetImage('images/israr2.jpeg',),
                          backgroundColor: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 22, bottom: 22),
                  child: Material(
                    color: Color(0xfff2f2f2),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(10),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search here...',
                         // Ensure no conflicting styles
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),

              ],

            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                height: height * 0.6247,
                width: width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 26),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hire a Service',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Choose the service you need',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  // Handle button press action here
                                },
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                label: Text('View All', style: TextStyle(color: Colors.black)),
                                style: ButtonStyle(
                                  side: MaterialStateProperty.all(BorderSide(color: Colors.black, width: 2.0)),
                                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                  padding: MaterialStateProperty.all(EdgeInsets.only(left: 4, right: 8, top: 0, bottom: 0)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5), // Add some spacing between the button and the GridView
                      Expanded(
                        child: GridView.builder(
                          itemCount: category.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            return CustomCard(
                              title: category[index]['title'],
                              subtitle: category[index]['subtitle'],
                              icon: category[index]['icon'],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
        ),
      ),




    );
  }
}
