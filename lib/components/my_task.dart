import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../pages/project_page.dart';
import '../pages/task_page.dart';

class MyTask extends StatelessWidget {
  final String ptitle;
  final String text;
  final String status;
  final String tdate;
  final String pID;
  final String tID;

  const MyTask({
    super.key,
    required this.ptitle,
    required this.text,
    required this.status,
    required this.tdate,
    required this.pID,
    required this.tID,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TaskPage(pID: pID, tID: tID, titulo: ptitle,)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            color:
            Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow:
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: .05,
                blurRadius: 4,
                offset: const Offset(5,5), // changes position of shadow
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.0),
                spreadRadius: .05,
                blurRadius: 3,
                offset: const Offset(-0,-0), // changes position of shadow
              ),
            ]
          ),
          padding: const EdgeInsets.symmetric(
              vertical: 8, horizontal: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.list_alt,
                    size: 60,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  Container(
                    width: 73,
                    padding:
                    const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(
                          0, 56, 255, 10),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Expanded(
                      child: Text(
                        status,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 212, 212, .5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 6, horizontal: 15),
                    child: Text(
                      tdate,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
