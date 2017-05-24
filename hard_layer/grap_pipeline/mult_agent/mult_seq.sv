typedef enum {
    MULT_RESULT,
    MULT_INPUTS
} mult_tlm_type;


class mult_tlm extends base_tlm;

    mult_tlm_type tlm_type;

    rand real in_0;
    rand real in_1;
    real out;

    constraint valid {
        in_0 inside{0,65535};
        in_1 inside{0,65535};
    }


    `uvm_object_utils_begin(mult_tlm)
        `uvm_field_enum(mult_tlm_type, tlm_type, UVM_DEFAULT)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "mult_tlm");
        super.new(name);
    endfunction : new

endclass : mult_tlm
