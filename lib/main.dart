import 'package:flutter/material.dart';

void main() => runApp(const IMSApp());

class IMSApp extends StatelessWidget {
  const IMSApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMS Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}

// MODELS
class Product {
  String id, name, category; double price; int stock; int minStock;
  Product({required this.id, required this.name, required this.category, required this.price, required this.stock, this.minStock=5});
}
class Client { String id, name, phone; double debt; Client({required this.id, required this.name, required this.phone, this.debt=0}); }
class Sale { String id, clientName; double total; DateTime date; List<String> items; Sale({required this.id, required this.clientName, required this.total, required this.date, required this.items}); }

// DATA GLOBAL
List<Product> products = [
  Product(id: 'P001', name: 'Riz 25kg', category: 'Alimentation', price: 18000, stock: 12, minStock: 10),
  Product(id: 'P002', name: 'Huile 5L', category: 'Alimentation', price: 6500, stock: 3, minStock: 5),
  Product(id: 'P003', name: 'Ciment', category: 'BTP', price: 4500, stock: 50, minStock: 20),
];
List<Client> clients = [
  Client(id: 'C001', name: 'Boutique Alafia', phone: '97 00 00 00', debt: 15000),
  Client(id: 'C002', name: 'M. Koffi', phone: '96 11 22 33'),
];
List<Sale> sales = [];

// LOGIN
class LoginScreen extends StatefulWidget { const LoginScreen({super.key}); @override State<LoginScreen> createState()=>_LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen>{
  final _user=TextEditingController(text:'admin'), _pass=TextEditingController(text:'1234');
  @override Widget build(BuildContext context){
    return Scaffold(body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.store_mall_directory, size: 80, color: Colors.indigo),
      const SizedBox(height:10), const Text('IMS PRO', style: TextStyle(fontSize:32, fontWeight: FontWeight.bold)),
      const Text('Inventory Management System'), const SizedBox(height:30),
      TextField(controller:_user, decoration: const InputDecoration(labelText:'Utilisateur', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
      const SizedBox(height:12),
      TextField(controller:_pass, obscureText:true, decoration: const InputDecoration(labelText:'Mot de passe', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock))),
      const SizedBox(height:20),
      SizedBox(width:double.infinity, height:50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white), onPressed: (){
        if(_user.text=='admin' && _pass.text=='1234'){ Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const HomeScreen())); }
        else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('admin / 1234'))); }
      }, child: const Text('CONNEXION', style: TextStyle(fontSize:18)))),
    ]))));
  }
}

// HOME
class HomeScreen extends StatefulWidget{ const HomeScreen({super.key}); @override State<HomeScreen> createState()=>_HomeScreenState();}
class _HomeScreenState extends State<HomeScreen>{
  int _index=0;
  final _pages=[const DashboardTab(), const ProductsTab(), const ClientsTab(), const SalesTab()];
  @override Widget build(BuildContext context){
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(selectedIndex:_index, onDestinationSelected:(i)=>setState(()=>_index=i), destinations: const [
        NavigationDestination(icon: Icon(Icons.dashboard), label:'Dashboard'),
        NavigationDestination(icon: Icon(Icons.inventory_2), label:'Produits'),
        NavigationDestination(icon: Icon(Icons.people), label:'Clients'),
        NavigationDestination(icon: Icon(Icons.receipt_long), label:'Ventes'),
      ]),
    );
  }
}

class DashboardTab extends StatelessWidget{
  const DashboardTab({super.key});
  @override Widget build(BuildContext context){
    int lowStock=products.where((p)=>p.stock<=p.minStock).length;
    double totalValue=products.fold(0, (s,p)=>s+p.price*p.stock);
    double todaySales=sales.where((s)=>s.date.day==DateTime.now().day).fold(0,(sum,s)=>sum+s.total);
    return Scaffold(appBar: AppBar(title: const Text('Dashboard IMS'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Row(children: [
          _statCard('Produits', '${products.length}', Colors.blue, Icons.inventory),
          const SizedBox(width:10),
          _statCard('Stock Faible', '$lowStock', Colors.red, Icons.warning),
        ]),
        const SizedBox(height:10),
        Row(children: [
          _statCard('Valeur Stock', '${totalValue.toInt()} F', Colors.green, Icons.account_balance_wallet),
          const SizedBox(width:10),
          _statCard('Ventes Jour', '${todaySales.toInt()} F', Colors.orange, Icons.today),
        ]),
        const SizedBox(height:20),
        if(lowStock>0) Card(color: Colors.red.shade50, child: ListTile(leading: const Icon(Icons.warning, color: Colors.red), title: Text('$lowStock produits en alerte stock'), subtitle: Text(products.where((p)=>p.stock<=p.minStock).map((e)=>e.name).join(', ')))),
        const SizedBox(height:10),
        const Text('Mouvements récents', style: TextStyle(fontWeight: FontWeight.bold, fontSize:18)),
       ...sales.reversed.take(5).map((s)=>ListTile(leading: const Icon(Icons.shopping_cart), title: Text(s.clientName), subtitle: Text(s.items.join(', ')), trailing: Text('${s.total.toInt()} F', style: const TextStyle(fontWeight: FontWeight.bold)))),
        if(sales.isEmpty) const Padding(padding: EdgeInsets.all(20), child: Text('Aucune vente encore. Va dans Ventes pour créer une facture.', textAlign: TextAlign.center)),
      ]),
    );
  }
  Widget _statCard(String t,String v,Color c,IconData ic)=>Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Icon(ic, color:c, size:30), const SizedBox(height:8), Text(v, style: TextStyle(fontSize:20, fontWeight: FontWeight.bold, color:c)), Text(t, textAlign: TextAlign.center)]))));
}

// PRODUCTS TAB
class ProductsTab extends StatefulWidget{ const ProductsTab({super.key}); @override State<ProductsTab> createState()=>_ProductsTabState();}
class _ProductsTabState extends State<ProductsTab>{
  String query='';
  @override Widget build(BuildContext context){
    var filtered=products.where((p)=>p.name.toLowerCase().contains(query.toLowerCase()) || p.id.toLowerCase().contains(query.toLowerCase())).toList();
    return Scaffold(appBar: AppBar(title: const Text('Produits'), backgroundColor: Colors.indigo, foregroundColor: Colors.white,
      bottom: PreferredSize(preferredSize: const Size.fromHeight(60), child: Padding(padding: const EdgeInsets.all(8), child: TextField(onChanged:(v)=>setState(()=>query=v), decoration: const InputDecoration(hintText:'Rechercher produit...', prefixIcon: Icon(Icons.search), filled:true, fillColor: Colors.white, border: OutlineInputBorder()))))),
      floatingActionButton: FloatingActionButton(onPressed: ()=>_showAddDialog(), child: const Icon(Icons.add)),
      body: ListView.builder(itemCount: filtered.length, itemBuilder: (c,i){
        var p=filtered[i]; bool low=p.stock<=p.minStock;
        return Card(color: low?Colors.red.shade50:null, child: ListTile(
          leading: CircleAvatar(backgroundColor: low?Colors.red:Colors.indigo, child: Text(p.stock.toString(), style: const TextStyle(color:Colors.white))),
          title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('${p.category} - ${p.price.toInt()} F - Min:${p.minStock}'),
          trailing: PopupMenuButton(onSelected:(v){ if(v=='edit')_showAddDialog(edit:p); else if(v=='del') setState(()=>products.remove(p)); }, itemBuilder: (_)=>[const PopupMenuItem(value:'edit', child: Text('Modifier')), const PopupMenuItem(value:'del', child: Text('Supprimer'))]),
        ));
      }),
    );
  }
  void _showAddDialog({Product? edit}){
    var name=TextEditingController(text:edit?.name??''), price=TextEditingController(text:edit?.price.toString()??''), stock=TextEditingController(text:edit?.stock.toString()??''), cat=TextEditingController(text:edit?.category??'');
    showDialog(context: context, builder: (_)=>AlertDialog(title: Text(edit==null?'Nouveau Produit':'Modifier'), content: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(controller:name, decoration: const InputDecoration(labelText:'Nom')), TextField(controller:cat, decoration: const InputDecoration(labelText:'Catégorie')),
      TextField(controller:price, decoration: const InputDecoration(labelText:'Prix'), keyboardType: TextInputType.number),
      TextField(controller:stock, decoration: const InputDecoration(labelText:'Stock'), keyboardType: TextInputType.number),
    ]), actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Annuler')), ElevatedButton(onPressed: (){
      if(edit==null){ products.add(Product(id:'P${DateTime.now().millisecond}', name:name.text, category:cat.text, price:double.tryParse(price.text)??0, stock:int.tryParse(stock.text)??0)); }
      else { edit.name=name.text; edit.category=cat.text; edit.price=double.tryParse(price.text)??edit.price; edit.stock=int.tryParse(stock.text)??edit.stock; }
      setState((){}); Navigator.pop(context);
    }, child: const Text('Sauver'))]));
  }
}

// CLIENTS
class ClientsTab extends StatefulWidget{ const ClientsTab({super.key}); @override State<ClientsTab> createState()=>_ClientsTabState();}
class _ClientsTabState extends State<ClientsTab>{
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: const Text('Clients'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      floatingActionButton: FloatingActionButton(onPressed: (){ var n=TextEditingController(), ph=TextEditingController(); showDialog(context: context, builder: (_)=>AlertDialog(title: const Text('Nouveau Client'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller:n, decoration: const InputDecoration(labelText:'Nom')), TextField(controller:ph, decoration: const InputDecoration(labelText:'Téléphone'))]), actions: [ElevatedButton(onPressed: (){ clients.add(Client(id:'C${DateTime.now().millisecond}', name:n.text, phone:ph.text)); setState((){}); Navigator.pop(context); }, child: const Text('Ajouter'))])); }, child: const Icon(Icons.person_add)),
      body: ListView.builder(itemCount: clients.length, itemBuilder: (c,i){ var cl=clients[i]; return Card(child: ListTile(leading: const Icon(Icons.person, size:40), title: Text(cl.name, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(cl.phone), trailing: Text(cl.debt>0?'Dette: ${cl.debt.toInt()} F':'', style: const TextStyle(color:Colors.red)))); }),
    );
  }
}

// SALES
class SalesTab extends StatefulWidget{ const SalesTab({super.key}); @override State<SalesTab> createState()=>_SalesTabState();}
class _SalesTabState extends State<SalesTab>{
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: const Text('Ventes / Factures'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      floatingActionButton: FloatingActionButton.extended(onPressed: ()=>_newSale(), label: const Text('Nouvelle Vente'), icon: const Icon(Icons.add_shopping_cart)),
      body: sales.isEmpty? const Center(child: Text('Aucune vente')) : ListView.builder(itemCount: sales.length, itemBuilder: (c,i){ var s=sales[i]; return Card(child: ListTile(title: Text('Facture ${s.id} - ${s.clientName}'), subtitle: Text('${s.date.day}/${s.date.month} ${s.date.hour}h - ${s.items.join(', ')}'), trailing: Text('${s.total.toInt()} F', style: const TextStyle(fontWeight: FontWeight.bold, fontSize:16)))); }),
    );
  }
  void _newSale(){
    Product? selected; int qty=1; String client='Client comptant';
    showDialog(context: context, builder: (_)=>StatefulBuilder(builder: (ctx, setS)=>AlertDialog(title: const Text('Nouvelle Vente'), content: Column(mainAxisSize: MainAxisSize.min, children: [
      DropdownButton<Product>(hint: const Text('Choisir produit'), value:selected, isExpanded:true, items: products.map((p)=>DropdownMenuItem(value:p, child: Text('${p.name} - Stock:${p.stock}'))).toList(), onChanged:(v)=>setS(()=>selected=v)),
      TextField(decoration: const InputDecoration(labelText:'Client'), onChanged:(v)=>client=v),
      Row(children: [const Text('Qté:'), IconButton(onPressed: ()=>setS(()=>qty>1?qty--:null), icon: const Icon(Icons.remove)), Text('$qty'), IconButton(onPressed: ()=>setS(()=>qty++), icon: const Icon(Icons.add))]),
      if(selected!=null) Text('Total: ${(selected!.price*qty).toInt()} F', style: const TextStyle(fontWeight: FontWeight.bold, fontSize:18)),
    ]), actions: [TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text('Annuler')), ElevatedButton(onPressed: (){
      if(selected==null) return;
      if(selected!.stock<qty){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stock insuffisant!'))); return; }
      setState((){ selected!.stock-=qty; sales.add(Sale(id:'F${DateTime.now().millisecond}', clientName:client, total:selected!.price*qty, date:DateTime.now(), items:['${selected!.name} x$qty'])); });
      Navigator.pop(ctx);
    }, child: const Text('Vendre'))])));
  }
}
