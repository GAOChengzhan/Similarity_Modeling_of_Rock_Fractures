function result=cosSimu(a,b)
% Loop Cosine Similarity
n=fix(size(a,2)/200)+1; % 分成 n 段
n=1;
temp_a=cell(1,n);    %  每段成为一个数组
temp_a_node=zeros(1,n-1);
for i=1:n-1
    temp_a_node(i)=fix(length(a)/n)*i;
end
temp_a_node=[1 temp_a_node length(a)];
for i=2:n+1
    temp_a{i-1}=a(temp_a_node(i-1):temp_a_node(i));
end

overPoint=length(b)-1;
b=[b b]; % 双倍，用于滚动搜索

coeff=zeros(n,overPoint);
for i=1:n
    for j=1:overPoint
        temp_b=b(j:j+length(temp_a{i})-1);  
        coeff(i,j)=dot(temp_a{i},temp_b)/(norm(temp_a{i})*norm(temp_b));
    end
end
coeff=max(coeff');
result=mean(coeff);