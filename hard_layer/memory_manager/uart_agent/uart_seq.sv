typedef enum {
    UART_GPU_INPUT,
    UART_GPU_OUTPUT
} uart_tlm_type;

typedef enum {
    INITIALIZE  =   'hAAAA,
    ENABLE      =   'hCCCC,
    CAM_CONFIG  =   'hBBBB,
    CREATE_OBJ  =   'hEEEE,
    ADD_VERT    =   'h9999,
    CLOSE_OBJ   =   'h8888,
    MODIFY_OBJ  =   'hABCD,
    REFRESH     =   'h1234,
    ERROR       =   'h1414,
    BUSY        =   'h4141,
    END         =   'hFFFF,
    DATA        =   'h1111,
    COMPL       =   'h2222
} uart_tlm_cmd;

class uart_tlm extends base_tlm;

    rand uart_tlm_type tlm_type;
    rand uart_tlm_cmd tlm_cmd;

    rand shortint data;

    constraint valid {
        data inside {[0:32'hFFFF]};
    }

    `uvm_object_utils_begin(uart_tlm)
        `uvm_field_enum(uart_tlm_type, tlm_type, UVM_DEFAULT)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "uart_tlm");
        super.new(name);
    endfunction : new

endclass : uart_tlm
