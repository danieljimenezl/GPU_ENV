interface uart_ifc();

    base_ifc base();
    logic [7:0] rx_byte;
    logic [7:0] tx_byte;
    logic       rx_ready;
    logic       tx_ready;
    logic       tx_sent;
    logic       rx_error;

endinterface : uart_ifc
