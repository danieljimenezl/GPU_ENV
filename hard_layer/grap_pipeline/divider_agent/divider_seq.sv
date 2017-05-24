typedef enum {
    DIV_RESULT,
    DIV_INPUTS
} divider_tlm_type;


class divider_tlm extends base_tlm;

    divider_tlm_type tlm_type;

    rand real in_0;
    rand real in_1;
    real out;

    constraint valid {
        in_0 inside{0,65535};
        in_1 inside{0,65535};
    }


    `uvm_object_utils_begin(divider_tlm)
        `uvm_field_enum(divider_tlm_type, tlm_type, UVM_DEFAULT)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "divider_tlm");
        super.new(name);
    endfunction : new


endclass : divider_tlm
