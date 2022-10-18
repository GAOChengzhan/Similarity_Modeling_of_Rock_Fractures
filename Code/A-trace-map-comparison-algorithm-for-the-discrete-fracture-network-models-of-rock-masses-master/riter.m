function [yitagrade]=riter(Mhtdist)
xx=0:0.001:1;
n=zeros(1,length(xx));
index=0;
tmp=1;
for i=1:length(xx)
    n(i)=1-length(find(Mhtdist>=1-xx(i)))/73;
    
    if abs(n(i)-xx(i))<tmp
        tmp=abs(xx(i)-n(i));
        index=i;
    end
end
yitagrade=xx(index);
figure;
plot(xx,n,'r');
hold on;
plot(xx,xx,'b');
