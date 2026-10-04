import 'package:flutter/material.dart';

void main() => runApp(IMSApp());

class IMSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMS - Invest Money Smart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF0A1F44),
        scaffoldBackgroundColor: Color(0xFFF5F7FB),
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _index = 0;
  
  final pages = [HomePage(), PlansPage(), WalletPage(), ProfilePage()];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF0A1F44),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Plans'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(height: 10),
          Text('Bonjour,', style: TextStyle(fontSize: 16, color: Colors.grey)),
          Text('Investisseur IMS 👋', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0A1F44))),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF0A1F44), Color(0xFF1E3A8A)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Solde Total', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 5),
                Text('125 000 FCFA', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                SizedBox(height: 15),
                Row(
                  children: [
                    _miniStat('Gains', '+12%'),
                    SizedBox(width: 20),
                    _miniStat('Investi', '100k'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text('Plans Populaires', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          _planCard('Starter', '10 000 - 50 000 FCFA', '15% en 7 jours', Colors.green),
          _planCard('Pro', '50 000 - 200 000 FCFA', '25% en 15 jours', Colors.orange),
          _planCard('Premium', '200 000+ FCFA', '45% en 30 jours', Color(0xFF0A1F44)),
        ],
      ),
    );
  }
  
  Widget _miniStat(String t, String v) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(t, style: TextStyle(color: Colors.white70, fontSize: 12)),
      Text(v, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ],
  );
  
  Widget _planCard(String title, String range, String profit, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
      child: Row(
        children: [
          Container(width: 50, height: 50, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.rocket_launch, color: color)),
          SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(range, style: TextStyle(color: Colors.grey, fontSize: 12)),
            Text(profit, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ])),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}

class PlansPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('Plans IMS'), backgroundColor: Color(0xFF0A1F44)), body: Center(child: Text('3 Plans disponibles - Starter, Pro, Premium')));
}
class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('Mon Wallet'), backgroundColor: Color(0xFF0A1F44)), body: Center(child: Text('Dépôt MTN / Moov - Retrait'))));
}
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('Profil'), backgroundColor: Color(0xFF0A1F44)), body: Center(child: Text('IMS - Invest Money Smart v1.0')));
}
