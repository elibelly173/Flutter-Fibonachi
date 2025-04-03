import 'package:flutter/material.dart';

class GameAnimations {
  final AnimationController achiController;
  final AnimationController fiboController;
  final Function setState;
  final Map<String, dynamic> animationState;

  GameAnimations({
    required this.achiController,
    required this.fiboController,
    required this.setState,
    required this.animationState,
  });

  // Play the animation for Achi when answer is correct
  void playAchiAnimation() {
    if (achiController.isAnimating) {
      achiController.stop();
    }

    setState(() {
      animationState['currentAchiFrame'] = 1;
    });

    achiController.reset();
    achiController.forward().then((_) {
      setState(() {
        // Return to idle frame after animation
        animationState['currentAchiFrame'] = 3;
      });
    });
  }

  // Play the animation for Fibo when answer is wrong
  void playFiboAnimation() {
    if (fiboController.isAnimating) {
      fiboController.stop();
    }

    setState(() {
      animationState['currentFiboFrame'] = 0;
    });

    fiboController.reset();
    fiboController.forward().then((_) {
      setState(() {
        // Return to idle frame after animation
        animationState['currentFiboFrame'] = 0;
      });
    });
  }

  // Animate the problem transition (when moving to next problem)
  void animateProblemTransition(Widget problemWidget, Function onComplete) {
    setState(() {
      animationState['isProblemAnimating'] = true;
      animationState['problemOpacity'] = 0.0;
    });

    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        // Update the problem
        onComplete();
        // Start fade-in
        animationState['problemOpacity'] = 1.0;
      });

      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          animationState['isProblemAnimating'] = false;
        });
      });
    });
  }

  // Animate adding a tick to the tree when answer is correct
  void animateAddingTick(int tickIndex) {
    setState(() {
      animationState['isTickAnimating'] = true;
      animationState['currentTickIndex'] = tickIndex;
      animationState['tickScale'] = 0.1;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        // Grow tick to full size with slight overshoot
        animationState['tickScale'] = 1.2;
      });

      Future.delayed(Duration(milliseconds: 150), () {
        setState(() {
          // Settle to normal size
          animationState['tickScale'] = 1.0;
          animationState['isTickAnimating'] = false;
        });
      });
    });
  }

  // Animate the answer bubble appearing
  void animateAnswerBubble(bool show) {
    if (show) {
      setState(() {
        animationState['answerBubbleScale'] = 0.1;
        animationState['isAnswerBubbleVisible'] = true;
      });

      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          // Grow to full size with slight overshoot
          animationState['answerBubbleScale'] = 1.3;
        });

        Future.delayed(Duration(milliseconds: 150), () {
          setState(() {
            // Settle to normal size
            animationState['answerBubbleScale'] = 1.0;
          });
        });
      });
    } else {
      setState(() {
        animationState['answerBubbleScale'] = 0.9;
      });

      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          animationState['answerBubbleScale'] = 0.1;
        });

        Future.delayed(Duration(milliseconds: 150), () {
          setState(() {
            animationState['isAnswerBubbleVisible'] = false;
          });
        });
      });
    }
  }

  // Vibrate device on wrong answer
  void vibrateOnWrongAnswer() {
    // HapticFeedback.vibrate();
    // Note: In a real implementation, you would use Flutter's HapticFeedback
    // This is just a placeholder
  }

  // Show level complete animation
  void showLevelComplete(Function onComplete) {
    setState(() {
      animationState['isLevelCompleteAnimating'] = true;
      animationState['levelCompleteOpacity'] = 0.0;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        animationState['levelCompleteOpacity'] = 1.0;
      });

      Future.delayed(Duration(milliseconds: 1500), () {
        onComplete();
      });
    });
  }
}
