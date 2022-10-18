function result=totalgray(I,fig)
% fig=='r',输出红色图像
% fig=='b'，输出蓝色图像
% 其它，不输入图像

[r,~]=find(I<200);
% 获得个数,总的迹线像素点的个数
result=length(r);
sliceWide=5;
sliceNum=fix(size(I,2)/sliceWide);
sliceDensity=zeros(1,sliceNum);
for i=1:sliceNum
    Slice=I(:,(i-1)*sliceWide+1:i*sliceWide);
    [r,~]=find(Slice==0);
    sliceDensity(i)=length(r);
end
x=1:sliceNum;
if strcmp('r',fig)
    figure;
    bar(x,sliceDensity,'r');
    set(gca,'ylim',[0 100]);
    xlabel('x');
    ylabel('gray statistic');
end
if strcmp('b',fig)
    figure;
    bar(x,sliceDensity,'b');
    set(gca,'ylim',[0 100]);
    xlabel('x');
    ylabel('gray statistic');
end