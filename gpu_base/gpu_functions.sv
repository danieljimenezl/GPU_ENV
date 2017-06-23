//--------------------------------------------
// Report in log files
function void gpu_log(integer file, string component, string MSG);
    if(file)
        $fwrite(file,$psprintf("%s \t -------> %0dns \t: %s\n",component,$time,MSG));
endfunction : gpu_log
