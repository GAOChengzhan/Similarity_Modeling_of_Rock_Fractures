function Y=bezier(y)
%Bezier Curve 
% figure;
% plot(1:length(y),y,'color',[0.1 0.2 0.5],'marker','o');
% hold on;
x=1:length(y);
n=length(y);
t=0:0.001:1;
A=0;B=0;
for k=0:n-1
    tmp=nchoosek(n-1,k)*t.^k.*(1-t).^(n-1-k);
    A=A+tmp*x(k+1);
    B=B+tmp*y(k+1);
end

%figure;
% plot(A,B,'color',[0.2 0.5 0.1]);
Y=zeros(1,length(y));
Y(1)=y(1);
for i=2:length(y)-1
    position=round(length(t)/(length(y)-1)*(i-1));
    Y(i)=B(position);
end
Y(end)=y(end);

% plot(1:length(y),Y,'color',[0.7 0.2 0.1],'marker','+');
% xlabel('x');
% ylabel('y');