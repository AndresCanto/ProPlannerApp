import 'package:flutter/material.dart';

import '../pages/project_page.dart';

class MyCard extends StatelessWidget {
  final int i;
  final String text;
  final String dueDate;
  final int progress;
  final String docID;

  const MyCard({
    super.key,
    required this.i,
    required this.text,
    required this.dueDate,
    required this.progress,
    required this.docID,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProjectPage(docID: docID, i: i)),
        );
      },
      child: Column(
        children: [
          Image.asset(
            'lib/images/project$i.png',
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              children: [
                 Row(
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 7),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 225, 225, 10),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        dueDate,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 7),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 56, 255, 10),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "$progress%",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
