import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
              builder: (context) => ProjectPage(pID: docID, i: i)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 4,
              blurRadius: 10,
              offset: const Offset(5,5), // changes position of shadow
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.0),
              spreadRadius: 0,
              blurRadius: 0,
              offset: const Offset(-0,-0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(
              width: double.infinity,
              fit: BoxFit.cover,
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
                      Expanded(
                        child: Text(
                          text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
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
      ),
    );
  }
}
