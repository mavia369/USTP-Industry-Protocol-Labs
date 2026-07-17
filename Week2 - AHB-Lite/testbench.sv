`timescale 1ns/1ps

module tb;

logic        HCLK;
logic        HRESETn;

logic [31:0] HADDR;
logic [31:0] HWDATA;
logic [31:0] HRDATA;

logic [1:0]  HTRANS;

logic        HWRITE;
logic        HSEL;
logic        HREADYOUT;

// DUT

ahb_slave dut(

.HCLK(HCLK),
.HRESETn(HRESETn),

.HADDR(HADDR),
.HWDATA(HWDATA),
.HRDATA(HRDATA),

.HTRANS(HTRANS),
.HWRITE(HWRITE),
.HSEL(HSEL),

.HREADYOUT(HREADYOUT)

);

// Clock Generation

initial
begin
    HCLK = 0;
    forever #5 HCLK = ~HCLK;
end

// Waveform Dump

initial
begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb);
end

// AHB Write Task

task ahb_write(
    input [31:0] addr,
    input [31:0] data
);

begin

    @(posedge HCLK);

    HADDR  <= addr;
    HWDATA <= data;

    HWRITE <= 1'b1;
    HSEL   <= 1'b1;

    // NONSEQ Transfer
    HTRANS <= 2'b10;

    @(posedge HCLK);

    HSEL   <= 1'b0;
    HWRITE <= 1'b0;
    HTRANS <= 2'b00;

    $display("WRITE Addr=%h Data=%h",
              addr,data);

end

endtask

// AHB Read Task

task ahb_read(
    input [31:0] addr
);

begin

    @(posedge HCLK);

    HADDR  <= addr;

    HWRITE <= 1'b0;
    HSEL   <= 1'b1;

    HTRANS <= 2'b10;

    @(posedge HCLK);

    $display("READ Addr=%h Data=%h",
              addr,HRDATA);

    HSEL   <= 1'b0;
    HTRANS <= 2'b00;

end

endtask

// Test Cases

initial
begin

    HRESETn = 0;

    HADDR   = 0;
    HWDATA  = 0;

    HSEL    = 0;
    HWRITE  = 0;
    HTRANS  = 0;

    #20;

    HRESETn = 1;

    // Write Transactions

    ahb_write(
        32'h00000000,
        32'hAAAAAAAA
    );

    ahb_write(
        32'h00000004,
        32'hBBBBBBBB
    );

    ahb_write(
        32'h00000008,
        32'hCCCCCCCC
    );

    ahb_write(
        32'h0000000C,
        32'hDDDDDDDD
    );

    // Read Transactions

    ahb_read(32'h00000000);
    ahb_read(32'h00000004);
    ahb_read(32'h00000008);
    ahb_read(32'h0000000C);

    #20;

    $finish;

end

endmodule