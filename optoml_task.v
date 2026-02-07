module pipeline_register #(parameter int DATA_WIDTH = 32);
   (input logic clk,
    input logic rst_n,
    
    // Input interface
    input logic in_valid,
    output logic in_ready,
    input logic [DATA_WIDTH-1:0] in_data,
    
    // Output interface
    output logic out_valid,
    input logic out_ready,
    output logic [DATA_WIDTH-1:0] out_data);

    // Internal state register
    logic [DATA_WIDTH-1:0] data_reg;
    logic valid_reg;
    
    // Ready signal: can accept new data when register is empty or being consumed
    assign in_ready = !valid_reg || (out_valid && out_ready);
    
    // Output signals driven by register
    assign out_valid = valid_reg;
    assign out_data  = data_reg;
    
    // State update
    always_ff @(posedge clk or negedge rst_n)
	begin
        if (!rst_n)
		begin
            valid_reg <= 1'b0;
            data_reg  <= 1'b0;
        end
		else
		begin
            // Input handshake fires
			
            if (in_valid && in_ready)
			begin
                data_reg <= in_data;
                valid_reg <= 1'b1;
            end 
            // Output handshake fires without new input
			
            else if (out_valid && out_ready)
			begin
                valid_reg <= 1'b0;
            end
			//Hold current value
			
            else
			begin
                valid_reg <= valid_reg;  
                data_reg <= data_reg;    
            end
        end
    end

endmodule