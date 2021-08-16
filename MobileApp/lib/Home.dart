import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.all(12),
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: 35,
          ),
          userTile(),
          divider(),
          colorTiles(),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget userTile() {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/images/Nisansala.jpg'),
      ),
      title: Text(
        "Nisansala Dananjaya",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "Owner of the House No : AP001",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Divider(
        thickness: 1.5,
      ),
    );
  }

  Widget colorTiles() {
    return Column(
      children: [
        colorTile(Icons.home, Colors.deepPurple, "Details"),
        colorTile(Icons.mode, Colors.pink, "Modes"),
        colorTile(Icons.sensor_door, Colors.blue, "Sensors"),
        colorTile(Icons.layers_outlined, Colors.red, "Layout"),
        colorTile(Icons.settings, Colors.black, "Settings"),
      ],
    );
  }

  Widget colorTile(IconData icon, Color color, String text) {
    return ListTile(
      leading: Container(
        child: Icon(
          icon,
          color: color,
        ),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            color: color.withOpacity(0.09),
            borderRadius: BorderRadius.circular(18)),
      ),
      title: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.black,
        size: 28,
      ),
    );
  }

  Widget bottomNavigationBar() {
    List<IconData> icons = [
      Icons.home,
      Icons.search,
      Icons.notifications,
      Icons.person_outline,
    ];
    return BottomNavigationBar(
      items: icons.map((icon) => item(icon)).toList(),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
    );
  }

  BottomNavigationBarItem item(
    IconData icon,
  ) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: "",
    );
  }
}
