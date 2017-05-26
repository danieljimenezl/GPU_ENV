typedef enum {
    MULT_RESULT,
    MULT_INPUTS
} mult_tlm_type;


class mult_tlm extends base_tlm;

    mult_tlm_type tlm_type;

    rand int in0_sign;
    rand int in0_exponent;
    rand int in0_mantissa;

    rand int in1_sign;
    rand int in1_exponent;
    rand int in1_mantissa;

    int out_sign;
    int out_exponent;
    int out_mantissa;

    constraint valid {
        in0_sign inside {0,2};
        in0_exponent inside {0,32};
        in0_mantissa inside {0,1024};

        in1_sign inside {0,2};
        in1_exponent inside {0,32};
        in1_mantissa inside {0,1024};
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
