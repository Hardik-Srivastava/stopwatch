import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'dart:async';
import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../controllers/home_controller.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

// ignore: must_be_immutable
class HomeView extends GetView<HomeController> {
 HomeView({Key? key}) : super(key: key);
  HomeController homeController=Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 30, 104),
          title: const Text('Mindful Meal Timer'),
          leading: IconButton(
              onPressed: () {

              },
              icon: const Icon(
                Icons.arrow_back_sharp,
                color: Colors.white,
              ),
            )

        ),
        
      backgroundColor: const Color.fromARGB(255, 17, 30, 104),
      body: Center(
          child: CircularCountdownTimer(
            duration: 5, // Duration of the countdown in minutes
            countdownColor: Colors.red,
            countdownTextColor: Colors.white,
          ),
        ),
    );
  }
}


class CountdownPainter extends CustomPainter {
  final int duration;
  final int currentTime;
  final Color countdownColor;

  CountdownPainter({
    required this.duration,
    required this.currentTime,
    required this.countdownColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width;
  

    // Draw clock needles
    Paint needlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    for (int i = 0; i < 60; i++) {
      double angle = i * 6 * (pi / 180); // Each minute mark is 6 degrees apart
      double startX = radius + (radius - 100) * cos(angle);
      double startY = radius + (radius - 100) * sin(angle);
      double endX = radius + (radius-80) * cos(angle);
      double endY = radius + (radius-80) * sin(angle);

      if (i % 5 == 0) {
        
        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), needlePaint);
      } else {
        
        canvas.drawCircle(Offset(startX, startY), 2, needlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}



class CircularCountdownTimer extends StatefulWidget {
  final int duration;
  final Color countdownColor;
  final Color countdownTextColor;

  CircularCountdownTimer({
    required this.duration,
    required this.countdownColor,
    required this.countdownTextColor,
  });

  @override
  _CircularCountdownTimerState createState() => _CircularCountdownTimerState();
}

class _CircularCountdownTimerState extends State<CircularCountdownTimer> {

 final List<Widget> _splash = [
   CustomPage(
      initialText: 'Time to eat mindfully',
      finalText: 'It\'s simple: eat slowly for ten minutes, rest for five, then finish your meal',
      duration: 30,
      initialpage: true,
    ),
    CustomPage(
      initialText: 'Nom Nom',
      finalText: 'You have 10 minutes to eat before the pause. Focus on eating slowly',
      duration: 90,
 
    ),
    CustomPage(
      initialText: 'Break Time',
      finalText: 'Take a 5-minutes break to check-in on your level of fulness',
      duration: 30
 
    ),
    CustomPage(
      initialText: 'Finish your meal',
      finalText: 'You can eat full until you feel full                                               ',
      duration: 30,
 
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return  GetBuilder<HomeController>(
      builder: (controller) {
        return Column(
            children: [
              const SizedBox(height: 20,),
              Flexible(
              child: SmoothPageIndicator(
              controller: controller.pagecontroller.value,
              count: 4,
              effect: const WormEffect(
                  activeDotColor: Colors.white, dotColor: Colors.black38),
            ),
          ),
              SizedBox(
                height: Get.height * .8,
                child: PageView(
                  onPageChanged: (value) {
                    controller.page.value = value;
                  },
                  controller: controller.pagecontroller.value,
                  children: _splash,
                ),
              ),
             
            ],
          );
      }
    );
    }


}

// ignore: must_be_immutable
class CustomPage extends StatefulWidget {
   CustomPage({super.key, required this.initialText,required  this.finalText, required  this.duration, this.initialpage=false});
  String initialText;
  String finalText;
  int duration;
  bool initialpage;
  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
    late Timer _timer;
  int _currentTime = 0;
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _currentTime = widget.duration * 60;
    _startTimer();
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_currentTime < 1) {
          timer.cancel();
        } else {
          _currentTime--;
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
    
      builder: (controller) {
        return Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
      
          const SizedBox(height: 50,),
          
                 Text(widget.initialText,style: const TextStyle(color: Colors.white,fontSize: 28),),
                const SizedBox(height: 20,),
                Text(widget.finalText,style: const TextStyle(color: Colors.grey,fontSize: 20),textAlign: TextAlign.center,),
               const SizedBox(height: 100,),
               
                SizedBox(
                  width: 200,
                  height: 200,
                  
                  child: Stack(
                    children: [
                  
                     Center(
                       child: CircularCountDownTimer(
                          duration: widget.duration, // Duration in seconds
                          initialDuration: 0,
                          controller: controller.countDownController,
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 2,
                          ringColor: Colors.grey,
                          ringGradient: null,
                          fillColor: Colors.blueAccent,
                          fillGradient: null,
                          backgroundColor: Colors.white,
                          strokeWidth: 20.0,
                          strokeCap: StrokeCap.round,
                          textStyle: const TextStyle(
                              fontSize: 33.0, color: Colors.black, fontWeight: FontWeight.bold),
                          isReverse: true,
                          isReverseAnimation: true,
                          isTimerTextShown: true,
                          autoStart: false,
                          onStart: () async {
                            
                            controller.audioPlayer=AudioPlayer(
                
                              );
                              await controller.audioPlayer!.setVolume(double.maxFinite);
                               await controller.audioPlayer!.setSpeed(0.3);
                               
                              await controller.audioPlayer!.setAsset('assets/audio/countdown_tick.mp3');
                          },
                          onComplete: () {
                            
                            controller.started=false;
                            controller.audioTimer!.cancel();
                            controller.audioPlayer!.setLoopMode(LoopMode.off);
                            controller.audioPlayer!.dispose();
                            controller.update();
                            
                            controller.navigateToPage(controller.page.value);
                          },
                        ),
                     ),
                      
                    
                      Center(
                        child: CustomPaint(
                          painter: CountdownPainter(
                            duration: widget.duration * 60,
                            currentTime: _currentTime,
                            countdownColor: Colors.redAccent.shade400,
                          ),
                        ),
                      ),
                    Center(
                       child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                         children: [
                          SizedBox(height: 50,),
                           Text(
                                           (((controller.countDownController!.getTime()!="")?controller.parseTimeStringToSeconds(controller.countDownController!.getTime()??'0'):0)<60)?'seconds remaining':'minutes remaining',
                                           style: TextStyle(
                                             fontSize: 14.0,
                                             color: Colors.redAccent.shade200,
                                           ),
                                         ),
                         ],
                       ),
                     ),
                    ],
                  ),
                ),
        
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                     
        Padding(
            padding: const EdgeInsets.only(top:20.0,left: 20,right: 20.0,bottom: 5.0),
            child:   LiteRollingSwitch(
                //initial value
            value: controller.isSoundOn,
                textOn: 'ON',
                textOff: 'OFF',
                colorOn: Colors.greenAccent,
                colorOff: Colors.redAccent,
                iconOn: Icons.done,
                iconOff: Icons.remove_circle_outline,
                textSize: 16.0,
                onTap: () {
              
                },
                onDoubleTap: (){
            
                },
                onSwipe: (){
            
                },
                onChanged:(bool value){
             controller.isSoundOn = value;
                              if(controller.isSoundOn){
                                controller.audioPlayer!.setVolume(double.maxFinite);
                              }else{
                                controller.audioPlayer!.setVolume(double.minPositive);
                              }
                              controller.update();
                } ,
            ),
        ),
                 
                       Text('Sound ${(controller.isSoundOn)?'On':'Off'}:', style: TextStyle(color: Colors.white),),
                       
                    ],
                  ),
                ),
                
              ],
            ),
            Positioned(
              bottom: 0,
              left: 16,
              right: 16,
              child: Center(
                child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: (!controller.started)?ElevatedButton(
                   style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 225, 221, 221),
                padding: EdgeInsets.all(16.0), // Add sufficient padding
                minimumSize: Size(double.infinity, 48.0), // Set minimum size to take the entire width
                          ),
                          onPressed: (){
                            if(widget.initialpage){
                                    controller.navigateToPage(controller.page.value); 
                            }else{
                  controller.countDownController!.start();
                  
                  controller.startAudioTimer();
                  controller.started=true;
                  controller.update();
                            }
                }, child: const Text('Start',style: TextStyle(color: Colors.black87),)):Column(
                  children: [
                    (!controller.paused)?ElevatedButton(
                       style: ElevatedButton.styleFrom(
                           backgroundColor: const Color.fromARGB(255, 225, 221, 221),
                    padding: const EdgeInsets.all(16.0), // Add sufficient padding
                    minimumSize: const Size(double.infinity, 48.0), // Set minimum size to take the entire width
                          ),
                          onPressed: (){
                      controller.countDownController!.pause();
                      controller.audioTimer!.cancel();
                      controller.paused=true;
                      
                      controller.update();
                    }, child: const Text('Pause',style: TextStyle(color: Colors.black87))):ElevatedButton(
                       style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 225, 221, 221),
                    padding:const EdgeInsets.all(16.0), // Add sufficient padding
                    minimumSize: const Size(double.infinity, 48.0), // Set minimum size to take the entire width
                          ),onPressed: (){
                      controller.countDownController!.resume();
                      controller.startAudioTimer();
                      controller.paused=false;
                      controller.audioPlayer!.setLoopMode(LoopMode.one);
                      controller.update();
                    }, child: const Text('Resume',style: TextStyle(color: Colors.black87))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent, 
                              elevation: 0.0, 
                              padding: const EdgeInsets.all(16.0),
                              // Add sufficient padding
                    minimumSize: const Size(double.infinity, 48.0),
                               side: const BorderSide(color: Colors.white54, width: 2.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                
                              ),
                            ),
                        onPressed: (){
                                      controller.audioPlayer!.setLoopMode(LoopMode.off);
                          controller.audioPlayer!.dispose();
                          controller.audioTimer!.cancel();
                          controller.countDownController!.reset();
                          controller.paused=false;
                          controller.started=false;
                          
                          controller.update();
                      }, child: const Text("LET'S STOP I'M FULL NOW",style: TextStyle(color: Colors.white54,fontSize: 18),)),
                    )
                  ],
                ),
                          ),
              ))
          ],
        );
      }
    );

  }
}