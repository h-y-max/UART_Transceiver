module uart_tx(
       CLK,
       reset_n,
       tx_data,
       send_go,
       uart_tx,
       LED_tx
);
       input CLK;
       input reset_n;
       input [7:0] tx_data;
       input send_go;
       output reg uart_tx;
       output reg LED_tx;
       reg [12:0] counter0;
       reg [3:0]  counter1;
       reg [25:0] counter2;
       reg en_counter0;
       reg [7:0] r_data_tx;
       reg send_go_pluse;
       reg r_send_go;
       wire over;
       wire send_go;
       parameter Baud=9600;
       parameter CLOCK=50_000_000;
       parameter MCNT1=50_000_000-1;
       parameter MCNT0=CLOCK/Baud-1;
//波特率计数器
       always@(posedge CLK or negedge reset_n)
            if(!reset_n)
               counter0<=0;
            else if(en_counter0)begin
               if(counter0==MCNT0)
                   counter0<=0;
               else
                   counter0<=counter0+1'd1;
            end
            else
                counter0<=0;
//位计数器
      always@(posedge CLK or negedge reset_n)
            if(!reset_n)
               counter1<=0;
            else if(counter0==MCNT0)begin
               if(counter1==9)
                   counter1<=0;
               else
                   counter1<=counter1+1'd1;
            end
            else
                 counter1<=counter1;
//延时计数器
       always@(posedge CLK or negedge reset_n)
            if(!reset_n)
                counter2<=0;
            else if(send_go_pluse==0)begin
                if(counter2==MCNT1)
                    counter2<=0;
                else
                    counter2<=counter2+1'd1;
            end
            else
                counter2<=0;
//用户自动控制装置
       always@(posedge CLK or negedge reset_n)
            if(!reset_n)
               r_send_go<=0;
            else
               r_send_go<=send_go;
       
       always@(posedge CLK or negedge reset_n)
            if(!reset_n)
                send_go_pluse<=0;
            else if((send_go==1) && (r_send_go==0))
                send_go_pluse<=1;
            else 
                send_go_pluse<=0;
//波特率使能装置
      assign over=((counter1==9) && (counter0==MCNT0));
      always@(posedge CLK or negedge reset_n)
            if(!reset_n)
               en_counter0<=0;
            else if(counter2==MCNT1|send_go_pluse==1)
               en_counter0<=1'd1;
            else if(over)
               en_counter0<=0;
 //存储器
       always@(posedge CLK or negedge reset_n)
            if(!reset_n)
                r_data_tx<=0;
            else 
                r_data_tx<=tx_data;
//位接收逻辑
      always@(posedge CLK or negedge reset_n)
            if(!reset_n)
                uart_tx<=1;
            else if(en_counter0==0)
                uart_tx<=1;
            else begin
                 case(counter1)
                 0:uart_tx<=0;
                 1:uart_tx<=r_data_tx[0];
                 2:uart_tx<=r_data_tx[1];
                 3:uart_tx<=r_data_tx[2];
                 4:uart_tx<=r_data_tx[3];
                 5:uart_tx<=r_data_tx[4];
                 6:uart_tx<=r_data_tx[5];
                 7:uart_tx<=r_data_tx[6];
                 8:uart_tx<=r_data_tx[7];
                 9:uart_tx<=1'd1;
                 default:uart_tx<=uart_tx;
                 endcase
             end
//LED翻转逻辑
       always@(posedge CLK or negedge reset_n)
              if(!reset_n) 
                 LED_tx<=0;
              else if(over)
                 LED_tx<=~LED_tx;
              else
                 LED_tx<=LED_tx;
endmodule          
                 
                 
               
