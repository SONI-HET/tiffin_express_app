import 'package:flutter/material.dart';

class FoodSearchBox extends StatelessWidget {
  const FoodSearchBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(
                  color: Colors.black, fontSize: 16, fontFamily: 'Roboto'),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Which Tiffin Do You Want?',
                  suffixIcon: const Icon(Icons.search,
                      color: Color.fromARGB(255, 13, 50, 172)),
                  contentPadding:
                      const EdgeInsets.only(left: 20.0, bottom: 5.0, top: 12.5),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: IconButton(
              icon: Icon(Icons.menu, color: Color.fromARGB(255, 13, 50, 172)),
              onPressed: () {
                Navigator.pushNamed(context, '/filters');
              },
            ),
          )
        ],
      ),
    );
  }
}
