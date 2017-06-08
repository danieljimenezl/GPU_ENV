typedef enum {
    DIV_RESULT,
    DIV_INPUTS
} divider_tlm_type;


class divider_tlm extends base_tlm;

    divider_tlm_type tlm_type;

    int in0_sign;
    int in0_exponent;
    int in0_mantissa;

    int in1_sign;
    int in1_exponent;
    int in1_mantissa;

    int out_sign;
    int out_exponent;
    int out_mantissa;


    `uvm_object_utils_begin(divider_tlm)
        `uvm_field_enum(divider_tlm_type, tlm_type, UVM_DEFAULT)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "divider_tlm");
        super.new(name);
 
        in0_sign = $urandom_range(0,1);
        in0_exponent = $urandom_range(0,31);
        in0_mantissa = $urandom_range(0,1023);

        in1_sign = $urandom_range(0,1);
        in1_exponent = $urandom_range(0,31);
        in1_mantissa = $urandom_range(0,1023);
    endfunction : new


endclass : divider_tlm
