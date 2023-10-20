import 'package:fluttapp/Implementation/ChatImp.dart';
import 'package:fluttapp/Implementation/ConversationImpl.dart';
import 'package:fluttapp/Models/Conversation.dart';
import 'package:fluttapp/presentation/screens/Cliente/ChatPage.dart';
import 'package:fluttapp/presentation/services/alert.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:fluttapp/services/firebase_service.dart';
import 'package:flutter/material.dart';

void main() => runApp(Conversations());

class Conversations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Móvil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreenState(),
    );
  }
}

class ChatScreenState extends StatefulWidget {
  @override
  _ChatScreenStateState createState() => _ChatScreenStateState();
}

class _ChatScreenStateState extends State<ChatScreenState> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final emailController = TextEditingController();
  bool isLoading = true;


  @override
  void initState() {
    super.initState();

    if(namesChats.isEmpty){
      fetchNamesPersonDestino(miembroActual!.id).then((value) => {
        if(mounted){
          setState(() {
            namesChats = value;
          })
        },
        fetchChats().then((value) => {
          
          if(mounted){
            setState((){
              chats = value;
              print(chats.toList());
            })
          },
          isLoading = false,
          
        })
        
      });
      
    }else{
      isLoading=false;
    }

    
    _tabController = TabController(length: 2, vsync: this);
    //namesChats = await fetchNamesPersonDestino(miembroActual!.id);
    socket.on('chat message', (data) async {
      if (!mounted) return; 
      List<dynamic> namesChatsNew = await fetchNamesPersonDestino(miembroActual!.id);
      fetchChats().then((value) {
        if (mounted) { // Asegúrate de comprobar aquí también
          setState(() {
            chats = value;
          });
        }
      });

      if (mounted) {
        setState(() {
          namesChats = namesChatsNew;
        });
      }
    });

  }

  

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> eliminarChat(int index) async{
    await deleteChat(chats[index].idChats);
    setState(() {
      chats.removeAt(index);
    });
  }

  Future<void> addNewChat() async {
    //Registrar Nuevo Chat
    bool canUser = true;
    int idPersonNewChat=0;
    Chat newChat = Chat(idChats: 0, idPerson: 0, idPersonDestino: 0, fechaActualizacion: DateTime.now());
    await getIdPersonByEMail(emailController.text).then((value) => {
      idPersonNewChat = value,
      if(value==miembroActual!.id){
        Mostrar_Error(context, "No puede iniciar un chat con su correo"),
        canUser =false
      }else if(value==0){
        Mostrar_Error(context, "No se encontró el correo"),
        canUser = false
      },
      newChat = Chat(idChats: 0, idPerson: miembroActual!.id, idPersonDestino: idPersonNewChat, fechaActualizacion: DateTime.now()),
    });
    if(canUser){
      int newIdChat = 0;
      await registerNewChat(newChat);
      await getLastIdChat().then((value) => {
          newIdChat = value,
          setState(() {
            chats.add(Chat(idChats: newIdChat, idPerson: miembroActual!.id, idPersonDestino: idPersonNewChat, fechaActualizacion: DateTime.now()));
          })
      });
 
      List<dynamic> namesChatsNew = [];
      //namesChats.clear();
      await fetchNamesPersonDestino(miembroActual!.id).then((value) => {
        if(mounted){
          namesChatsNew = value,
          setState(() {
            namesChats = namesChatsNew;
          })
        }
        
      });
    }
    //
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Color(0xFF5C8ECB),
  appBar: miembroActual!.role!="Super Admin"? AppBar(
    backgroundColor: Color(0xFF5C8ECB),
    title: Text('Chats'),
    bottom: TabBar(
      controller: _tabController,
      tabs: [
        Tab(text: 'Administración'),
        Tab(text: 'Soporte'),
      ],
    ),
    leading: Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
  ): AppBar(
    backgroundColor: Color(0xFF5C8ECB),
    title: Text('Chats'),
    leading: Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
  ),
  body: isLoading==false
      ? TabBarView(
          controller: _tabController,
          children: [
            ChatList(eliminarChatFunction: eliminarChat,),
            EstadoList(eliminarChatFunction: eliminarChat,)
            ,
          ],
        )
      : Center(
          child: CircularProgressIndicator(),
        ),
  floatingActionButton:  FloatingActionButton(
     onPressed: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Iniciar nuevo chat en Administración'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Ingresa el email de la persona con la que quieres chatear:'),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Color(0xFF4D6596), fontSize: 16),
                  cursorColor: Color(0xFF4D6596),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Color(0xFF4D6596)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4D6596), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4D6596).withOpacity(0.5), width: 2.0),
                    ),
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(color: Color(0xFF4D6596).withOpacity(0.5)),
                    prefixIcon: Icon(Icons.email, color: Color(0xFF4D6596)),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Aceptar'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await addNewChat();
                  emailController.clear();
                },
              ),
            ],
          );
        },
      );
    },
    child: Icon(Icons.chat), // Icono de chat
    backgroundColor: Color.fromARGB(255, 0, 204, 255),
    foregroundColor: Colors.white,
    tooltip: 'Iniciar nuevo chat',
  ),
);

  }
}

class ChatList extends StatelessWidget {
  final Function eliminarChatFunction;

  ChatList({required this.eliminarChatFunction});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return chats[index].idPerson!=null? Card(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          elevation: 5,
          child: InkWell(
            onTap: () async {
              currentChatId =  chats[index].idChats;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage(idChat: chats[index].idChats, nombreChat: namesChats[index]["Nombres"], idPersonDestino: 0,)),
              );
            },
            onLongPress: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Eliminar chat?'),
                    content: Icon(Icons.warning, color: Colors.red, size: 50),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancelar', style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          Navigator.of(context).pop(0); 
                        },
                      ),
                      TextButton(
                        child: Text('Eliminar', style: TextStyle(color: Colors.red)),
                        onPressed: () async {
                          eliminarChatFunction(index);
                          Navigator.of(context).pop(1); 
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: ListTile(
              title: Text(namesChats[index]["Nombres"]),
              subtitle: Text(namesChats[index]["mensaje"]),
              leading: CircleAvatar(
                child: Text('0'),
                backgroundColor: Color(0xFF5C8ECB),
              ),
            ),
          ),
        ):Container();
      },
    );
  }
}

class EstadoList extends StatelessWidget {
  final Function eliminarChatFunction;

  EstadoList({required this.eliminarChatFunction});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return chats[index].idPerson==null? Card(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          elevation: 5,
          child: InkWell(
            onTap: () {
              print('idPersonDestino:'+chats[index].idPersonDestino.toString());
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage(idChat: chats[index].idChats, nombreChat: namesChats[index]["Nombres"],idPersonDestino: chats[index].idPersonDestino)),
              );
            },
            onLongPress: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Eliminar chat?'),
                    content: Icon(Icons.warning, color: Colors.red, size: 50),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancelar', style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          Navigator.of(context).pop(0); 
                        },
                      ),
                      TextButton(
                        child: Text('Eliminar', style: TextStyle(color: Colors.red)),
                        onPressed: () async {
                          eliminarChatFunction(index);
                          Navigator.of(context).pop(1); 
                        },
                      ),
                    ],
                  );
                },
              );
            },
            
            child:  ListTile(
              title: Text(namesChats[index]["Nombres"]),
              subtitle: Text(namesChats[index]["mensaje"]),
              leading: CircleAvatar(
                child: Text('0'),
                backgroundColor: Color(0xFF5C8ECB),
              ),
            ),
          ),
        ):Container();
      },
    );
  }
}