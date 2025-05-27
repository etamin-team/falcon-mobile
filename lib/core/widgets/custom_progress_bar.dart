import 'package:flutter/material.dart';
import 'package:wm_doctor/core/constant/diments.dart';
import 'package:wm_doctor/core/styles/app_colors.dart';

class CustomProgressBar extends StatelessWidget {
  final String title;
  final int current;
  final int total;
  final Color backgroundColor;

  const CustomProgressBar({
    super.key,
    required this.title,
    required this.current,
    required this.total,
    this.backgroundColor = AppColors.backgroundColor,

  });

  @override
  Widget build(BuildContext context) {
    double progress = current / total;
    if (total == 0) {
      progress = 0;
    }else if(current>total){
      progress=1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Stack(
        children: [
          // Background progress bar (Gray)
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Filled progress (Green)
          FractionallySizedBox(
            widthFactor: progress,

            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          // Text on progress bar
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: Dimens.space14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "$current из $total",
                    style: TextStyle(
                      fontSize: Dimens.space14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
