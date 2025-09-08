class PrinterList {
  int? status;
  String? result;
  List<Printer>? printer;

  PrinterList({this.status, this.result, this.printer});

  PrinterList.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    result = json['Result'];
    if (json['Printer'] != null) {
      printer = <Printer>[];
      json['Printer'].forEach((v) {
        printer!.add(new Printer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Result'] = this.result;
    if (this.printer != null) {
      data['Printer'] = this.printer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Printer {
  int? printerId;
  String? printerName;
  String? modelName;
  String? typeName;
  String? portName;
  String? printerIP;
  String? emulation;

  Printer(
      {this.printerId,
      this.printerName,
      this.modelName,
      this.typeName,
      this.portName,
      this.printerIP,
      this.emulation});

  Printer.fromJson(Map<String, dynamic> json) {
    printerId = json['PrinterId'];
    printerName = json['PrinterName'];
    modelName = json['ModelName'];
    typeName = json['TypeName'];
    portName = json['PortName'];
    printerIP = json['PrinterIP'];
    emulation = json['Emulation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PrinterId'] = this.printerId;
    data['PrinterName'] = this.printerName;
    data['ModelName'] = this.modelName;
    data['TypeName'] = this.typeName;
    data['PortName'] = this.portName;
    data['PrinterIP'] = this.printerIP;
    data['Emulation'] = this.emulation;
    return data;
  }
}
