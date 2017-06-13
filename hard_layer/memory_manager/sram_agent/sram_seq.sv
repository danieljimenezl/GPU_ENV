typedef enum {
    SRAM_WRITE,
    SRAM_READ
} sram_tlm_type;


class sram_tlm extends base_tlm;

    sram_tlm_type tlm_type;

    int address;
    int data;


    `uvm_object_utils_begin(sram_tlm)
        `uvm_field_enum(sram_tlm_type, tlm_type, UVM_DEFAULT)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "sram_tlm");
        super.new(name);

        data = $urandom_range(0,16'hFFFF);
    endfunction : new

endclass : sram_tlm
