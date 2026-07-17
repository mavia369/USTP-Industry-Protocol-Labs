`timescale 1ns/1ps

module apb_slave(

    input  logic        PCLK,
    input  logic        PRESETn,

    input  logic [31:0] PADDR,
    input  logic [31:0] PWDATA,

    input  logic        PSEL,
    input  logic        PENABLE,
    input  logic        PWRITE,

    output logic [31:0] PRDATA,
    output logic        PREADY,
    output logic        PSLVERR

);

logic [31:0] reg0;
logic [31:0] reg1;
logic [31:0] reg2;
logic [31:0] reg3;

//Write Logic

always_ff @(posedge PCLK or negedge PRESETn)
begin

    if(!PRESETn)
    begin
        reg0 <= 32'd0;
        reg1 <= 32'd0;
        reg2 <= 32'd0;
        reg3 <= 32'd0;
    end

    else if(PSEL && PENABLE && PWRITE)
    begin

        case(PADDR)

            32'h00000000 : reg0 <= PWDATA;
            32'h00000004 : reg1 <= PWDATA;
            32'h00000008 : reg2 <= PWDATA;
            32'h0000000C : reg3 <= PWDATA;

        endcase

    end

end

//Read Logic

always_comb
begin

    PRDATA = 32'd0;

    if(PSEL && !PWRITE)
    begin

        case(PADDR)

            32'h00000000 : PRDATA = reg0;
            32'h00000004 : PRDATA = reg1;
            32'h00000008 : PRDATA = reg2;
            32'h0000000C : PRDATA = reg3;

            default : PRDATA = 32'd0;

        endcase

    end

end

assign PREADY  = 1'b1;
assign PSLVERR = 1'b0;

endmodule