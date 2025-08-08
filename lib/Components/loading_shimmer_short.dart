import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmershort extends StatefulWidget {
  // final bool isLoading;
  // LoadingShimmer({required this.isLoading});
  @override
  _LoadingShimmershortState createState() => _LoadingShimmershortState();
}

class _LoadingShimmershortState extends State<LoadingShimmershort> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        //padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                  baseColor: Color.fromARGB(255, 170, 170, 170),
                  highlightColor: Colors.grey[300]!,
                  enabled: true,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.10,
                    height: 30.0,
                    color: Colors.white,
                  )),
              SizedBox(
                width: 10,
              ),
              Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  enabled: true,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.70,
                    height: 30.0,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
