typedef enum {
    PIPELINE_RESULT,
    PIPELINE_INPUTS
} pipeline_tlm_type;


class pipeline_tlm extends base_tlm;

    pipeline_tlm_type tlm_type;

    int camVer [string][string];
    int cam [string][string];
    int cosValues [string][string];
    int senValues [string][string];
    int scale [string][string];
    int trans [string][string];
    int vertex [string][string];

    int outX_sign;
    int outX_exponent;
    int outX_mantissa;

    int outY_sign;
    int outY_exponent;
    int outY_mantissa;

    int outException;

    `uvm_object_utils_begin(pipeline_tlm)
        `uvm_field_enum(pipeline_tlm_type, tlm_type, UVM_DEFAULT)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "pipeline_tlm");
        super.new(name);

        //CamVer Values
        camVer["x"]["sign"] = $urandom_range(0,1);
        camVer["x"]["exponent"] = $urandom_range(5,18);
        camVer["x"]["mantissa"] = $urandom_range(0,1023);

        camVer["y"]["sign"] = $urandom_range(0,1);
        camVer["y"]["exponent"] = $urandom_range(5,18);
        camVer["y"]["mantissa"] = $urandom_range(0,1023);

        camVer["z"]["sign"] = $urandom_range(0,1);
        camVer["z"]["exponent"] = $urandom_range(5,18);
        camVer["z"]["mantissa"] = $urandom_range(0,1023);

        //camDc
        cam["Dc"]["sign"] = $urandom_range(0,1);
        cam["Dc"]["exponent"] = $urandom_range(5,18);
        cam["Dc"]["mantissa"] = $urandom_range(0,1023);

        //Cos Values
        cosValues["Roll"]["sign"] = $urandom_range(0,1);
        cosValues["Roll"]["exponent"] = $urandom_range(5,18);
        cosValues["Roll"]["mantissa"] = $urandom_range(0,1023);

        cosValues["Pitch"]["sign"] = $urandom_range(0,1);
        cosValues["Pitch"]["exponent"] = $urandom_range(5,18);
        cosValues["Pitch"]["mantissa"] = $urandom_range(0,1023);

        cosValues["Yaw"]["sign"] = $urandom_range(0,1);
        cosValues["Yaw"]["exponent"] = $urandom_range(5,18);
        cosValues["Yaw"]["mantissa"] = $urandom_range(0,1023);

        //Sen Values
        senValues["Roll"]["sign"] = $urandom_range(0,1);
        senValues["Roll"]["exponent"] = $urandom_range(5,18);
        senValues["Roll"]["mantissa"] = $urandom_range(0,1023);

        senValues["Pitch"]["sign"] = $urandom_range(0,1);
        senValues["Pitch"]["exponent"] = $urandom_range(5,18);
        senValues["Pitch"]["mantissa"] = $urandom_range(0,1023);

        senValues["Yaw"]["sign"] = $urandom_range(0,1);
        senValues["Yaw"]["exponent"] = $urandom_range(5,18);
        senValues["Yaw"]["mantissa"] = $urandom_range(0,1023);

        //Scale Values
        scale["x"]["sign"] = $urandom_range(0,1);
        scale["x"]["exponent"] = $urandom_range(5,18);
        scale["x"]["mantissa"] = $urandom_range(0,1023);

        scale["y"]["sign"] = $urandom_range(0,1);
        scale["y"]["exponent"] = $urandom_range(5,18);
        scale["y"]["mantissa"] = $urandom_range(0,1023);

        scale["z"]["sign"] = $urandom_range(0,1);
        scale["z"]["exponent"] = $urandom_range(5,18);
        scale["z"]["mantissa"] = $urandom_range(0,1023);

        //Trans Values
        trans["x"]["sign"] = $urandom_range(0,1);
        trans["x"]["exponent"] = $urandom_range(5,18);
        trans["x"]["mantissa"] = $urandom_range(0,1023);

        trans["y"]["sign"] = $urandom_range(0,1);
        trans["y"]["exponent"] = $urandom_range(5,18);
        trans["y"]["mantissa"] = $urandom_range(0,1023);

        trans["z"]["sign"] = $urandom_range(0,1);
        trans["z"]["exponent"] = $urandom_range(5,18);
        trans["z"]["mantissa"] = $urandom_range(0,1023);

        //Vertex Values
        vertex["x"]["sign"] = $urandom_range(0,1);
        vertex["x"]["exponent"] = $urandom_range(5,18);
        vertex["x"]["mantissa"] = $urandom_range(0,1023);

        vertex["y"]["sign"] = $urandom_range(0,1);
        vertex["y"]["exponent"] = $urandom_range(5,18);
        vertex["y"]["mantissa"] = $urandom_range(0,1023);

        vertex["z"]["sign"] = $urandom_range(0,1);
        vertex["z"]["exponent"] = $urandom_range(5,18);
        vertex["z"]["mantissa"] = $urandom_range(0,1023);

  endfunction : new

endclass : pipeline_tlm
