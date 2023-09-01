import 'package:fluttapp/presentation/screens/HomeClient.dart';
import 'package:flutter/material.dart';

void main() => runApp(ListMascotas());

class ListMascotas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CampaignPage();
  }
}

class CampaignPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 11, 29, 61),
        title: Text('Mascotas', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/BackGround.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(10),
                color: Color.fromARGB(255, 18, 58, 88),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/Perro.png'),
                      radius: 30,
                    ),
                    title: Text(
                      'Doggy \nFrench Mastiff \n8 meses',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeClient()),
                        )),
              ),
              Card(
                margin: EdgeInsets.all(10),
                color: Color.fromARGB(255, 85, 144, 189),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/Perro.png'),
                      radius: 30,
                    ),
                    title: Text(
                      'Doggy \nFrench Mastiff \n8 meses',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeClient()),
                        )),
              ),
              Card(
                margin: EdgeInsets.all(10),
                color: Color.fromARGB(255, 9, 29, 44),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/Perro.png'),
                      radius: 30,
                    ),
                    title: Text(
                      'Doggy \nFrench Mastiff \n8 meses',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeClient()),
                        )),
              ),
              Card(
                margin: EdgeInsets.all(10),
                color: Color.fromARGB(255, 85, 144, 189),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/Perro.png'),
                      radius: 30,
                    ),
                    title: Text(
                      'Doggy \nFrench Mastiff \n8 meses',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeClient()),
                        )),
              ),
              Card(
                margin: EdgeInsets.all(10),
                color: Color.fromARGB(255, 9, 29, 44),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/Perro.png'),
                      radius: 30,
                    ),
                    title: Text(
                      'Doggy \nFrench Mastiff \n8 meses',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeClient()),
                        )),
              ),
              Card(
                margin: EdgeInsets.all(10),
                color: Color.fromARGB(255, 85, 144, 189),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/Perro.png'),
                      radius: 30,
                    ),
                    title: Text(
                      'Doggy \nFrench Mastiff \n8 meses',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeClient()),
                        )),
              ),
              Card(
                margin: EdgeInsets.all(10),
                color: Color.fromARGB(255, 9, 29, 44),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/Perro.png'),
                      radius: 30,
                    ),
                    title: Text(
                      'Doggy \nFrench Mastiff \n8 meses',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeClient()),
                        )),
              ),
              Card(
                margin: EdgeInsets.all(10),
                color: Color.fromARGB(255, 85, 144, 189),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/Perro.png'),
                      radius: 30,
                    ),
                    title: Text(
                      'Doggy \nFrench Mastiff \n8 meses',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeClient()),
                        )),
              ),
              Card(
                margin: EdgeInsets.all(10),
                color: Color.fromARGB(255, 9, 29, 44),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/Perro.png'),
                      radius: 30,
                    ),
                    title: Text(
                      'Doggy \nFrench Mastiff \n8 meses',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeClient()),
                        )),
              ),
              Card(
                margin: EdgeInsets.all(10),
                color: Color.fromARGB(255, 85, 144, 189),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/Perro.png'),
                      radius: 30,
                    ),
                    title: Text(
                      'Doggy \nFrench Mastiff \n8 meses',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeClient()),
                        )),
              ),
              Card(
                margin: EdgeInsets.all(10),
                color: Color.fromARGB(255, 9, 29, 44),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/Perro.png'),
                      radius: 30,
                    ),
                    title: Text(
                      'Doggy \nFrench Mastiff \n8 meses',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeClient()),
                        )),
              ),
              Card(
                margin: EdgeInsets.all(10),
                color: Color.fromARGB(255, 85, 144, 189),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/Perro.png'),
                      radius: 30,
                    ),
                    title: Text(
                      'Doggy \nFrench Mastiff \n8 meses',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeClient()),
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}