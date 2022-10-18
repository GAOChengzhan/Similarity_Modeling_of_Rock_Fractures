import numpy as np
from scipy.ndimage.filters import gaussian_filter
import matplotlib.pyplot as plt
import warnings

def line2point(x_range,y_range,experiment_obj,magnifier_index1=50,*argv):
    points=[]
    if argv[0]=='True':
        centerPoints=experiment_obj.get_centerpoints()[argv[1]]
        directions=experiment_obj.get_directions()[argv[1]]
        length=experiment_obj.get_length()[argv[1]]
        endPoints=experiment_obj.get_endpoints()[argv[1]]
        points=[]
        print(argv[1])
        for i in range(len(endPoints)):
            times=int(length[i]*magnifier_index1)
            for j in range(times+1):
                newPoint_x=float(endPoints[i][1][0]) + (j)*np.cos(directions[i])/magnifier_index1
                newPoint_y=float(endPoints[i][1][1]) + (j)*np.sin(directions[i])/magnifier_index1
                if newPoint_x>=0 and newPoint_x<x_range and newPoint_y>=0 and newPoint_y<y_range:
                    newPoint=[newPoint_x,newPoint_y]                 
                    points.append(newPoint)
    elif argv[0]=='False':
        centerPoints=experiment_obj.get_centerpoints()
        directions=experiment_obj.get_directions()
        length=experiment_obj.get_length()
        endPoints=experiment_obj.get_endpoints()
        n=len(endPoints)
        points=[]
        for k in range(n):
            for i in range(len(endPoints[k])):
                times=int(length[k][i]*magnifier_index1)
                for j in range(times+1):
                    newPoint_x=float(endPoints[k][i][1][0]) + (j)*np.cos(directions[k][i])/magnifier_index1
                    newPoint_y=float(endPoints[k][i][1][1]) + (j)*np.sin(directions[k][i])/magnifier_index1
                    if newPoint_x>=0 and newPoint_x<x_range and newPoint_y>=0 and newPoint_y<y_range:
                        newPoint=[newPoint_x,newPoint_y]                 
                        points.append(newPoint)
    else:
        warnings.warn("Failed to turn lines to points")
    return points


def density(x_range,y_range,points,magnifier_index2=0.5):

    size_x,size_y=int(x_range*magnifier_index2),int(y_range*magnifier_index2)
    z=np.zeros([size_x,size_y])
    intersection_points=[]                   #收集交点坐标
    for (x,y) in points:
        x_cor=int(y*magnifier_index2)
        y_cor=int(x*magnifier_index2)
        z[x_cor][y_cor]+=1
    return z
def heatmap(arr):
    plt.imshow(arr,interpolation='gaussian', cmap='YlOrRd')
    plt.colorbar()



def contour_map(draw_obj,x_range,y_range,density,magnifier_index2): 
    density = gaussian_filter(density, 0.7)
    x = np.linspace(0, x_range, x_range * magnifier_index2)
    y = np.linspace(0, y_range, y_range * magnifier_index2)
    X, Y = np.meshgrid(x, y)
    temp=plt.contourf(X, Y,density,20,
                  cmap='YlOrRd',
                  extend ='both',
                  alpha=1)
    plt.contour(temp,levels=temp.levels[::2],colors='dimgray',linewidths=0.8,linestyles='dashed')
    plt.colorbar(temp)
    plt.title('Contour Map of Crack')
    draw_obj.heatmap_plot()
    plt.show()

