import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'KALORI HESAPLAMA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int calorieBase;
  int calori1;
  int calori2;
  int calori3;
  int calori4;
  int radioSelectionnee;
  int radioSelectionnee2;
  int radioSelectionnee3;
  int radioSelectionnee4;
  double poids;
  double age;
  bool genre = false;
  double taille = 170.0;
  int caloriTop;

  Map mapActivite = {
    0: "Et",
    1: "Balık",
    2: "Tavuk",
    6: "Hiçbiri",
  };
  Map mapActivite2 = {
    3: "Pilav",
    4: "Makarna",
    5: "Bulgur",
    6: "Hiçbiri",
  };
  Map mapActivite3 = {
    3: "Meyve Suyu",
    4: "Kahve/Çay",
    5: "Gazlı içecek",
    6: "Hiçbiri",
  };
  Map mapActivite4 = {
    3: "Sütlü tatlı",
    4: "Şerbetli Tatlı",
    5: "Meyve",
    6: "Hiçbiri",
  };

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          backgroundColor: setColor(),
        ),
        body: new SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              padding(),
              texteAvecStyle(
                  "Kalorinizi hesaplamak için bilgilerinizi giriniz ve bugün tükettiğiniz besinleri seçiniz. Hesapladıktan sonra bilgilerinizi kaydedebilirsiniz."),
              padding(),
              new Card(
                elevation: 10.0,
                child: new Column(
                  children: <Widget>[
                    padding(),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        texteAvecStyle("Kadın", color: Colors.pink),
                        new Switch(
                            value: genre,
                            inactiveTrackColor: Colors.pink,
                            activeTrackColor: Colors.blue,
                            onChanged: (bool b) {
                              setState(() {
                                genre = b;
                              });
                            }),
                        texteAvecStyle("Erkek", color: Colors.blue)
                      ],
                    ),
                    padding(),
                    new RaisedButton(
                        color: setColor(),
                        child: texteAvecStyle(
                            (age == null)
                                ? "Yaşınızı girmek için doğum tarihinizi seçin "
                                : " Yaşınız için Doğum tarihinizi seçin : ${age.toInt()}",
                            color: Colors.white),
                        onPressed: (() => montrerPicker())),
                    padding(),
                    texteAvecStyle("Boyunuz nedir?: ${taille.toInt()} cm.",
                        color: setColor()),
                    padding(),
                    new Slider(
                      value: taille,
                      activeColor: setColor(),
                      onChanged: (double d) {
                        setState(() {
                          taille = d;
                        });
                      },
                      max: 215.0,
                      min: 100.0,
                    ),
                    padding(),
                    new TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (String string) {
                        setState(() {
                          poids = double.tryParse(string);
                        });
                      },
                      decoration: new InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Kilo Giriniz. (kg)",
                      ),
                    ),
                    padding(),
                    texteAvecStyle(
                        "Gün içinde tükettiğiniz ağırlıklı besinleri seçiniz?",
                        color: setColor()),
                    padding(),
                    rowRadio(),
                    rowRadio2(),
                    rowRadio3(),
                    rowRadio4(),
                    padding()
                  ],
                ),
              ),
              padding(),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new RaisedButton(
                    color: setColor(),
                    child: texteAvecStyle("Hesapla", color: Colors.white),
                    onPressed: calculerNombreDeCalories,
                  ),
                  new RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    color: setColor(),
                    child:
                        Text('Kaydet', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Page2(
                            age1 : age.toInt(),
                            taille1 : taille.toInt(),
                            poids1 : poids.toInt(),
                            calori1 : caloriTop
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding padding() {
    return new Padding(padding: EdgeInsets.only(top: 20.0));
  }

  Future<Null> montrerPicker() async {
    DateTime choix = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now(),
        initialDatePickerMode: DatePickerMode.year);
    if (choix != null) {
      var difference = new DateTime.now().difference(choix);
      var jours = difference.inDays;
      var ans = (jours / 365);
      setState(() {
        age = ans;
      });
    }
  }

  Color setColor() {
    if (genre) {
      return Colors.blue;
    } else {
      return Colors.pink;
    }
  }

  Text texteAvecStyle(String data, {color: Colors.black, fontSize: 15.0}) {
    return new Text(data,
        textAlign: TextAlign.center,
        style: new TextStyle(color: color, fontSize: fontSize));
  }

  Row rowRadio() {
    List<Widget> l = [];
    mapActivite.forEach((key, value) {
      Column colonne = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Radio(
              activeColor: setColor(),
              value: key,
              groupValue: radioSelectionnee,
              onChanged: (Object i) {
                setState(() {
                  radioSelectionnee = i;
                });
              }),
          texteAvecStyle(value, color: setColor())
        ],
      );
      l.add(colonne);
    });
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: l,
    );
  }

  Row rowRadio2() {
    List<Widget> l = [];
    mapActivite2.forEach((key, value) {
      Column colonne = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Radio(
              activeColor: setColor(),
              value: key,
              groupValue: radioSelectionnee2,
              onChanged: (Object i) {
                setState(() {
                  radioSelectionnee2 = i;
                });
              }),
          texteAvecStyle(value, color: setColor())
        ],
      );
      l.add(colonne);
    });
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: l,
    );
  }

  Row rowRadio3() {
    List<Widget> l = [];
    mapActivite3.forEach((key, value) {
      Column colonne = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Radio(
              activeColor: setColor(),
              value: key,
              groupValue: radioSelectionnee3,
              onChanged: (Object i) {
                setState(() {
                  radioSelectionnee3 = i;
                });
              }),
          texteAvecStyle(value, color: setColor())
        ],
      );
      l.add(colonne);
    });
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: l,
    );
  }

  Row rowRadio4() {
    List<Widget> l = [];
    mapActivite4.forEach((key, value) {
      Column colonne = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Radio(
              activeColor: setColor(),
              value: key,
              groupValue: radioSelectionnee4,
              onChanged: (Object i) {
                setState(() {
                  radioSelectionnee4 = i;
                });
              }),
          texteAvecStyle(value, color: setColor())
        ],
      );
      l.add(colonne);
    });
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: l,
    );
  }

  void calculerNombreDeCalories() {
    if (age != null && poids != null && radioSelectionnee != null) {
      if (genre) {
        calorieBase =
            (66.4730 + (13.7516 * poids) + (5.0033 * taille) - (6.7550 * age))
                .toInt();
      } else {
        calorieBase =
            (655.0955 + (9.5634 * poids) + (1.8496 * taille) - (4.6756 * age))
                .toInt();
      }
      switch (radioSelectionnee) {
        case 0:
          calori1 = (calorieBase * 143).toInt();
          break;
        case 1:
          calori1 = (calorieBase * 205).toInt();
          break;
        case 2:
          calori1 = (calorieBase * 239).toInt();
          break;
        case 6:
          calori1 = (calorieBase * 0).toInt();
          break;
        default:
          calori1 = calorieBase;
          break;
      }
      switch (radioSelectionnee2) {
        case 3:
          calori2 = (calorieBase * 359).toInt();
          break;
        case 4:
          calori2 = (calorieBase * 131).toInt();
          break;
        case 5:
          calori2 = (calorieBase * 342).toInt();
          break;
        case 6:
          calori2 = (calorieBase * 0).toInt();
          break;
        default:
          calori2 = calorieBase;
          break;
      }
      switch (radioSelectionnee3) {
        case 3:
          calori3 = (calorieBase * 54).toInt();
          break;
        case 4:
          calori3 = (calorieBase * 1).toInt();
          break;
        case 5:
          calori3 = (calorieBase * 41).toInt();
          break;
        case 6:
          calori3 = (calorieBase * 0).toInt();
          break;
        default:
          calori3 = calorieBase;
          break;
      }
      switch (radioSelectionnee4) {
        case 3:
          calori4 = (calorieBase * 400).toInt();
          break;
        case 4:
          calori4 = (calorieBase * 586).toInt();
          break;
        case 5:
          calori4 = (calorieBase * 40).toInt();
          break;
        case 6:
          calori4 = (calorieBase * 0).toInt();
          break;
        default:
          calori4 = calorieBase;
          break;
      }

       caloriTop = calori1+calori2+calori3+calori4;

      setState(() {
        dialogue();
      });
    } else {
      alerte();
    }
  }

  Future<Null> dialogue() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return SimpleDialog(
            title: texteAvecStyle("Kaloriniz", color: setColor()),
            contentPadding: EdgeInsets.all(15.0),
            children: <Widget>[
              padding(),
              texteAvecStyle("Temel Kalori ihtiyacınız: $calorieBase"),
              padding(),
              texteAvecStyle(
                  "Aldığınız Besinlerden Toplam Kaloriniz : $caloriTop"),
              new RaisedButton(
                onPressed: () {
                  Navigator.pop(buildContext);
                },
                child: texteAvecStyle("Tamam", color: Colors.white),
                color: setColor(),
              )
            ],
          );
        });
  }

  Future<Null> alerte() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return new AlertDialog(
            title: texteAvecStyle("UYARI"),
            content: texteAvecStyle("Lütfen tüm alanları doldurunuz."),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(buildContext);
                  },
                  child: texteAvecStyle("Tamam", color: Colors.red))
            ],
          );
        });
  }
}


class Page2 extends StatefulWidget {
  final int age1;
  final int taille1;
  final int poids1;
  final int calori1;

  const Page2({Key key, this.age1, this.taille1, this.poids1, this.calori1})
      : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Günlük Kayıtlarınız',
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            new ListBody(
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Bilgileriniz',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold),
                    ),
                    Text("Yaşınız: ${widget.age1}",
                        style: TextStyle(fontSize: 20.0)),
                    Text("Boyunuz: ${widget.taille1}",
                        style: TextStyle(fontSize: 20.0)),
                    Text("Kilonuz: ${widget.poids1}",
                        style: TextStyle(fontSize: 20.0)),
                    Text("Bugünki Toplam Kaloriniz: ${widget.calori1}",
                        style: TextStyle(fontSize: 20.0)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
