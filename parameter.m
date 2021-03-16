function [Voc,Isc,FF,Vmax,Imax,Pmax]= parameter(V,I)
if (size(V,1))>1
    V=V';
end
if (size(I,1))>1
    I=I';
end

[y, index] = unique(-I);  
Voc=interp1(y,V(index),0);
Isc=interp1(V,I,0)*1000;

% I=I(find(V>=0));
% V=V(find(V>=0));
% V=V(find(I>=0));
% I=I(find(I>=0));
% % V=voltage;
% % I=current;

k=size(V,2);
l=size(I,2);
pmax=0;

if(k==l)
    for i=1:1:k
        p(i)=I(i)*V(i);
        if(p(i)>pmax);
            pmax=p(i);
            Vmp=V(i);
            Imp=I(i);
        end
    end
else 
    display('matrix size does not match')
end

Vmax=Vmp;
Imax=Imp*1000;
Pmax=Vmax*Imax;
FF=(Imax*Vmax)/(Voc*Isc);
end
% plot(V,I,'b',V,p,'ro-');
% xlim([0 6])
% ylim([0 .05])
% txt = ['Voc=',num2str(Voc);'y = sin(x)'];
% text(1,0.05,txt)