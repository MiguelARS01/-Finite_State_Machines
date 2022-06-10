
module Maquina_estados(entrada,clock,reset,saida);
    //Inputs e Outputs
    input clock;
    input reset;
    input[7:0] entrada; 
    output reg[3:0] saida;

    //Valor dos estados
    parameter   
            Inicial =        0,
            C1 =             1,
            C2 =             2,
            C3 =             3,
            C4 =             4,
            C5 =             5,
            Saida1 =         6,
            Saida2 =         8,
            Saida_invalida = 7;

    //Declara o estado atual e próximo
    reg  [7:0] estado_atual;
    reg  [7:0] proximo_estado;

//Parte sequencial
always @(posedge clock, posedge reset)
    begin     
    if(reset) 
        estado_atual = Inicial;
    else 
        estado_atual = proximo_estado; 
    end 

//Parte combinacional 
always @(estado_atual , entrada)
    begin
        proximo_estado = estado_atual;
    case(estado_atual)
    Inicial:begin
        if(entrada==8'b10100000)
            proximo_estado = C1; 
        if(entrada==8'b10000100)
            proximo_estado = C2;
        if(entrada==8'b10111100)
            proximo_estado = C3;
        if(entrada==8'b10011010)
            proximo_estado = C4;
        if (entrada==8'b10101110)
            proximo_estado = C5;
    end
    C1:begin
        
        if(entrada==8'b10000100)    
            proximo_estado = C2;
        if(entrada==8'b10111100)
            proximo_estado = Saida_invalida; //C3  
        if(entrada==8'b10011010)
            proximo_estado = Saida_invalida; //C4
        if(entrada==8'b10101110)
            proximo_estado = Saida_invalida; //C5
        if(entrada==8'b10110101)
            proximo_estado = Saida_invalida; 
        if(entrada==8'b10001001)
            proximo_estado = Saida1;
    end
    C2:begin
        
        if(entrada==8'b10111100)
            proximo_estado = C3;
        if(entrada==8'b10100000)
            proximo_estado = C1;
        if(entrada==8'b10011010)
            proximo_estado = Saida_invalida; //C4
        if(entrada==8'b10101110)
            proximo_estado = Saida_invalida; //C5
        if(entrada==8'b10110101)
            proximo_estado = Saida_invalida;
        if(entrada==8'b10001001)
            proximo_estado = Saida1;
        end 
    C3:begin
        if (entrada==8'b10100000)
            proximo_estado = Saida_invalida; // C1
        if(entrada==8'b10000100)
            proximo_estado = C2;             
        if(entrada==8'b10011010)
            proximo_estado=C4;               
        if(entrada==8'b10101110)
            proximo_estado= Saida_invalida;  // C5
        if(entrada==8'b10001001)
            proximo_estado = Saida1;         
        if(entrada==8'b10110101)
            proximo_estado=Saida_invalida;   
        end
    C4:begin
        
        if(entrada==8'b10100000)
            proximo_estado=Saida_invalida; //C1
        if(entrada==8'b10000100)
            proximo_estado=Saida_invalida; //C2
        if(entrada==8'b10111100)
            proximo_estado=C3;
        if(entrada==8'b10101110)
            proximo_estado=C5;
        if(entrada==8'b10010011)
            proximo_estado=Saida2;
        if(entrada==8'b10110101)
            proximo_estado=Saida_invalida;
        end
    C5:begin
        
        if(entrada==8'b10100000)
            proximo_estado=Saida_invalida; //C1
        if(entrada==8'b10000100)
            proximo_estado=Saida_invalida; //C2
        if(entrada==8'b10111100)
            proximo_estado=Saida_invalida; //C3
        if(entrada==8'b10011010)
            proximo_estado=C4;
        if(entrada==8'b10010011)
            proximo_estado=Saida2;
        if(entrada==8'b10110101)
            proximo_estado=Saida_invalida;
        end
    endcase 
end

    //Define as saídas de cada estado
    always@(estado_atual) begin
        case(estado_atual) 
            Inicial: saida = 4'b0000;
            C1:  saida = 4'b0001; 
            C2:  saida = 4'b0010; 
            C3:  saida = 4'b0011;
            C4:  saida = 4'b0100; 
            C5:  saida = 4'b0101; 
            Saida1: saida = 4'b1001; 
            Saida_invalida: saida = 4'b1000;
            Saida2: saida = 4'b1010;
        endcase
    end 
endmodule

module testbench; //testbench
 // Inputs
 reg [7:0]entrada;
 reg clock;
 reg reset;
 // Outputs
 wire [3:0]saida;
 
 Maquina_estados uut (.entrada(entrada), .clock(clock), .reset(reset), .saida(saida)); //chamada da função
 
 initial begin //funcionamento do clock
    clock = 0;
    forever #10 clock = ~clock;
 end 

 initial begin
    $display("\nInicial => C1 => C2 => C3 => C4 => C5 => C4 => C3 => C2 => C1 => Saida1"); //entradas
    entrada = 0;
    reset = 1; //reseta a máquina
    #10; reset = 0; //começa a percorrer os estados
    #20; entrada = 8'b10100000; //C1
    #20; entrada = 8'b10000100; //C2
    #20; entrada = 8'b10111100; //C3
    #20; entrada = 8'b10011010; //C4
    #20; entrada = 8'b10101110; //C5
    #20; entrada = 8'b10011010; //C4
    #20; entrada = 8'b10111100; //C3
    #20; entrada = 8'b10000100; //C2
    #20; entrada = 8'b10100000; //C1
    #20; entrada = 8'b10001001; //Saida1
    #20; $finish;

    /*$display("\nInicial => C5 => C4 => C3 => C2 => C1 => C2 => C3 => C4 => C5 => Saida2"); //entradas
    entrada = 0;
    reset = 1; //reseta a máquina
    #10; reset = 0; //começa a percorrer os estados
    #20; entrada = 8'b10101110; //C5
    #20; entrada = 8'b10011010; //C4
    #20; entrada = 8'b10111100; //C3
    #20; entrada = 8'b10000100; //C2
    #20; entrada = 8'b10100000; //C1
    #20; entrada = 8'b10000100; //C2
    #20; entrada = 8'b10111100; //C3
    #20; entrada = 8'b10011010; //C4
    #20; entrada = 8'b10101110; //C5
    #20; entrada = 8'b10010011; //Saida2
    #20; $finish;*/
    
    /*$display("\nInicial => C5 => C4 => C2 => Saida_Invalida"); //entradas
    entrada = 0;
    reset = 1; //reseta a máquina
    #10; reset = 0; //começa a percorrer os estados
    #20; entrada = 8'b10101110; //C5
    #20; entrada = 8'b10011010; //C4
    #20; entrada = 8'b10000100; //C2
    #20; $finish;*/

 end

 initial begin
            $display("====================="); //imprime as saídas de cada estado no terminal
            $display("| ENTRADA  || SAIDA |");
            $monitor("| %8b ||  %4b |",entrada,saida);
    end 
endmodule