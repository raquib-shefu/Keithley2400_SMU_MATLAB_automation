close all;clearvars;clc;tic;
%user input
start=input('Start Voltage:');
stop=input('Stop voltage:');
step=input('Enter voltage step for sweep:');
point=((stop-start)/step)+1;

%%initialize serial object
info = instrhwinfo('serial');
if isempty(info.AvailableSerialPorts)
   error('No ports free!');
end
s = serial(info.AvailableSerialPorts{1}, 'BaudRate', 9600);
fopen(s);
%%open text file
fileID1 = fopen('Voltage_sweep.txt','w');
%%%SCPI command for analyzer
fprintf(s,'*RST')
fprintf(s,':SENS:FUNC:CONC OFF')
fprintf(s,'SOUR:FUNC VOLT') 
fprintf(s,'SENS:FUNC "CURR:DC"') %measure current 
fprintf(s,'SENS:CURR:PROT .1') %max curr in A
fprintf(s,'SOUR:VOLT:MODE SWE')
%fprintf(s,'SOUR:VOLT:MODE LIST')
%fprintf(s,'SOUR:LIST:VOLT 1,2,3,4,5,10')
fprintf(s,'SOUR:SWE:RANG AUTO')  
fprintf(s,'SOUR:SWE:SPAC LIN') %selecting Linear sweep
fprintf(s,'SOUR:DEL 0.1') 
fprintf(s,'OUTP on') %make KSM on
n=10;%no of data 1 time at buffer
ie=ceil(point/n);% change numerator for how many data goes in KSM per loop
startloop=start;
for i=1:ie
    begin=startloop;
    finish=begin+step*1*(n-1);
    trigpoint=((finish-begin)/step)+1;
    fprintf(s,['SOUR:VOLT:START ',num2str(begin)])
    fprintf(s,['SOUR:VOLT:STOP ',num2str(finish)])
    fprintf(s,['SOUR:VOLT:STEP ',num2str(step)])
    fprintf(s,['TRIG:COUN ',num2str(trigpoint)])
    fprintf(s,':FORM:ELEM CURR')
    fprintf(s,':READ?')
    val = fscanf(s);   
    fprintf(fileID1,'%s\n',val);
      startloop=finish+step;  
end 
fprintf(s,'OUTP OFF')
fclose(s);
time_elapsed=toc
fclose(fileID1);
load Voltage_sweep.txt

D=Voltage_sweep;
x=start;
for i=1:point
  V(i)=x;
    x=x+step;
    X=transpose(D);
    D=X(:)';
     I(i)=D(i);
end
plot(V,-I)
[Voc,Isc,FF,Vmax,Imax,Pmax]=parameter(V,-I)
xlabel('Voltage(V)','fontweight','bold','fontsize',16)
ylabel('Current (A)','fontweight','bold','fontsize',16)
savefig('voltage_sweep.fig')
