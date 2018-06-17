import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(home: new MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Step> _steps;
  int _current;

  @override
  void initState() {
    _current = 0;
    _steps = <Step>[
      Step(
          title: Text('Step 1'), content: Text('Do Something'), isActive: true),
      Step(
          title: Text('Step 2'), content: Text('Do Something'), isActive: true),
      Step(
          title: Text('Step 3'), content: Text('Do Something'), isActive: true),
    ];
    super.initState();
  }

  void _stepContinue() {
    setState(() {
      _current++;
      if (_current >= _steps.length) {
        _current = _steps.length - 1;
      }
    });
  }

  void _stepCancel() {
    setState(() {
      _current--;
      if (_current < 0) {
        _current = 0;
      }
    });
  }

  void _stepTap(int index) {
    setState(() {
      _current = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stepper sample'),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Stepper(
            steps: _steps,
            type: StepperType.vertical,
            currentStep: _current,
            onStepCancel: _stepCancel,
            onStepContinue: _stepContinue,
            onStepTapped: _stepTap,
          ),
        ),
      ),
    );
    ;
  }
}
