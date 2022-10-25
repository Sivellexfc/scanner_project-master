import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchFire extends StatefulWidget {

  const SearchFire({super.key,required this.name});

  final String name;
  @override
  State<SearchFire> createState() => _SearchFireState();
}

class _SearchFireState extends State<SearchFire> {

  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                      if (widget.name.isEmpty) {}
                      if (data['name']
                          .toString()
                          .toLowerCase()
                          .startsWith(widget.name.toLowerCase())) {
                        return ListTile(
                          title: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: Colors.lightBlueAccent.shade200,
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              data['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          subtitle: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 220, 226, 228),
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              'Kosher : ' +
                                  data['Kosher'].toString() +
                                  '\n' +
                                  'Free Form : ' +
                                  data['Free Form'].toString() +
                                  '\n' +
                                  'Halal : ' +
                                  data['Halal'].toString() +
                                  '\n' +
                                  'Vegan : ' +
                                  data['Vegan'].toString() +
                                  '\n' +
                                  'Vegeterian : ' +
                                  data['Vegeterian'].toString() +
                                  '\n' +
                                  'Helal : ' +
                                  data['Helal'].toString() +
                                  '\n',
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        );
                      }
                      return Container();
                    });
          },
        )
      ],
    );
  }
}
