import 'package:blu_block/classes/account_overview.dart';
import 'package:blu_block/ui/components/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget  {
  const ListPage({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  TextEditingController _searchController = TextEditingController();
  List _filteredAccounts = [];
  final accounts = AccountOverview().getAccountList();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterAccounts);
    _filteredAccounts = Provider.of<AccountOverview>(context, listen: false).getAccountList();
  }

  void _filterAccounts() {
    String query = _searchController.text.toLowerCase();
    List helper = [];
    for (Map acc in accounts){
      if (acc["account"].accountName.toLowerCase().contains(query)){
        helper.add(acc);
      }
    }
    setState(() {
      _filteredAccounts = helper;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterAccounts);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (
      Scaffold(
        appBar: AppBar(
          title: const Text("Accounts"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
                child:TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Suchen',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                  ),
                ),
              ),
              for (Map account in _filteredAccounts) AccountDisplay(account: account, refresh: _filterAccounts)
            ],
          ),
        )
      )
    );
  }
}

class AccountDisplay extends StatelessWidget{
  final Map account;
  final Function refresh;

  const AccountDisplay({super.key, required this.account, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: (account['account'].blocked)? Colors.greenAccent: (account['account'].ignored)? Colors.yellowAccent : Colors.redAccent),
        borderRadius: const BorderRadius.all(Radius.circular(15))
      ),
      child: Column(
        children: [
          Text("${account['account'].accountName}", style: const TextStyle(fontSize: 18),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Kategorie: ${account['category']}", ),
              Text("Plattform: ${account['platform']}", ),
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (account['account'].blocked)?const Text("") : CustomButton(text: (account['account'].ignored)?"Nicht mehr ignorieren": "Ignorieren", onClick: () {account['account'].toggleIgnored(); AccountOverview().initialize(); refresh();}),
              Text("Blockiert: ${(account['account'].blocked)? "Ja": "Nein"}${(account['account'].ignored)?" (Ignoriert)":""}"),
            ]
          )
        ]
      )
    );
  }
}