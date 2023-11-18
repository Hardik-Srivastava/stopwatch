import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
class HomeController extends GetxController {
  //TODO: Implement HomeController

  CountDownController? countDownController;
  final count = 0.obs;
  bool started=false;
  bool paused=false;
  bool isCompleted=false;
  bool isSoundOn=true;
  AudioPlayer? audioPlayer;
  Timer? audioTimer;
  @override
  void onInit() {
    super.onInit();
    countDownController= CountDownController();
    isSoundOn=true;
    started=false;
    paused=false;
    isCompleted=false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    
    super.onClose();
  }

  var page = 0.obs;
  Rx<PageController> pagecontroller = PageController(initialPage: 0).obs;
  navigateToPage(int index) {
    if (index != 3){
    pagecontroller.value.animateToPage(index + 1,
            duration: const Duration(milliseconds: 400), curve: Curves.easeInQuad);
    }
    
  }
  int parseTimeStringToSeconds(String timeString) {
  List<String> timeParts = timeString.split(':');

  if (timeParts.length == 2) {

    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    return hours * 60 + minutes;
  } else if (timeParts.length == 1) {
    
    int minutes = int.parse(timeParts[0]);
    return minutes ;
  } else {
    throw ArgumentError('Invalid time string format');
  }
}
  void increment() => count.value++;

  void startAudioTimer() {
  if(audioTimer!=null)audioTimer?.cancel();

  audioTimer = Timer.periodic(Duration(seconds: 1), (timer) async {

    
    int remainingTime = parseTimeStringToSeconds(countDownController!.getTime()??"0");
    
    if (remainingTime > 0 && remainingTime <= 5&&isSoundOn) {
     audioPlayer!.setLoopMode(LoopMode.one);
    
      await playAudio();
    }else if(remainingTime==0){
      audioPlayer!.setLoopMode(LoopMode.off);
    }
  });
}
  Future<void> playAudio() async {
    print("Play audio");
  await audioPlayer!.play(
    
  );
 
 
  
 
}

}
