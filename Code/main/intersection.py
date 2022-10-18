from matplotlib import pyplot as plt
from crack import Crack
import matplotlib.pyplot as plt
def intersect(line1,line2):
    intersect_or_not=False
    x,y=0,0
    p11x,p11y=line1.p1[0],line1.p1[1]
    p12x,p12y=line1.p2[0],line1.p2[1]
    p21x,p21y=line2.p1[0],line2.p1[1]
    p22x,p22y=line2.p2[0],line2.p2[1]
    len1,len2=line1.length,line2.length
    
    c1x,c1y=line1.x,line1.y
    c2x,c2y=line2.x,line2.y
    distance=(c1x-c2x)**2+(c1y-c2y)**2
    lenlen=0.25*(len1+len2)**2
    
    if distance>lenlen:
        return intersect_or_not,x,y
    else:
        if (p11x*p12y-p12x*p11y)!=0 and (p21x*p22y-p22x*p21y)!=0:
            a1,a2=(p11y-p12y)/(p11x*p12y-p12x*p11y),(p21y-p22y)/(p21x*p22y-p22x*p21y)
            b1,b2=(p12x-p11x)/(p11x*p12y-p12x*p11y),(p22x-p21x)/(p21x*p22y-p22x*p21y)
            c1,c2=1,1

            if (a1*b2-a2*b1)!=0:
                x=((b1*c2-b2*c1)/(a1*b2-a2*b1))
                y=((a2*c1-a1*c2)/(a1*b2-a2*b1))
                if x < max(p11x,p12x) and x > min(p11x,p12x) and  y < max(p11y,p12y) and y > min(p11y,p12y) and x < max(p21x,p22x) and x > min(p21x,p22x) and y < max(p21y,p22y) and y > min(p21y,p22y):
                    intersect_or_not=True
            
        return intersect_or_not,x,y

def get_intersection_points(experiment_obj):
    intersection_points=[]
    groups=len(experiment_obj.get_length())

    for i in range(groups-1):
        for j in range(i+1,groups):
            for k in range(len(experiment_obj.get_centerpoints()[i])):
                crack1 = Crack(x = experiment_obj.get_centerpoints()[i][k][0],
                               y = experiment_obj.get_centerpoints()[i][k][1],
                               theta = experiment_obj.get_directions()[i][k],
                               length = experiment_obj.get_length()[i][k]
                               )
                for m in range(len(experiment_obj.get_centerpoints()[j])):
                    crack2 = Crack(x = experiment_obj.get_centerpoints()[j][m][0],
                                   y = experiment_obj.get_centerpoints()[j][m][1],
                                   theta = experiment_obj.get_directions()[j][m],
                                   length = experiment_obj.get_length()[j][m]
                                   )
                    intersect_or_not,x,y=intersect(crack1,crack2)
                    if intersect_or_not:
                        intersection_points.append((x,y))
                        plt.scatter(x,y, marker='P', edgecolors='k')
    
    experiment_obj.plot()                   
    return len(intersection_points)