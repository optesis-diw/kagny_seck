import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

class ParametresPage extends StatefulWidget {
  const ParametresPage({Key? key,}) : super(key: key);
  @override
  State<ParametresPage> createState() => _ParametresPageState();
}

class _ParametresPageState extends State<ParametresPage> {

  @override
  void initState(){
    super.initState();
  }

  Future<SharedPreferences>? _initialisation() async {
    return await SharedPreferences.getInstance();
  }

  _isUserWantAuth(bool? response) async {
    print("___________value=${response.toString()}____________");
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if(response == false){
      localStorage.setBool(Constants.IS_USER_WANT_AUTH, false);
    }
    if (response == true){
      localStorage.setBool(Constants.IS_USER_WANT_AUTH, true);
    }
    setState(() {
      _initialisation();
    });
  }

  shareYowpay() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? myOrganiz = localStorage.getString(Constants.YOWPAY_URL_DEFAULT);
    String? myName = localStorage.getString(Constants.YOWPAY_CLIENT_NAME);
    await Share.share(
        "Bonjour!\n ${myName.toString()} vous invite à rejoindre son organisation depuis l'url\n${myOrganiz.toString()}\nVous pouvez telecharger l'application YowPay Sur Android ou IOS"
        );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Constants.PRIMARY_COLOR,
        title: const Text(
            "Parametres",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<SharedPreferences>(
          future: _initialisation(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              var error = snapshot.error.toString();
              return Center(child: Flushbar(
                title: 'Erreur',
                message: error,
              )
              );
            } else {
              return snapshot.hasData
                  ? Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    const Text("Vos informations"),
                    const SizedBox(height: 6,),
                    Container(
                      width: size.width,
                      height: 150,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              leading: const Icon(Icons.person, color: Constants.PRIMARY_COLOR, size: 32,),
                              title: const Text("Nom utilisateur", style: TextStyle(fontSize: 16),),
                              onTap: (){ },
                              subtitle: Text(
                                snapshot.data?.getString(Constants.YOWPAY_CLIENT_NAME).toString() ?? "",
                                style: const TextStyle(
                                    color: Constants.PRIMARY_COLOR
                                ),
                              )
                          ),
                          ListTile(
                              leading: const Icon(Icons.home, color: Constants.PRIMARY_COLOR, size: 32,),
                              title: const Text("Url de votre organisation", style: TextStyle(fontSize: 16),),
                              onTap: (){ },
                              subtitle: Text(
                                snapshot.data?.getString(Constants.YOWPAY_URL_DEFAULT).toString() ?? "",
                                style: const TextStyle(
                                    color: Constants.PRIMARY_COLOR
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Text("Securité"),
                    const SizedBox(height: 6,),
                    Container(
                      width: size.width,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                                leading: const Icon(Icons.lock_outline, color: Constants.PRIMARY_COLOR, size: 32,),
                                title: const Text("Activez le vérrouillage ?", style: TextStyle(fontSize: 16),),
                                onTap: (){ },
                                subtitle: GFToggle(
                                    onChanged: (val){
                                      _isUserWantAuth(val);
                                    } ,// ,
                                    value: snapshot.data?.getBool(Constants.IS_USER_WANT_AUTH) ?? false
                                )
                            ),
                          ],
                        ),
                    ),
                    const SizedBox(height: 15,),
                    const Text("Partager"),
                    const SizedBox(height: 6,),
                    Container(
                      width: size.width,
                      height: 60,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              leading: const Icon(Icons.share, color: Constants.PRIMARY_COLOR, size: 32,),
                              title: const Text("Partager avec vos camarades", style: TextStyle(fontSize: 16),),
                              onTap: (){
                                shareYowpay();
                              },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15,),
                    const Text("Support"),
                    const SizedBox(height: 6,),
                    Container(
                      width: size.width,
                      height: 60,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.phone, color: Constants.PRIMARY_COLOR, size: 32,),
                            title: const Text("Contactez le service client", style: TextStyle(fontSize: 16),),
                            onTap: (){ },
                          ),
                        ],
                      ),
                    ),
                  ]
                  ) 
                ) :
                  const Center(
                    child: CircularProgressIndicator(),
                  );
            }
          }
      )
    );
  }
}
