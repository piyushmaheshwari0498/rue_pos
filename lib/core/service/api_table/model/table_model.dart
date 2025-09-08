class TableModel {
  int? status;
  String? result;
  List<Table>? table;
  List<Null>? vehicle;
  int? tableCount;
  int? freeTable;
  int? busyTable;

  TableModel(
      {this.status,
        this.result,
        this.table,
        this.vehicle,
        this.tableCount,
        this.freeTable,
        this.busyTable});

  TableModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    result = json['Result'];
    if (json['Table'] != null) {
      table = <Table>[];
      json['Table'].forEach((v) {
        table!.add(new Table.fromJson(v));
      });
    }
    if (json['Vehicle'] != null) {
      vehicle = <Null>[];
      json['Vehicle'].forEach((v) {
        // vehicle!.add(new Null.fromJson(v));
      });
    }
    tableCount = json['TableCount'];
    freeTable = json['FreeTable'];
    busyTable = json['BusyTable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Result'] = this.result;
    if (this.table != null) {
      data['Table'] = this.table!.map((v) => v.toJson()).toList();
    }
    // if (this.vehicle != null) {
    //   data['Vehicle'] = this.vehicle!.map((v) => v!.toJson()).toList();
    // }
    data['TableCount'] = this.tableCount;
    data['FreeTable'] = this.freeTable;
    data['BusyTable'] = this.busyTable;
    return data;
  }
}

class Table {
  int? floorId;
  String? floorNo;
  List<TbTable>? tbTable;

  Table({this.floorId, this.floorNo, this.tbTable});

  Table.fromJson(Map<String, dynamic> json) {
    floorId = json['FloorId'];
    floorNo = json['FloorNo'];
    if (json['tb_Table'] != null) {
      tbTable = <TbTable>[];
      json['tb_Table'].forEach((v) {
        tbTable!.add(new TbTable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FloorId'] = this.floorId;
    data['FloorNo'] = this.floorNo;
    if (this.tbTable != null) {
      data['tb_Table'] = this.tbTable!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Table(floorId: $floorId, floorNo: $floorNo, tbTable: $tbTable)';
  }
}

class TbTable {
  int? id;
  String? tableNo;
  int? floorId;
  String? floorNo;
  int? noofSeats;
  String? remarks;
  int? status;
  int? sequenceNo;
  double? netAmount;
  double? balanceAmount;
  String? directOrdNo;
  int? directOrdId;

  TbTable(
      {this.id,
        this.tableNo,
        this.floorId,
        this.floorNo,
        this.noofSeats,
        this.remarks,
        this.status,
        this.sequenceNo,
        this.netAmount,
        this.balanceAmount,
        this.directOrdNo,
        this.directOrdId});

  TbTable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tableNo = json['TableNo'];
    floorId = json['FloorId'];
    floorNo = json['FloorNo'];
    noofSeats = json['NoofSeats'];
    remarks = json['Remarks'];
    status = json['Status'];
    sequenceNo = json['SequenceNo'];
    netAmount = json['NetAmount'];
    balanceAmount = json['BalanceAmount'];
    directOrdNo = json['DirectOrdNo'];
    directOrdId = json['DirectOrdId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['TableNo'] = this.tableNo;
    data['FloorId'] = this.floorId;
    data['FloorNo'] = this.floorNo;
    data['NoofSeats'] = this.noofSeats;
    data['Remarks'] = this.remarks;
    data['Status'] = this.status;
    data['SequenceNo'] = this.sequenceNo;
    data['NetAmount'] = this.netAmount;
    data['BalanceAmount'] = this.balanceAmount;
    data['DirectOrdNo'] = this.directOrdNo;
    data['DirectOrdId'] = this.directOrdId;
    return data;
  }

  @override
  String toString() {
    return 'Table(id: $id, tableNo: $tableNo, Status: $status)';
  }
}