import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoftcares_interview/services/api_service.dart';
import 'package:zoftcares_interview/utils/dynamic_sizing.dart';

class HomeScreen extends ConsumerWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        title: const Text("Posts List"),
        centerTitle: true,
      ),
      body: ref.watch(postsProvider(token)).when(
            data: (data) {
              if (data == null) {
                return const Center(
                  child: Text("Posts List is empty!!!"),
                );
              } else {
                return Expanded(
                    child: ListView.separated(
                        padding: EdgeInsets.symmetric(
                            horizontal: R.rw(16, context),
                            vertical: R.rh(8, context)),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: const Color(0xffF1F1F1),
                                borderRadius:
                                    BorderRadius.circular(R.rw(12, context))),
                            child: Column(
                              children: [
                                Text(
                                  data.data![index].title.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: R.rw(16, context)),
                                ),
                                SizedBox(
                                  height: R.rh(8, context),
                                ),
                                Text(data.data![index].body.toString()),
                                SizedBox(
                                  height: R.rh(8, context),
                                ),
                                Text(
                                  data.data![index].image.toString(),
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                              height: R.rh(10, context),
                            ),
                        itemCount: data.data!.length));
              }
            },
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
