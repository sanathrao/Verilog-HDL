//State machine based verification cannot support today's verification needs


always@(posedge clk)
case(state)
READ: if(i<No_of_reads)
begin
read_write=0;
address=$random;
i=i+1;
end

else
$finish

WRITE:if(j<no_of_writes)
begin
read_write=1;
address=$random;
data=$random;
j=j+1;
end

else
state=READ;
endcase


initial 
begin
no_of_reads=0;
no_of_writes=10;
end

initial
begin
no_of_reads=10;
no_of_writes=0;
end
