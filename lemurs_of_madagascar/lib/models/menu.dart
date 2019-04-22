
class Menu {

  static String _nameKey    = "_menu_name";
  static String _contentKey = "_menu_content";
  static String _idKey      = "_nid";

  String _name;
  String _content;
  int _id;

  Menu(this._name,this._content);
  Menu.withID(this._id, this._name , this._content);

  int get id => _id;
  String get name => _name;
  String get content => _content;

  set name(String value){
      if(value.length <= 255){
        this._name = value;
      }
  }

  set content(String value){
     this._content = value;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    if(_id != null){
      map[_idKey] = this._id;
    }

    map[_nameKey]     = this._name;
    map[_contentKey]  = this._content;
    return map;
  }

  Menu.fromMap(Map<String,dynamic> map) {
    this._id      = map[_idKey];
    this._name    = map[_nameKey];
    this._content = map[_contentKey];
  }


}


