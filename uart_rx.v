module uart_rx(
       CLK,
       reset_n,
       uart_rx,
       Rx_data,
       Rx_done,
       LED_rx,
       LED0_rx
);
       input CLK;
       input reset_n;
       input uart_rx;
       output reg [7:0] Rx_data;
       output reg Rx_done;
       output reg [7:0] LED_rx;
       output reg LED0_rx;
       reg [12:0] counter0;
       reg [3:0] counter1;
       reg [7:0] r_Rx_data;
       reg r_uart_rx;
       reg en_counter0;
       reg diff0;
       reg diff1;
       wire w_Rx_done;
       wire negedge_start;
       parameter BAUD=9600;
       parameter CLOCK=50_000_000;
       parameter BAUD_MCNT=CLOCK/BAUD-1;
       parameter BAUD_MCNT1=CLOCK/(BAUD*2)-1;
//波特率计数器
always@(posedge CLK or negedge reset_n)
       if(!reset_n)
           counter0<=0; 
       else if(en_counter0)begin
           if(counter0==BAUD_MCNT)
              counter0<=0;
           else 
               counter0<=counter0+1;   
       end
       else
           counter0<=0;
//波特率计数器使能装置
always@(posedge CLK or negedge reset_n)
       if(!reset_n)
          en_counter0<=0;
       else if(negedge_start==1)
          en_counter0<=1'd1;
       else if((counter1==0) && (counter0==BAUD_MCNT1) && (uart_rx==1))
          en_counter0<=0;
       else if(w_Rx_done==1)
          en_counter0<=0;
//位计数器
always@(posedge CLK or negedge reset_n)
       if(!reset_n)
          counter1<=0;
       else if((counter1==9) && (counter0==BAUD_MCNT1))
             counter1<=0;
       else if(counter0==BAUD_MCNT)
             counter1<=counter1+1'd1;
//结束控制器
assign w_Rx_done=((counter1==9) && (counter0==BAUD_MCNT1));
always@(posedge CLK or negedge reset_n)
       Rx_done<=w_Rx_done;
//防亚稳态装置
always@(posedge CLK or negedge reset_n)
       diff0<=uart_rx;
always@(posedge CLK or negedge reset_n)
       diff1<=diff0;
always@(posedge CLK or negedge reset_n)
       r_uart_rx<=diff1;
       
assign negedge_start=((diff1==0) && (r_uart_rx==1));       
//位接收逻辑
always@(posedge CLK or negedge reset_n)
       if(!reset_n)
          r_Rx_data<=0;
       else if(en_counter0==0)
          r_Rx_data<=0;
       else if(counter0==BAUD_MCNT1)begin
          case(counter1)
            1:r_Rx_data[0]<=r_uart_rx;
            2:r_Rx_data[1]<=r_uart_rx;
            3:r_Rx_data[2]<=r_uart_rx;
            4:r_Rx_data[3]<=r_uart_rx;
            5:r_Rx_data[4]<=r_uart_rx;
            6:r_Rx_data[5]<=r_uart_rx;
            7:r_Rx_data[6]<=r_uart_rx;
            8:r_Rx_data[7]<=r_uart_rx;
            default:Rx_data<=Rx_data;
         endcase
      end
      
always@(posedge CLK or negedge reset_n)
       if(!reset_n)
          Rx_data<=0;
       else if(w_Rx_done==1)
          Rx_data<=r_Rx_data;
//LED闪烁装置
always@(posedge CLK or negedge reset_n)
       if(!reset_n)
          LED_rx<=0;
       else if(w_Rx_done==1)
          LED_rx<=r_Rx_data;
//LED翻转装置
always@(posedge CLK or negedge reset_n)
       if(!reset_n)
          LED0_rx<=0;
       else if(w_Rx_done==1)
          LED0_rx<=~LED0_rx;
endmodule
