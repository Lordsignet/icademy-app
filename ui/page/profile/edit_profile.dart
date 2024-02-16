import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/helper/custom_route.dart';
import 'package:racfmn/helper/shared_prefrence_helper.dart';
import 'package:racfmn/helper/utility.dart';
import 'package:racfmn/state/auth_state.dart';
import 'package:racfmn/ui/page/common/locator.dart';
import 'package:racfmn/ui/page/profile/widgets/circular_image.dart';
import 'package:racfmn/widgets/cache_image.dart';
import 'package:racfmn/widgets/custom_flat_button.dart';
import 'package:racfmn/widgets/custom_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:racfmn/widgets/newWidget/custom_loader.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key? key}) : super(key: key);
  static MaterialPageRoute<T> getRoute<T>() {
    return CustomRoute<T>(builder: (BuildContext context) => EditProfilePage());
  }

  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;
  File? _banner;
  TextEditingController? _firstname;
  TextEditingController? _lastname;
  TextEditingController? _location;
  TextEditingController? _state;
  TextEditingController? _address;
  TextEditingController? _philosophy;
  TextEditingController? _country;
  TextEditingController? _dob;
  TextEditingController? _contact;
  final ImagePicker _pickimage = ImagePicker();
  final GlobalKey<ScaffoldState>? _scaffoldKey = new GlobalKey<ScaffoldState>();
  String? dob;
  CustomLoader? loader;
  dynamic userError;
  
  
  @override
  void initState() {
    _firstname = TextEditingController();
    _lastname = TextEditingController();
    _dob = TextEditingController();
    _country = TextEditingController();
    _state = TextEditingController();
    _address = TextEditingController();
    _philosophy = TextEditingController();
    _contact = TextEditingController();
    var state = Provider.of<AuthState>(context, listen: false).userModel;
    print(state.country);
    _firstname!.text = state.displayName as String;
    _lastname!.text = state.displayLast as String;
    _address!.text = state.address as String;
     _country!.text = state.country as String;
      _philosophy!.text = state.philosophy as String;
       _state!.text = state.state as String;
        _contact!.text = state.contact as String;
    _dob!.text = state.dob as String;
    loader = CustomLoader();
    super.initState();
  }

  void dispose() {
    _firstname!.dispose();
    _lastname!.dispose();
    _country!.dispose();
    _dob!.dispose();
    _contact!.dispose();
     _state!.dispose();
    _address!.dispose();
    _philosophy!.dispose();
    super.dispose();
  }

  Widget _body() {
    var authstate = Provider.of<AuthState>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
     /*   Container(
          height: 180,
          child: Stack(
            children: <Widget>[
              _bannerImage(authstate),
              Align(
                alignment: Alignment.bottomLeft,
                child: _userImage(authstate),
              ),
            ],
          ),
        ),
        
       _twoColumnRow(firstString: "Firstname", secondString: "Lastname",firstController: _firstname as TextEditingController, 
       secondController: _lastname as TextEditingController),
       */
      Row(
         children: <Widget>[
           Expanded(
          child: _entry('Firstname', controller: _firstname as TextEditingController),
        
        ),
        SizedBox(width: 3),
        Expanded(child:  _entry('Lastname',
            controller: _lastname as TextEditingController),)
        ]
        ),
       Row(
         children: <Widget>[
           Expanded(child: InkWell(
          onTap: showCalender,
          child: _entry('Date of birth',
              isenable: false, controller: _dob as TextEditingController),
        )
        ),
        SizedBox(width: 10),
        Expanded(child:  _entry('Contact',
            controller: _contact as TextEditingController, maxLine: null as int, keyboardType: TextInputType.phone),)
        ]
        ),

      
        _entry('Address', controller: _address as TextEditingController, keyboardType: TextInputType.streetAddress),
        _entry('State', controller: _state as TextEditingController),
        _entry('Country', controller: _country as TextEditingController),
        _entry('Philosophy', controller: _philosophy as TextEditingController,maxLine: 3, keyboardType: TextInputType.multiline)
        
      ],
    );
  }

  Widget _userImage(AuthState authstate) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
        image: DecorationImage(
            image: customAdvanceNetworkImage(
                authstate.userModel.profilePic as String),
            fit: BoxFit.cover),
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: _image != null
            ? FileImage(_image as File)
            : customAdvanceNetworkImage(
                    authstate.userModel.profilePic as String)
                as ImageProvider<Object>,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black38,
          ),
          child: Center(
            child: IconButton(
              onPressed: uploadImage,
              icon: Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bannerImage(AuthState authstate) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        image: authstate.userModel.profilePic == null
            ? null
            : DecorationImage(
                image: customAdvanceNetworkImage(
                    authstate.userModel.profilePic as String),
                fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black45,
        ),
        child: Stack(
          children: [
            _banner != null
                ? Image.file(_banner as File,
                    fit: BoxFit.fill, width: MediaQuery.of(context).size.width)
                : CacheImage(
                    path: authstate.userModel.profilePic ??
                        "${Constants.dummyProfilePic}",
                    fit: BoxFit.fill),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black38),
                child: IconButton(
                  onPressed: uploadBanner,
                  icon: Icon(Icons.camera_alt, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _entry(String title,
      {TextEditingController? controller,
      TextInputType? keyboardType,
      int maxLine = 1,
      bool isenable = true}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          customText(title, style: TextStyle(color: Colors.black54)),
          TextField(
            enabled: isenable,
            controller: controller,
            maxLines: maxLine,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
          )
        ],
      ),
    );
  }
 Widget _twoColumnRow({
      int maxLine = 1,
      String? firstString,
      String? secondString,
      TextEditingController? firstController,
      TextEditingController? secondController,
      bool isenable = true}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
     children: <Widget>[
       Expanded(child: customText("${firstString}", style: TextStyle(color: Colors.black54))),
       SizedBox(width: 20),
        Expanded(child: customText("${secondString}", style: TextStyle(color: Colors.black54))),
     ]),
          Row(
      children: <Widget>[
       Expanded(child:     TextField(
            enabled: isenable,
            controller: firstController,
            maxLines: maxLine,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
          )
          ),
          SizedBox(width: 20),
          Expanded(child: TextField(
            enabled: isenable,
            controller: secondController,
            maxLines: maxLine,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
          ))
        ],
      ),
        ]));
  }
  void showCalender() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2019, DateTime.now().month, DateTime.now().day),
      firstDate: DateTime(1950, DateTime.now().month, DateTime.now().day + 3),
      lastDate: DateTime.now().add(Duration(days: 7)),
    ) as DateTime;
    setState(() {
      if (picked != null) {
        dob = picked.toString();
        _dob!.text = Utility.getdob(dob as String);
      }
    });
  }

  void _submitButton() {
    if (_firstname!.text.length <= 3 || _firstname!.text.length > 27 ) {
      Utility.customSnackBar(_scaffoldKey as GlobalKey<ScaffoldState>,
          'Name should not be too short or too long');
      return;
    }
    if (_lastname!.text.length <= 3 || _lastname!.text.length > 27 ) {
      Utility.customSnackBar(_scaffoldKey as GlobalKey<ScaffoldState>,
          'Last name should not be too short or too long');
      return;
    }
    if (_state!.text.length == 0) {
      Utility.customSnackBar(_scaffoldKey as GlobalKey<ScaffoldState>,
          'State should not be empty');
      return;
    }
    if (_dob!.text.length == 0) {
      Utility.customSnackBar(_scaffoldKey as GlobalKey<ScaffoldState>,
          'Date of birth should not be empty');
      return;
    }
    if (_country!.text.length == 0 ) {
      Utility.customSnackBar(_scaffoldKey as GlobalKey<ScaffoldState>,
          'Country should not be empty');
      return;
    }
    if (_address!.text.length == 0) {
      Utility.customSnackBar(_scaffoldKey as GlobalKey<ScaffoldState>,
          'Address should not be empty');
      return;
    }
    if (_contact!.text.length == 0) {
      Utility.customSnackBar(_scaffoldKey as GlobalKey<ScaffoldState>,
          'Contact should not be empty');
      return;
    }
    var state = Provider.of<AuthState>(context, listen: false);
   /*
    var model = state.userModel.copyWith(
      userId: state.userModel.userId,
      displayName: state.userModel.displayName,
      
      email: state.userModel.email,
      
      profilePic: state.userModel.profilePic,
     
    );
    */
    loader!.showLoader(context);
    //CircularProgressIndicator(strokeWidth: 2, semanticsLabel: "Updating profile");
    state.UpdateProfile(userId: state.userModel.userId,firstName: _firstname?.text,lastName: _lastname?.text,contact: _contact?.text,
    dob: _dob?.text,country: _country?.text, state: _state?.text, 
    address: _address?.text, philosophy: _philosophy?.text ).then((responseData) {
   userError = responseData["errorData"];
   print("I was called in edit");
   //print(userError);
   var bools = responseData["status"];
   print(bools);
   if(responseData["status"]) {
   loader!.hideLoader();
  Navigator.of(context).pop();

   } else if(responseData["status"] == false && userError.toString().contains("failed")) {
  
           loader!.hideLoader();
           Utility.customSnackBar(_scaffoldKey as GlobalKey<ScaffoldState>,
          userError);
    

   }else {
   
           loader!.hideLoader();
           Utility.customSnackBar(_scaffoldKey as GlobalKey<ScaffoldState>,
          "Please check your network connection and try again");
      
   }
    });
    /*
    if (_name!.text != null && _name!.text.isNotEmpty) {
      model.displayName = _name!.text;
    }
    */
   /* if (_bio!.text != null && _bio!.text.isNotEmpty) {
      model.bio = _bio!.text;
    }
    if (_location!.text != null && _location!.text.isNotEmpty) {
      model.location = _location!.text;
    }
    
    if (dob != null) {
      model.dob = dob as String;
    }
    

  state.updateUserProfile(model,
        image: _image as File, bannerImage: _banner as File);
    Navigator.of(context).pop();
  */
  }

  void uploadImage() {
    openImagePicker(context, (file) {
      setState(() {
        _image = file;
      });
   //   getIt<SharedPreferenceHelper>().saveLinkMediaInfo(UniqueKey().toString(), _image);
    });
  }

  void uploadBanner() {
    openImagePicker(context, (file) {
      setState(() {
        _banner = file;
      });
    });
  }


  void openImagePicker(BuildContext context, Function(File) onImageSelected) async{
 /* Map<Permission, PermissionStatus> statuses = await [
  Permission.storage,
  Permission.camera,
].request();  */
//if(await Permission.storage.request().isGranted) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text(
                'Pick an image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: CustomFlatButton(
                      label: 'Use Camera',
                      borderRadius: 5,
                      onPressed: () {
                        getImage(context, ImageSource.camera, onImageSelected);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomFlatButton(
                      label: 'Use Gallery',
                      borderRadius: 5,
                      onPressed: () {
                        getImage(context, ImageSource.gallery, onImageSelected);
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
//}
  }

  void getImage(BuildContext context, ImageSource source,
      Function(File) onImageSelected) {
    _pickimage.pickImage(source: source, imageQuality: 50).then((file) {
      onImageSelected(File(file!.path)) as Function(dynamic);
      print(file.path);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
      // backgroundColor: Colors.white,
       // iconTheme: IconThemeData(color: Colors.blue),
        title: customTitleText('Profile Edit'),
        actions: <Widget>[
          InkWell(
            onTap: _submitButton,
            child: Center(
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: _body(),
      ),
    );
  }
}
