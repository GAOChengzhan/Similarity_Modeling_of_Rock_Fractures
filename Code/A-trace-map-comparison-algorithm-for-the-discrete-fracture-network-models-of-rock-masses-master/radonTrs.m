function [varians,curves,fdegrees]=radonTrs(I)
% density Radon transform
IBack=zeros(size(I)); % 做背景矩阵,与 I 同时旋转，叠加计算
limit=min([size(I,2) size(I,1)]);

step=15;
varians=zeros(1,180/step);
curves=cell(1,fix(180/step));
sliceWide=5;   % 切片的宽度， 最少为迹线的宽度
for i=step:step:180   % 减 1 是因为 180 度和 0 度是一样的
    tempI=~I; tempIBack=~IBack;
    tempI=imrotate(tempI,i); tempIBack=imrotate(tempIBack,i);
    tempI=~tempI;tempIBack=~tempIBack;
    % 开始切片计算
    sliceNum=fix(size(tempI,2)/sliceWide);  % 切片的数量
    sliceDensity=zeros(1,sliceNum);     %  切片的相对灰度密度
    
    tmp=zeros(1,sliceNum); % 消除边缘影响用
    for j=1:sliceNum
        SliceI=tempI(:,(j-1)*sliceWide+1:j*sliceWide);
        SliceIBack=tempIBack(:,(j-1)*sliceWide+1:j*sliceWide);
        [r1,~]=find(SliceI==0);
        [r2,~]=find(SliceIBack==0);
        if length(r2)>0 
         sliceDensity(j)=length(r1)/length(r2);
        end
        tmp(j)=length(r2);
    end
    % 密度曲线 消除边缘影响
    leftnode=0;
    tmpsum=0;
    for k=1:sliceNum
        if tmpsum>limit*sliceWide
            leftnode=k;
            break;
        end
        tmpsum=tmpsum+tmp(k);
        
    end
    curves{i/step}=sliceDensity;
    varians(i/step)=std(sliceDensity);
end
%figure;
x=[1:length(varians)]*step;

[~, fdegrees]=sort(varians,'descend');
fdegrees=fdegrees(1:4)*step;%
