import 'package:flutter/material.dart';


class OfferPriceScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    late String newTask;
    return Padding(
      padding: const EdgeInsets.only(top: 5, right: 30, left: 30, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Offer Your Price', style: TextStyle(
            color: Color(0xfff67322),
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),
          ),
          TextField(
            autofocus: true,
            textAlign: TextAlign.center,
            cursorColor: Color(0xfff67322), // Set the cursor color
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xfff67322), width: 2.0), // Bottom border color and width when not focused
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xfff67322), width: 4.0), // Bottom border color and width when focused
              ),
            ),
            onChanged: (newValue){
              newTask = newValue;
            },
          ),
          SizedBox(height: 26,),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xfff67322),
              minimumSize: Size(double.infinity, 50), // Set the height if needed
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Text('Offer', style: TextStyle(
                color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),),
          )
        ],
      ),
    );
  }
}