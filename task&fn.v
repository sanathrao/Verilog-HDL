/*Task based test benches

Task based test benches are more flexible over all other approaches.
Task based Bus functional model is extremely efficient under multiple calculations.
Tasks makes it possible to describe structural testbenches*/

task write(input integer data,input integer address);
begin
@(posedge clk); //Delay till posedge
read_write=1;
address=$random;
data=$random;
end
endtask

task read(input integer address,output integer data);
begin
@(posedge clk);
read_write=0;
address=$random
end
endtask

//Scenarios

initial 
repeat(10)

write($random.$random);


initial 
repeat(10)
read($random,data)

initial 
repeat(10)
begin
write($random,$random);
read($random,data);
end

initial 
begin
write(10,20);
read(10,data);
end
