module uart_top(
    input CLK,
    input reset_n,
    input uart_rx,
    output uart_tx,
    input [7:0] tx_data,
    input send_go,
    output [7:0] Rx_data,
    output Rx_done,
    output  LED_tx,   // 发送模块的LED
    output [7:0] LED_rx,   // 接收模块的LED
    output LED0_rx         // 接收模块的LED0
);
     //例化发送模块
uart_tx uart_tx_inst1(
        .CLK(CLK),
        .reset_n(reset_n),
        .tx_data(tx_data),
        .send_go(send_go),
        .uart_tx(uart_tx),
        .LED_tx(LED_tx)
    );

    // 例化接收模块
    uart_rx uart_rx_inst1(
        .CLK(CLK),
        .reset_n(reset_n),
        .uart_rx(uart_rx),
        .Rx_data(Rx_data),
        .Rx_done(Rx_done),
        .LED_rx(LED_rx),
        .LED0_rx(LED0_rx)
    );

endmodule
