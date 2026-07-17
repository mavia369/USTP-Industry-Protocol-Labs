`timescale 1ns/1ps

module tb;

logic        PCLK;
logic        PRESETn;

logic [31:0] PADDR;
logic [31:0] PWDATA;
logic [31:0] PRDATA;

logic        PSEL;
logic        PENABLE;
logic        PWRITE;

logic        PREADY;
logic        PSLVERR;

//DUT

apb_slave dut(

.PCLK(PCLK),
.PRESETn(PRESETn),

.PADDR(PADDR),
.PWDATA(PWDATA),
.PRDATA(PRDATA),

.PSEL(PSEL),
.PENABLE(PENABLE),
.PWRITE(PWRITE),

.PREADY(PREADY),
.PSLVERR(PSLVERR)

);

//Clock

initial
begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;
end

//Waveform Dump

initial
begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
end

//APB Write Task

task apb_write(input [31:0] addr,
               input [31:0] data);

begin

    @(posedge PCLK);

    PADDR   <= addr;
    PWDATA  <= data;
    PWRITE  <= 1;
    PSEL    <= 1;
    PENABLE <= 0;

    @(posedge PCLK);

    PENABLE <= 1;

    @(posedge PCLK);

    PSEL    <= 0;
    PENABLE <= 0;
    PWRITE  <= 0;

    $display("WRITE Address=%h Data=%h",addr,data);

end

endtask

//APB Read Task

task apb_read(input [31:0] addr);

begin

    @(posedge PCLK);

    PADDR   <= addr;
    PWRITE  <= 0;
    PSEL    <= 1;
    PENABLE <= 0;

    @(posedge PCLK);

    PENABLE <= 1;

    @(posedge PCLK);

    $display("READ Address=%h Data=%h",addr,PRDATA);

    PSEL    <= 0;
    PENABLE <= 0;

end

endtask

//Test Sequence

initial
begin

    PRESETn = 0;

    PADDR   = 0;
    PWDATA  = 0;

    PSEL    = 0;
    PENABLE = 0;
    PWRITE  = 0;

    #20;

    PRESETn = 1;

    //Write Tests

    apb_write(32'h00000000,32'h11111111);
    apb_write(32'h00000004,32'h22222222);
    apb_write(32'h00000008,32'h33333333);
    apb_write(32'h0000000C,32'h44444444);

    //Read Tests

    apb_read(32'h00000000);
    apb_read(32'h00000004);
    apb_read(32'h00000008);
    apb_read(32'h0000000C);

    #20;

    $finish;

end

endmodule