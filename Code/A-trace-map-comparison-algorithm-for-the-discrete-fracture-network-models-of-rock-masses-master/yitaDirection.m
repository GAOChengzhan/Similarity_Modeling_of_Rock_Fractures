function yita_direction=yitaDirection(fdegrees_a,fdegrees_b)

p=[];q=[];
for i=1:length(fdegrees_a)
    for j=1:length(fdegrees_a)
        if fdegrees_a(i)==fdegrees_b(j)
            p(i,j)=1;
            q=[q;i j];
        else
            p(i,j)=0;
        end
    end
end

count=[];k=1;
for i=1:length(q)-1
    for j=i+1:length(q)
        if (q(j,1)-q(i,1))*(q(j,2)-q(i,2))>0
            count(k)=1;
        else
            count(k)=0;
            
        end
        k=k+1;
    end
end
yita_direction=length(q)/length(fdegrees_a)*0.8+sum(count)/length(count)*0.2;