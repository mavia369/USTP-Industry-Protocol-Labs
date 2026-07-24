`timescale 1ns / 1ps

module tb_dma_axi_top;

    parameter ADDR_WIDTH = 32;
    parameter DATA_WIDTH = 64;
    parameter MEM_DEPTH  = 1024;
    
    reg clk;
    reg rst_n;
    
    reg                  dma_start;
    reg  [ADDR_WIDTH-1:0] src_addr;
    reg  [ADDR_WIDTH-1:0] dst_addr;
    reg  [31:0]          transfer_size;
    wire                 dma_done;
    wire                 dma_error;
    
    always #5 clk = ~clk;
    
    dma_axi_top #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .MEM_DEPTH(MEM_DEPTH)
    ) dut (
        .clk           (clk),
        .rst_n         (rst_n),
        .dma_start     (dma_start),
        .src_addr      (src_addr),
        .dst_addr      (dst_addr),
        .transfer_size (transfer_size),
        .dma_done      (dma_done),
        .dma_error     (dma_error)
    );
    
    initial begin
        clk = 0;
        rst_n = 0;
        dma_start = 0;
        src_addr = 32'h0;
        dst_addr = 32'h0;
        transfer_size = 32'h0;
        
        #20;
        rst_n = 1;
        #20;
        
        #50;
        
        src_addr = 32'd0;
        dst_addr = 32'd100;
        transfer_size = 32'd16;
        
        @(posedge clk);
        dma_start = 1;
        @(posedge clk);
        dma_start = 0;
        
        wait(dma_done);
        
        #50;
        
        src_addr = 32'd10;
        dst_addr = 32'd200;
        transfer_size = 32'd64;
        
        @(posedge clk);
        dma_start = 1;
        @(posedge clk);
        dma_start = 0;
        
        wait(dma_done);
        
        #50;
        
        src_addr = 32'd50;
        dst_addr = 32'd300;
        transfer_size = 32'd8;
        
        @(posedge clk);
        dma_start = 1;
        @(posedge clk);
        dma_start = 0;
        
        wait(dma_done);
        
        #20;
        
        src_addr = 32'd0;
        dst_addr = 32'd400;
        transfer_size = 32'd0;
        
        @(posedge clk);
        dma_start = 1;
        @(posedge clk);
        dma_start = 0;
        
        #100;
        
        #100;
        $finish;
    end
    
    initial begin
        $dumpfile("dma_axi_waveform.vcd");
        $dumpvars(0, tb_dma_axi_top);
    end
    
    initial begin
        #50000;
        $finish;
    end

endmodule