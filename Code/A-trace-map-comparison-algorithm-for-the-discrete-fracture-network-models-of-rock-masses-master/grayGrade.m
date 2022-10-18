function [grade,totalNetValue]=grayGrade(image,netWide,netHeight)
totalNetValue=zeros(fix(size(image,1)/netHeight),fix(size(image,2)/netWide)); % 网格汇总
for i=1:size(image,1)/netHeight
    for j=1:size(image,2)/netWide
        temp_block=image((i-1)*netHeight+1:i*netHeight,(j-1)*netWide+1:j*netWide);
        [r,~]=find(temp_block<200);
        totalNetValue(i,j)=length(r);
    end
end
totalNetValue=sort(totalNetValue(:));
totalNetValue=totalNetValue/(netWide*netHeight);

node=0.15; % 建立节点，将 0 到 1 分成 2 大段，前段的筛孔变化较精细
grade=zeros(1,round(node/0.001)); % 确定初始的级配筛孔
for i=1:round(node/0.001)
    [r,~]=find(totalNetValue<i*0.001);
    grade(i)=length(r);
end
grade=grade/length(totalNetValue);