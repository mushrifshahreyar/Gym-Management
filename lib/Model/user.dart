class User {
  int? _id;
  String? _name;
  String? _address;
  String? _phoneNo;
  String? _plan;
  String? _session;
  DateTime? _startdate;
  double? _totalAmount;

  User(this._id, this._name, this._address, this._phoneNo, this._plan,
      this._session, this._totalAmount, this._startdate);

  User.newInstance();
  //setter
  set id(int? id) {
    _id = id;
  }

  set name(String? name) {
    _name = name;
  }

  set address(String? address) {
    _address = address;
  }

  set phoneno(String? phoneno) {
    _phoneNo = phoneno;
  }

  set plan(String? plan) {
    _plan = plan;
  }

  set session(String? session) {
    _session = session;
  }

  set totalAmount(double? amount) {
    _totalAmount = amount;
  }

  set startDate(DateTime? currentdate) {
    _startdate = currentdate;
  }

  //getter
  int? get id => _id;

  String? get name => _name;

  String? get address => _address;

  String? get phoneno => _phoneNo;

  String? get plan => _plan;

  String? get session => _session;

  double? get totalamount => _totalAmount;

  DateTime? get startdate => _startdate;
}
