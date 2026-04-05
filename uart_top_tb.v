`timescale 1ns / 1ns
module uart_top_tb();
    reg CLK;
    reg reset_n;
    wire uart_rx;
    wire uart_tx;
    reg [7:0] tx_data;
    reg send_go;
    wire [7:0]Rx_data;
    wire Rx_done;
    wire [7:0] LED_tx;
    wire [7:0] LED_rx;
    wire LED0_rx;
 uart_top uart_top_inst0(
        .CLK(CLK),
        .reset_n(reset_n),
        .uart_rx(uart_rx),
        .uart_tx(uart_tx),
        .tx_data(tx_data),
        .send_go(send_go),
        .Rx_data(Rx_data),
        .Rx_done(Rx_done),
        .LED_tx(LED_tx),
        .LED_rx(LED_rx),
        .LED0_rx(LED0_rx)
    );
defparam uart_tx.MCNT1=50_000_0-1;
initial CLK=1;
always #10 CLK=~CLK;
assign uart_rx = uart_tx;
initial begin
reset_n=0;
#201;
reset_n=1;
send_go=0;
tx_data=8'b0101_0101;
#30_000_000;
send_go=1;
tx_data=8'b1010_1010;
#30_000_000;
$stop;
end
endmodule
