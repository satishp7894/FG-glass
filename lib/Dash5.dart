import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Dash5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Pinned.fromPins(
          Pin(start: 0.0, end: 0.0),
          Pin(size: 135.1, middle: 0.5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 752.0,
              height: 135.0,
              child: Stack(
                children: <Widget>[
                  Pinned.fromPins(
                    Pin(startFraction: 0.0003, endFraction: 0.8453),
                    Pin(startFraction: 0.0, endFraction: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: const Color(0xfff3f3f3),
                      ),
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(startFraction: 0.1694, endFraction: 0.6761),
                    Pin(startFraction: 0.0, endFraction: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: const Color(0xfff3f3f3),
                      ),
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(startFraction: 0.3396, endFraction: 0.506),
                    Pin(startFraction: 0.0, endFraction: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: const Color(0xfff3f3f3),
                      ),
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(startFraction: 0.5084, endFraction: 0.3371),
                    Pin(startFraction: 0.0, endFraction: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: const Color(0xfff3f3f3),
                      ),
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(startFraction: 0.6773, endFraction: 0.1683),
                    Pin(startFraction: 0.0, endFraction: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: const Color(0xfff3f3f3),
                      ),
                    ),
                  ),
                  /*Pinned.fromPins(
                    Pin(startFraction: 0.8461, endFraction: -0.0005),
                    Pin(startFraction: 0.0, endFraction: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: const Color(0xfff3f3f3),
                      ),
                    ),
                  ),*/
                  Pinned.fromPins(
                    Pin(startFraction: 0.0455, endFraction: 0.8909),
                    Pin(startFraction: 0.2023, endFraction: 0.4436),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Image.asset('assets/images/dash5car1.png'),
                        )
                      ],
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(startFraction: 0.2143, endFraction: 0.7221),
                    Pin(startFraction: 0.2023, endFraction: 0.4436),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Image.asset('assets/images/dash5car2.png'),
                        )
                      ],
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(startFraction: 0.3848, endFraction: 0.5516),
                    Pin(startFraction: 0.2023, endFraction: 0.4436),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Image.asset('assets/images/dash5car3.png'),
                        )

                      ],
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(startFraction: 0.0309, endFraction: 0.8721),
                    Pin(startFraction: 0.7156, endFraction: 0.1142),
                    child: Text(
                      'FACADES',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: const Color(0xff52509d),
                        fontWeight: FontWeight.w600,
                        height: 1.375,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(startFraction: 0.1987, endFraction: 0.7069),
                    Pin(startFraction: 0.7156, endFraction: 0.1142),
                    child: Text(
                      'INTERIOR',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: const Color(0xff8a4a98),
                        fontWeight: FontWeight.w600,
                        height: 1.375,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(startFraction: 0.3662, endFraction: 0.5328),
                    Pin(startFraction: 0.7156, endFraction: 0.1142),
                    child: Text(
                      'SECURITY',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: const Color(0xff3aac4e),
                        fontWeight: FontWeight.w600,
                        height: 1.375,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(startFraction: 0.5231, endFraction: 0.2533),
                    Pin(startFraction: 0.7156, endFraction: 0.1142),
                    child: Text(
                      'FIRE SAFETY',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: const Color(0xfff6aa17),
                        fontWeight: FontWeight.w600,
                        height: 1.375,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(startFraction: 0.7012, endFraction: 0.1911),
                    Pin(startFraction: 0.7156, endFraction: 0.1142),
                    child: Text(
                      'CREATION',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: const Color(0xffe92f59),
                        fontWeight: FontWeight.w600,
                        height: 1.375,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  /*Pinned.fromPins(
                    Pin(startFraction: 0.878, endFraction: 0.0303),
                    Pin(startFraction: 0.7156, endFraction: 0.1142),
                    child: Text(
                      'GLAZING',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: const Color(0xffeb4f38),
                        fontWeight: FontWeight.w600,
                        height: 1.375,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    ),
                  ),*/
                  Pinned.fromPins(
                    Pin(startFraction: 0.5536, endFraction: 0.3828),
                    Pin(startFraction: 0.2023, endFraction: 0.4436),
                    child:
                        // Adobe XD layer: '24 oct revised-01' (group)
                        Stack(
                      children: <Widget>[
                        Container(
                          child: Image.asset('assets/images/dash5car4.png'),
                        )

                      ],
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(startFraction: 0.7225, endFraction: 0.2139),
                    Pin(startFraction: 0.2019, endFraction: 0.444),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Image.asset('assets/images/dash5car5.png'),
                        )

                      ],
                    ),
                  ),
                  /*Pinned.fromPins(
                    Pin(startFraction: 0.8913, endFraction: 0.0451),
                    Pin(startFraction: 0.2023, endFraction: 0.4436),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Image.asset('assets/images/dash5car6.png'),
                        )
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

const String _svg_is2qj4 =
    '<svg viewBox="0.0 0.0 47.8 47.8" ><path  d="M 0 23.9246826171875 C 0 37.13792419433594 10.71144580841064 47.849365234375 23.92468452453613 47.849365234375 C 37.13792419433594 47.849365234375 47.849365234375 37.13792419433594 47.849365234375 23.92467880249023 C 47.849365234375 10.71144485473633 37.13792419433594 0 23.92467880249023 0 C 10.71144485473633 0 -2.048836677204235e-06 10.71144866943359 0 23.92468643188477" fill="none" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_56uaog =
    '<svg viewBox="15.0 8.9 17.8 30.1" ><path transform="translate(-97.43, -56.81)" d="M 122.3561172485352 71.11302185058594 L 130.0491333007812 75.29210662841797 L 130.1952209472656 75.37364959716797 L 130.1952209472656 88.86811065673828 L 130.0153198242188 88.93762969970703 L 122.3236618041992 91.92420959472656 L 121.9381332397461 92.07660675048828 L 121.9381332397461 70.88574981689453 L 122.3561172485352 71.11302185058594 Z M 112.8220443725586 65.92860412597656 L 120.5123519897461 70.10768890380859 L 120.659797668457 70.19057464599609 L 120.659797668457 92.56725311279297 L 120.4785232543945 92.63809967041016 L 112.7882308959961 95.62468719482422 L 112.3999862670898 95.77442932128906 L 112.3999862670898 65.69999694824219 L 112.8220443725586 65.92860412597656 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_yo02l5 =
    '<svg viewBox="0.0 0.0 47.8 47.9" ><path transform="translate(0.0, 0.01)" d="M 0 23.92040824890137 C 0 37.13420104980469 10.71226501464844 47.84649658203125 23.92334175109863 47.84649658203125 C 37.13732147216797 47.84716796875 47.849365234375 37.13509368896484 47.849365234375 23.92107772827148 C 47.849365234375 10.70706653594971 37.1373176574707 -0.005004882346838713 23.92333984375 -0.005004882346838713 C 10.71226501464844 -0.004332862328737974 0 10.70661449432373 0 23.92040824890137" fill="none" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_rtkgdm =
    '<svg viewBox="12.5 10.1 22.8 27.7" ><path transform="translate(-80.65, -65.13)" d="M 115.9505996704102 102.9171447753906 L 115.9505996704102 99.09251403808594 L 99.47930145263672 99.09251403808594 L 99.47930145263672 79.39739990234375 L 115.9505996704102 79.39739990234375 L 115.9505996704102 75.19999694824219 L 93.19998931884766 75.19999694824219 L 93.19998931884766 102.9171447753906 L 115.9505996704102 102.9171447753906 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_fw9dae =
    '<svg viewBox="22.0 17.3 13.4 13.4" ><path transform="translate(-141.43, -111.07)" d="M 172.8959045410156 141.6710662841797 L 176.7550659179688 141.6710662841797 L 176.7550659179688 128.3199920654297 L 172.8959045410156 128.3199920654297 L 163.3999938964844 128.3199920654297 L 163.3999938964844 141.6710662841797 L 172.8959045410156 141.6710662841797 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_ke0ve1 =
    '<svg viewBox="0.0 0.0 47.8 47.8" ><path transform="translate(0.0, 0.0)" d="M 0 23.92462158203125 C 0 37.13782501220703 10.71141815185547 47.8492431640625 23.92462539672852 47.8492431640625 C 37.13782501220703 47.8492431640625 47.8492431640625 37.13782501220703 47.8492431640625 23.92461967468262 C 47.8492431640625 10.71141624450684 37.13782501220703 -1.895238523411114e-12 23.92461967468262 -1.895238523411114e-12 C 10.71306991577148 -2.048833039225428e-06 0.001485402579419315 10.71037864685059 0 23.92327499389648" fill="none" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_ae9qdj =
    '<svg viewBox="9.3 14.0 6.2 22.8" ><path transform="translate(-59.57, -87.35)" d="M 68.86000061035156 121.3733367919922 L 75.10325622558594 124.1236114501953 L 75.10325622558594 105.1236572265625 L 68.86000061035156 101.3200073242188 L 68.86000061035156 121.3733367919922 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_m69bh0 =
    '<svg viewBox="18.0 14.6 20.4 26.3" ><path transform="translate(-113.47, -86.75)" d="M 144.8097076416016 105.7036590576172 L 137.6005401611328 101.3099975585938 L 131.5099945068359 105.0992889404297 L 131.5099945068359 124.9725036621094 L 137.6005401611328 127.6549072265625 L 151.8700866699219 121.3646545410156 L 151.8700866699219 101.3099975585938 L 144.8097076416016 105.7036590576172 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_s3w10l =
    '<svg viewBox="0.0 0.0 47.8 47.8" ><path transform="translate(0.0, 0.0)" d="M 0 23.92462539672852 C 0 37.13783264160156 10.71142101287842 47.84925079345703 23.92462921142578 47.84925079345703 C 37.13783264160156 47.84925079345703 47.84925079345703 37.13783264160156 47.84925079345703 23.92462348937988 C 47.84925079345703 10.7114200592041 37.13783264160156 -1.895238523411114e-12 23.92462348937988 -1.895238523411114e-12 C 10.71307277679443 -2.048833721346455e-06 0.00148540292866528 10.71038246154785 0 23.92328071594238" fill="none" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_gp6fyj =
    '<svg viewBox="12.3 6.4 17.9 35.4" ><path transform="translate(-79.2, -41.4)" d="M 99.5767822265625 47.81999969482422 C 99.5767822265625 47.81999969482422 104.0158233642578 51.80923461914062 94.60870361328125 62.99948883056641 C 85.20158386230469 74.18972778320312 99.75267028808594 83.42632293701172 102.7724456787109 83.24638366699219 C 102.7724456787109 83.24638366699219 101.5304260253906 77.91712188720703 105.9694671630859 71.88025665283203 C 110.4085083007812 65.84336853027344 112.5407562255859 54.66252136230469 99.5767822265625 47.81999969482422 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_cijr77 =
    '<svg viewBox="25.6 20.8 10.0 21.1" ><path transform="translate(-165.13, -134.03)" d="M 197.4039001464844 154.8200225830078 C 197.9987487792969 159.2818603515625 196.3445129394531 163.6551208496094 194.0968017578125 166.711181640625 C 191.4381713867188 170.3271179199219 190.8178405761719 173.6866149902344 190.739990234375 175.800048828125 L 190.825927734375 175.8806304931641 C 193.2226867675781 174.0196228027344 195.7214965820312 173.2985534667969 197.9289245605469 170.8172149658203 C 203.8167724609375 164.2002716064453 198.6687622070312 156.5131988525391 197.3918151855469 154.8200225830078 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_7ga2v0 =
    '<svg viewBox="0.0 0.0 47.8 47.8" ><path transform="translate(0.0, 0.0)" d="M 0 23.92462158203125 C 0 37.1378288269043 10.71141815185547 47.8492431640625 23.92462348937988 47.8492431640625 C 37.1378288269043 47.8492431640625 47.8492431640625 37.1378288269043 47.8492431640625 23.92461967468262 C 47.8492431640625 10.71141719818115 37.1378288269043 -1.895238740251548e-12 23.92461967468262 -1.895238740251548e-12 C 10.71306991577148 -2.048833266599104e-06 0.001485402695834637 10.71038055419922 0 23.92327499389648" fill="none" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_h1fxap =
    '<svg viewBox="10.1 20.3 17.2 14.9" ><path transform="translate(-64.81, -131.06)" d="M 88.30599975585938 151.9057922363281 C 85.22445678710938 150.5254669189453 81.33460235595703 152.0158843994141 79.94890594482422 155.0987854003906 C 77.9844970703125 159.4666442871094 79.91802215576172 162.7966156005859 74.85999298095703 165.9654235839844 C 74.85999298095703 165.9654235839844 80.23892974853516 167.4128723144531 86.94448852539062 164.5139465332031 C 89.09284210205078 163.5834350585938 90.66785430908203 162.114501953125 91.49228668212891 160.2655792236328 C 92.17921447753906 158.7345733642578 92.22938537597656 156.9933013916016 91.63175201416016 155.4253082275391 C 91.03411865234375 153.8572998046875 89.83769226074219 152.5911712646484 88.30599975585938 151.9057922363281 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_x5u6vz =
    '<svg viewBox="23.6 17.3 6.7 6.7" ><path transform="translate(-152.25, -111.45)" d="M 175.8600158691406 131.4691619873047 C 176.7860107421875 131.7686767578125 177.6302185058594 132.2783203125 178.3265686035156 132.9582366943359 C 179.0071716308594 133.6469573974609 179.5251159667969 134.4791564941406 179.842529296875 135.3939208984375 L 182.5548095703125 132.684326171875 L 178.5991516113281 128.7299957275391 L 175.8600158691406 131.4691619873047 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_kfbo4k =
    '<svg viewBox="26.1 4.2 17.1 17.0" ><path transform="translate(-168.2, -27.27)" d="M 199.6555023193359 48.48543548583984 L 211.3586578369141 36.77689743041992 C 209.8405609130859 34.7318229675293 207.9976348876953 32.94925308227539 205.9031829833984 31.5 L 194.2899932861328 43.11454391479492 L 199.6555023193359 48.48543548583984 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_2pw6s7 =
    '<svg viewBox="0.0 0.0 47.8 47.8" ><path  d="M 0 23.92459869384766 C 0 37.13796615600586 10.71168231964111 47.84944534301758 23.92504692077637 47.84919738769531 C 37.13796615600586 47.84919738769531 47.84944534301758 37.13751602172852 47.84919738769531 23.92415046691895 C 47.84919738769531 10.7112340927124 37.13751602172852 -0.0002470301988068968 23.92415046691895 8.781542533142783e-07 C 10.71222591400146 8.781542533142783e-07 0 10.71222686767578 0 23.92459869384766" fill="none" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_ijd34h =
    '<svg viewBox="11.4 11.4 25.0 25.0" ><path transform="translate(-72.52, -72.54)" d="M 83.94998931884766 83.97000122070312 L 89.90140533447266 83.97000122070312 L 89.90140533447266 103.0126190185547 L 108.945442199707 103.0126190185547 L 108.945442199707 108.9613494873047 L 83.94998931884766 108.9613494873047 L 83.94998931884766 83.97000122070312 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
