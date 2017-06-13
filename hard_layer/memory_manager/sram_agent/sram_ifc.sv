interface sram_ifc();

    base_ifc base();

    logic [21:0] address;
    logic [15:0] data;
    logic validRequest;
    logic write;
    logic completeRequest;

endinterface : sram_ifc
