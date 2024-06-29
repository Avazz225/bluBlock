import 'package:BluBlock/classes/account_overview.dart';
import 'package:BluBlock/ui/components/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget  {
  const ListPage({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController _searchController = TextEditingController();
  List _filteredAccounts = [];
  List accounts = [];
  int _selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterAccounts);
    _filteredAccounts = Provider.of<AccountOverview>(context, listen: false).getAccountList();
    _initAccounts();
  }

  _initAccounts () async {
    accounts = await AccountOverview().getAccountList();
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

  void _onFilterChanged(int? value) {
    setState(() {
      _selectedFilter = value!;
      _filterAccounts();
    });

    AccountOverview().setFilter(value!);
    _filteredAccounts = AccountOverview().getAccountList();
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
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Suchen',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      ),
                    ),
                    DropdownButton<int>(
                      value: _selectedFilter,
                      items: const [
                        DropdownMenuItem(value: 0, child: Text("Alle")),
                        DropdownMenuItem(value: 1, child: Text("Nicht blockiert")),
                        DropdownMenuItem(value: 2, child: Text("Blockiert")),
                        DropdownMenuItem(value: 3, child: Text("Ignoriert")),
                        DropdownMenuItem(value: 4, child: Text("Gescheitert")),
                      ],
                      onChanged: _onFilterChanged,
                      isExpanded: true,
                    ),
                  ]
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
    Color border = Colors.greenAccent;
    if (account['account'].blocked){
      border = Colors.greenAccent;
    } else if (account['account'].ignored) {
      border = Colors.yellowAccent;
    } else if (account['account'].attempt){
      border = Colors.redAccent;
    } else {
      border = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: border),
        borderRadius: const BorderRadius.all(Radius.circular(15))
      ),
      child: Column(
        children: [
          Text("${account['account'].accountName}", style: const TextStyle(fontSize: 18),),
          Text(((account['account'].accountId.startsWith("@"))?"":"@") + account['account'].accountId, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),),
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
              Text("Blockiert: ${(account['account'].blocked)? "Ja": "Nein"}${(account['account'].ignored)?" (Ignoriert)":""}${(account['account'].attempt && !account['account'].ignored)?" (Gescheitert)":""}"),
            ]
          )
        ]
      )
    );
  }
}