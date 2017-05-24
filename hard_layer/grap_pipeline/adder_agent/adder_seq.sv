typedef enum {
    ADD_RESULT,
    ADD_INPUTS
} adder_tlm_type;


class adder_tlm extends base_tlm;

    adder_tlm_type tlm_type;

    rand real in_0;
    rand real in_1;
    real out;

    constraint valid {
        in_0 inside{0,65535};
        in_1 inside{0,65535};
    }


    `uvm_object_utils_begin(adder_tlm)
        `uvm_field_enum(adder_tlm_type, tlm_type, UVM_DEFAULT)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "adder_tlm");
        super.new(name);
    endfunction : new

endclass : adder_tlm
