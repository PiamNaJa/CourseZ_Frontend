import 'package:flutter/material.dart';
import 'Regteacher.dart';
import 'Regpeople.dart';

class RegisterPage2 extends StatefulWidget {
  const RegisterPage2({super.key});

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color.fromRGBO(0, 216, 133, 1)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                width: 1200.0,
                height: 120.0,
                child: Image.asset("assets/images/Kunkru.png"),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "ท่านเป็นครู/อาจารย์ หรือ บุคคลทั่วไป",
                style: TextStyle(
                    fontFamily: 'Athiti',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromRGBO(0, 216, 133, 1))),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const RegisterTeacher();
                      }));
                    },
                    child: const Text(
                      "ครู/อาจารย์",
                      style: TextStyle(
                          fontFamily: 'Athiti',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromRGBO(0, 216, 133, 1))),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const RegisterPeople();
                      }));
                    },
                    child: const Text(
                      "บุคคลทั่วไป",
                      style: TextStyle(
                          fontFamily: 'Athiti',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
