from re import I, M
from turtle import shape
import numpy as np
from pyparsing import alphas
from mapplot import line2point,density,heatmap
import warnings
import matplotlib.pyplot as plt

from tool import theta_standardlize,center_weight_point
from scipy.stats import wasserstein_distance
from itertools import permutations,cycle
from sklearn.cluster import AffinityPropagation
from sklearn import metrics

def hcf(x, y):
    """该函数返回两个数的最大公约数"""
    hcf=[]
   # 获取最小值
    if x > y:
        smaller = y
    else:
        smaller = x
 
    for i in range(2,smaller):
        if((x % i == 0) and (y % i == 0)):
            hcf.append(i)
 
    return hcf

#长度
#位置
#间距
#分组

class similarity_analysis():
    def __init__(self,map1,map2):#map is a draw_obj
        self.map1 = map1                                                  
        self.map2 = map2
        self.group_num1 = len(self.map1.direction_collection)
        self.group_num2 = len(self.map1.direction_collection)                                                          


#配对
    def group_coupling(self):
        if self.group_num1==self.group_num2:
            index_of_group2=np.zeros(self.group_num2)
            dir_set1=np.asarray(self.map1.get_directions(),dtype=object)
            dir_set2=np.asarray(self.map2.get_directions(),dtype=object)
            characteristic_dir1,characteristic_dir2 = [],[]

            for i in range(self.group_num1):
                characteristic_dir1.append(np.mean(dir_set1[i])*360/(2*np.pi))
                characteristic_dir2.append(np.mean(dir_set2[i])*360/(2*np.pi))
            permutation_lst=[i for i in range(self.group_num1)]
            permutation_lst=list(permutations(permutation_lst))
            min,min_value=0,360*self.group_num1

            for i in range(len(permutation_lst)):
                characteristic_dir2_new=[characteristic_dir2[index] for index in permutation_lst[i]]
                distance_value=np.mean([abs(characteristic_dir1[j]-characteristic_dir2_new[j]) for j in range (self.group_num1)])
                if distance_value<min_value:
                    min_value=distance_value
                    min=i
            min_permutation=permutation_lst[min]
            return min_permutation
        else:
            warnings.warn("CANNOT provide the coupling index!")
            return None

#检验一下图片大小是否一样

    def group_comprasion(self): 
        group_similarity_index=0.0
        group_num1 = len(self.map1.direction_collection)
        group_num2 = len(self.map2.direction_collection)
        group_similarity_index=abs(group_num1-group_num2)/max(group_num1,group_num2)
        return group_similarity_index

#------------------------------------------------------------------------------------
#Density_Location
    def density_comprasion(self):
        size11 = self.map1.x_max
        size12 = self.map1.y_max
        size21 = self.map2.x_max
        size22 = self.map2.y_max
        if size11==size21 and size12==size22 :
            size_x,size_y=size11,size22
            hcf_lst=hcf(size_x,size_y)
            hcf_lst=[10]
            min_hcf=1
            magnifier_index1=int(10/min_hcf)
            points1=line2point(size_x,size_y,self.map1,magnifier_index1,'False',)
            points2=line2point(size_x,size_y,self.map2,magnifier_index1,'False',)
            len_hcf=len(hcf_lst)

            fig, (ax1,ax2) = plt.subplots(figsize=(20, 7),ncols=2,constrained_layout=True)
            #fig.suptitle("Overall Density Comprasion",fontsize=20)
            for i,ax in enumerate((ax1,ax2)):
                magnifier_index2=1/hcf_lst[i//2]                
                if i%2==0:
                    density_z1=density(size_x,size_y,points1,magnifier_index2)
                    im=ax.imshow(density_z1, cmap='YlOrRd')
                    for c,color in self.map1.crack_inform_pairs:
                        ax.plot([c.p1[0]/hcf_lst[i//2]-0.5,c.p2[0]/hcf_lst[i//2]-0.5],
                                [c.p1[1]/hcf_lst[i//2]-0.5,c.p2[1]/hcf_lst[i//2]-0.5],color = 'black',alpha=0.7)
                    ax.set_xlim(0-0.5,size_x/hcf_lst[i//2]-0.5)
                    ax.set_ylim(0-0.5,size_y/hcf_lst[i//2]-0.5)
                    fig.colorbar(im, ax=ax,location='right',orientation='vertical',shrink=0.7)
                    ax.axis('off')
                    numx=int(size_x/hcf_lst[i//2])
                    numy=int(size_y/hcf_lst[i//2])
                    ax.set_title("Density Matrix of First Map ("+str(numx)+"X"+str(numy)+")",fontsize=15)
                    # ax.set_xlim([])
                    # ax.set_ylim([])
                elif i%2==1:
                    density_z2=density(size_x,size_y,points2,magnifier_index2)
                    im=ax.imshow(density_z2, cmap='YlOrRd')
                    for c,color in self.map2.crack_inform_pairs:
                        ax.plot([c.p1[0]/hcf_lst[i//2] -0.5,c.p2[0]/hcf_lst[i//2]-0.5 ],
                                [c.p1[1]/hcf_lst[i//2] -0.5,c.p2[1]/hcf_lst[i//2]-0.5 ],color = 'black',alpha=0.7)
                    ax.set_xlim(0-0.5,size_x/hcf_lst[i//2]-0.5)
                    ax.set_ylim(0-0.5,size_y/hcf_lst[i//2]-0.5)
                    fig.colorbar(im, ax=ax,location='right',orientation='vertical',shrink=0.7)
                    numx=int(size_x/hcf_lst[i//2])
                    numy=int(size_y/hcf_lst[i//2])
                    ax.axis('off')
                    ax.set_title("Density Matrix of Second Map ("+str(numx)+"X"+str(numy)+")",fontsize=15)
            plt.show()

            return None
            # for hcfs in hcf_lst:
            #     magnifier_index2=1/hcfs
            #     density_z1=density(size_x,size_y,points1,magnifier_index2)
            #     density_z2=density(size_x,size_y,points2,magnifier_index2)

            #     plt.subplot(len_hcf,2,2*i+1)
            #     plt.imshow(density_z1, cmap='YlOrRd') #plt.imshow(density_z1,interpolation='gaussian', cmap='YlOrRd')

            #     #plt.colorbar()
            #     #plt.plot()
            #     plt.subplot(len_hcf,2,2*i+2)
            #     plt.imshow(density_z2, cmap='YlOrRd') #plt.imshow(density_z2,interpolation='gaussian', cmap='YlOrRd')
            #     #plt.colorbar()
            #     #plt.plot()
            #     i=i+1
            
        else:
            warnings.warn("CANNOT Compare the two given crack maps!!")
            return None

    def density_gravityCenter_comprasion(self,density_index,magnifier_index1):
        size11 = self.map1.x_max
        size12 = self.map1.y_max
        size21 = self.map2.x_max
        size22 = self.map2.y_max
        if size11==size21 and size12==size22 :
            size_x,size_y=size11,size22
            points1=line2point(size_x,size_y,self.map1,magnifier_index1,'False',)
            points2=line2point(size_x,size_y,self.map2,magnifier_index1,'False',)
            num_x=int(size11/density_index)
            num_y=int(size12/density_index)
            Grid_Points1=[[[] for i in range(density_index)] for i in range(density_index)]
            Grid_Points2=[[[] for i in range(density_index)] for i in range(density_index)]
            for point1,point2 in zip(points1,points2):
                index_x1,index_x2=int(point1[0]//num_x),int(point2[0]//num_x)
                index_y1,index_y2=int(point1[1]//num_y),int(point2[1]//num_y)
                Grid_Points1[index_x1][index_y1].append(point1)
                Grid_Points2[index_x2][index_y2].append(point2)

            Gravity_Center_Points1=[[ center_weight_point(Grid_Points1[i][j])   for j in range(density_index)] for i in range(density_index)]
            Gravity_Center_Points2=[[ center_weight_point(Grid_Points2[i][j])   for j in range(density_index)] for i in range(density_index)]
            
            fig, axs = plt.subplots(1, 2, constrained_layout=True)
            fig.suptitle("Location Comprasion",fontsize=24)
            for i,ax in enumerate(axs.flat):
                if i%2==0:
                    endpoints=self.map1.get_endpoints()
                    for i in range(len(endpoints)):
                        for endpoint in endpoints[i]:
                            ax.plot([endpoint[0][0],endpoint[1][0]],[endpoint[0][1],endpoint[1][1]],color = 'navy',linewidth=1)
                                
                    for j in range(len(Gravity_Center_Points1)):
                        for k in range(len(Gravity_Center_Points1[j])):
                            ax.plot(Gravity_Center_Points1[j][k][0],
                                    Gravity_Center_Points1[j][k][1],
                                    "o",
                                    markerfacecolor='#EE9A00',
                                    markeredgecolor="k",
                                    markersize=10,
                                    )
                    ax.set_title("Gravity center of Map1",fontsize=14)
                    ax.axis(xmin=0.0,xmax=size_x)
                    ax.axis(ymin=0.0,ymax=size_y)
                    ax.tick_params(axis='both', which='major', labelsize=12)
                    ax.grid(color='#2E8B57', linestyle='-', linewidth=0.5)
                elif i%2==1:
                    endpoints=self.map2.get_endpoints()
                    for i in range(len(endpoints)):
                        for endpoint in endpoints[i]:
                            ax.plot([endpoint[0][0],endpoint[1][0]],[endpoint[0][1],endpoint[1][1]],color = 'navy',linewidth=1)

                    for j in range(len(Gravity_Center_Points2)):
                        for k in range(len(Gravity_Center_Points2[j])):
                            ax.plot(Gravity_Center_Points2[j][k][0],
                                    Gravity_Center_Points2[j][k][1],
                                    "o",
                                    markerfacecolor='#EE9A00',
                                    markeredgecolor="k",
                                    markersize=10,
                                    )
                    ax.set_title("Gravity center of Map2",fontsize=14)
                    ax.axis(xmin=0.0,xmax=size_x)
                    ax.axis(ymin=0.0,ymax=size_y)
                    ax.tick_params(axis='both', which='major', labelsize=12)
                    ax.grid(color='#2E8B57', linestyle='-', linewidth=0.5)
            plt.show()


            return None
        else:
            warnings.warn("CANNOT Compare the two given crack maps!!")
            return None

    def density_gravityCenter_comprasion_by_group(self,density_index,magnifier_index1):
        size11 = self.map1.x_max
        size12 = self.map1.y_max
        size21 = self.map2.x_max
        size22 = self.map2.y_max
        if size11==size21 and size12==size22 and self.group_num1==self.group_num2:
            size_x,size_y=size11,size22
            index=self.group_coupling()
            num_x=int(size11/density_index)
            num_y=int(size12/density_index)
            fig, axs = plt.subplots(2, 2, constrained_layout=True)
            fig.suptitle("Location Comprasion by Group",fontsize=20)
            
            endpoints1=self.map1.get_endpoints()
            endpoints2=self.map2.get_endpoints()
                 
            for i,ax in enumerate(axs.flat):
                i=i+6
                if i%2==0:
                    for endpoint1 in endpoints1[i//2]:
                        ax.plot([endpoint1[0][0],endpoint1[1][0]],[endpoint1[0][1],endpoint1[1][1]],color = 'navy',linewidth=1)
                    Grid_Points1=[[[] for m in range(density_index)] for n in range(density_index)]
                    points1=line2point(size_x,size_y,self.map1,magnifier_index1,'True',i//2)
                    for point1 in points1:
                        index_x1=int(point1[0]//num_x)
                        index_y1=int(point1[1]//num_y)
                        Grid_Points1[index_x1][index_y1].append(point1)

                    Gravity_Center_Points1=[[ center_weight_point(Grid_Points1[i][j])   for j in range(density_index)] for i in range(density_index)]

                    for j in range(len(Gravity_Center_Points1)):
                        for k in range(len(Gravity_Center_Points1[j])):
                            ax.plot(Gravity_Center_Points1[j][k][0],
                                    Gravity_Center_Points1[j][k][1],
                                    "o",
                                    markerfacecolor='#EE9A00',
                                    markeredgecolor="k",
                                    markersize=10,
                                    )
                    ax.set_title("Group "+str(i//2+1)+" of Map1",fontsize=14)
                    ax.axis(xmin=0.0,xmax=size_x)
                    ax.axis(ymin=0.0,ymax=size_y)
                    ax.set_xticks([0,20,40,60])
                    ax.set_yticks([0, 20, 40,60])
                    ax.tick_params(axis='both', which='major', labelsize=12)
                    ax.grid(color='orange', linestyle='-', linewidth=0.5)                    
                elif i%2==1:
                    for endpoint2 in endpoints2[index[i//2]]:
                        ax.plot([endpoint2[0][0],endpoint2[1][0]],[endpoint2[0][1],endpoint2[1][1]],color = 'navy',linewidth=1)

                    points2=line2point(size_x,size_y,self.map2,magnifier_index1,'True',index[i//2])
                    Grid_Points2=[[[] for m in range(density_index)] for n in range(density_index)]
                    for point2 in points2:
                        index_x2=int(point2[0]//num_x)
                        index_y2=int(point2[1]//num_y)
                        Grid_Points2[index_x2][index_y2].append(point2)

                    Gravity_Center_Points2=[[ center_weight_point(Grid_Points2[i][j])   for j in range(density_index)] for i in range(density_index)]

                    for j in range(len(Gravity_Center_Points2)):
                        for k in range(len(Gravity_Center_Points2[j])):
                            ax.plot(Gravity_Center_Points2[j][k][0],
                                    Gravity_Center_Points2[j][k][1],
                                    "o",
                                    markerfacecolor='#EE9A00',
                                    markeredgecolor="k",
                                    markersize=10,
                                    )
                    ax.set_title("Group "+str(index[i//2]+1)+" of Map 2" ,fontsize=14)
                    ax.axis(xmin=0.0,xmax=size_x)
                    ax.axis(ymin=0.0,ymax=size_y)
                    ax.set_xticks([0, 20, 40,60])
                    ax.set_yticks([0, 20, 40,60])
                    ax.tick_params(axis='both', which='major', labelsize=12)
                    ax.grid(color='orange', linestyle='-', linewidth=0.5)                   
            # plt.xticks([0, 20, 40,60],[0, 20, 40,60])
            # plt.yticks([0, 20, 40,60],[0, 20, 40,60])
            plt.show()

            return None
        else:
            warnings.warn("CANNOT Compare the two given crack maps!!")
            return None


        
    def density_comprasion_by_group(self,magnifier_index2):
        size11 = self.map1.x_max
        size12 = self.map1.y_max
        size21 = self.map2.x_max
        size22 = self.map2.y_max

        if size11==size21 and size12==size22 and self.group_num1==self.group_num2:      
            size_x,size_y=size11,size22
            hcf_lst=hcf(size_x,size_y)
            # print(hcf_lst)
            min_hcf=hcf_lst[0]
            magnifier_index1=int(10/min_hcf)
            # print(int(1/magnifier_index2))
            if int(1/magnifier_index2) in hcf_lst or int(1/magnifier_index2)==1:
                fig, axs = plt.subplots(1, 2)
                # fig.suptitle("Density Comprasion by group",fontsize=20)
                index=self.group_coupling()
                for i,ax in enumerate(axs.flat):
                    if i%2==0:
                        points1=line2point(size_x,size_y,self.map1,magnifier_index1,'True',i//2)
                        density_z1=density(size_x,size_y,points1,magnifier_index2)
                        im=ax.imshow(density_z1, cmap='YlOrRd')
                        temp=4
                        for c,color in self.map1.crack_inform_pairs:
                            ax.plot([c.p1[0]/temp-0.5,c.p2[0]/temp-0.5],
                                    [c.p1[1]/temp-0.5,c.p2[1]/temp-0.5],color = 'black',alpha=0.7)
                        ax.set_xlim(0-0.5,size_x/temp-0.5)
                        ax.set_ylim(0-0.5,size_y/temp-0.5)
                        fig.colorbar(im, ax=ax,location='right',orientation='vertical',shrink=0.7)
                        ax.axis('off')
                        ax.set_title("Group 5 of Map 1",fontsize=15)
                        # ax.set_xlim([])
                        # ax.set_ylim([])
                    elif i%2==1:
                        points2=line2point(size_x,size_y,self.map2,magnifier_index1,'True',index[i//2])
                        density_z2=density(size_x,size_y,points2,magnifier_index2)
                        im=ax.imshow(density_z2, cmap='YlOrRd')
                        temp=4
                        for c,color in self.map2.crack_inform_pairs:
                            ax.plot([c.p1[0]/temp-0.5,c.p2[0]/temp-0.5],
                                    [c.p1[1]/temp-0.5,c.p2[1]/temp-0.5],color = 'black',alpha=0.7)
                        ax.set_xlim(0-0.5,size_x/temp-0.5)
                        ax.set_ylim(0-0.5,size_y/temp-0.5)
                        fig.colorbar(im, ax=ax,location='right',orientation='vertical',shrink=0.7)
                        ax.axis('off')
                        ax.set_title("Group 5 of Map 2",fontsize=15) 
                plt.show()
                return None
            else:
                warnings.warn("CANNOT Compare the two given crack maps by group!!")             
                return None        

        else:
            warnings.warn("CANNOT Compare the two given crack maps by group!!")
            return None

#------------------------------------------------------------------------------------
#Direction
    def direction_comprasion(self): #map is a draw_obj
        dir_set1=self.map1.get_directions()
        dir_set2=self.map2.get_directions()
        dir1,dir2=[],[]
        for i in range(len(dir_set1)):
            for j in dir_set1[i]:
                j=theta_standardlize(j)
                j=j*360/(2*np.pi)
                dir1.append(j)
        for i in range(len(dir_set2)):
            for j in dir_set2[i]:
                j=theta_standardlize(j)
                j=j*360/(2*np.pi)
                dir2.append(j)
        #dir_set1=np.reshape(dir_set1)
        num=15#分区个数
        
        #visualization
        plt.figure()
        plt.subplot(211)
        plt.hist(dir1,bins=num,facecolor="dodgerblue",edgecolor="black",alpha=0.9)
        plt.tick_params(axis='both', which='major', labelsize=8)
        plt.xlabel("Angle",fontsize=10)
        plt.ylabel("Number",fontsize=10)
        plt.title("Direction Comprasion",fontsize=20)
        plt.subplot(212)
        plt.hist(dir2,bins=num,facecolor='#CD0000',edgecolor="black",alpha=0.9)
        plt.tick_params(axis='both', which='major', labelsize=8)
        plt.xlabel("Angle",fontsize=10)
        plt.ylabel("Number",fontsize=10)
        
        plt.show()

        WassersteinDistance=wasserstein_distance(dir1,dir2)

        return WassersteinDistance

#------------------------------------------------------------------------------------
#Spacing
    def spacing_comprasion(self): #map is a draw_obj
        group_similarity_index=0.0
        return group_similarity_index
    def spacing_comprasion_by_group(self): #map is a draw_obj

        index=self.group_coupling()
        if self.group_num1==self.group_num2:
            number=self.group_num1
            label_lst=[]
            for i in range(number):
                label_lst.append('Group'+str(i))
            num_lst1=self.map1.get_spacing()
            num_lst2_temp=self.map2.get_spacing()
            num_lst2=[num_lst2_temp[index[i]] for i in range(len(num_lst2_temp))]
            x=range(len(num_lst1))
            wid=0.3

            map1_dir=self.map1.get_directions()
            def auto_text1(rects):
                for rect in rects:
                    plt.text(rect.get_x(),rect.get_height(),map1_dir,ha='left',va='bottom')
            
            map2_dir_temp=self.map2.get_directions()
            map2_dir=[map2_dir_temp[index[i]] for i in range(len(map2_dir_temp))]
            def auto_text2(rects):
                for rect in rects:
                    plt.text(rect.get_x(),rect.get_height(),map2_dir,ha='left',va='bottom')


            rect1=plt.bar(x=x,height=num_lst1,width=wid,alpha=0.8,color='#CD0000',label='Map1')
            rect2=plt.bar(x=[i+wid for i in x],height=num_lst2,width=wid,alpha=0.8,color='dodgerblue',label='Map2')
            # auto_text1(rect1)
            # auto_text2(rect2)
            plt.tick_params(axis='both', which='major', labelsize=8)
            plt.ylabel("Spacing",fontsize=10)
            plt.xlabel("Group",fontsize=10)
            #plt.title("Spacing Comprasion",fontsize=20)
            plt.legend(loc="upper left",fontsize=7)
            plt.show()

        else:
            warnings.warn("CANNOT Compare these two Maps'Spacing")
            
        return None
#------------------------------------------------------------------------------------
#Length
    def length_comprasion(self): #map is a draw_obj
        len_set1=self.map1.get_length()
        len_set2=self.map2.get_length()
        len1,len2=[],[]
        for i in range(len(len_set1)):
            for j in len_set1[i]:
                len1.append(j)
        for i in range(len(len_set2)):
            for j in len_set2[i]:
                len2.append(j)
        #dir_set1=np.reshape(dir_set1)
        bins_lst=[i*1.5 for i in range(15)]
        #visualization
        plt.figure()
        plt.subplot(211)
        plt.hist(len1,bins=bins_lst,facecolor='dodgerblue',edgecolor="black",alpha=0.5)
        plt.tick_params(axis='both', which='major', labelsize=8)
        plt.xlabel("Length",fontsize=10)
        plt.ylabel("Number",fontsize=10)
        # plt.xlim(fontsize=7);plt.ylim(fontsize=7)
        plt.title("Comprehensive Length Comprasion",fontsize=20)
        plt.subplot(212)
        plt.hist(len2,bins=bins_lst,facecolor='#CD0000',edgecolor="black",alpha=0.5)
        plt.tick_params(axis='both', which='major', labelsize=8)
        plt.xlabel("Length",fontsize=10)
        plt.ylabel("Number",fontsize=10)
        # plt.xlim(fontsize=7);plt.ylim(fontsize=7)
        
        plt.show()

        WassersteinDistance=wasserstein_distance(len1,len2)

        return WassersteinDistance

    def length_comprasion_by_group(self): #map is a draw_obj
        index=self.group_coupling()
        len_set1=self.map1.get_length()
        len_set2=self.map2.get_length()

        colors = ['#CD0000','darkcyan','dodgerblue','DarkOrange','#9B30FF']
        #dir_set1=np.reshape(dir_set1)
        bins_lst=[i for i in range(30)]
        #visualization
        plt.figure(figsize=(5,8))
        plt.subplot(211)
        dir1=self.map1.get_directions()
        for i in range(self.group_num1):
            plt.hist(len_set1[i],bins=bins_lst,facecolor=colors[i],edgecolor="black",alpha=0.35,label="Group"+str(i+1)+"; Angle:"+str(round(np.mean(dir1[i])*180/np.pi,1)))
        plt.tick_params(axis='both', which='major', labelsize=8)
        plt.xlabel("Length",fontsize=10)
        plt.ylabel("Number",fontsize=10)
        plt.title("Length Comprasion by Group",fontsize=20)
        plt.legend(loc="upper right",fontsize=7)
        plt.subplot(212)
        dir2=self.map2.get_directions()
        for i in range(self.group_num2):
            plt.hist(len_set2[ index[i] ],bins=bins_lst,facecolor=colors[i],edgecolor="black",alpha=0.35,label="Group"+str(index[i]+1)+"; Angle"+str(round(np.mean(dir2[index[i]])*180/np.pi,1)))
        plt.tick_params(axis='both', which='major', labelsize=8)
        plt.xlabel("Length",fontsize=10)
        plt.ylabel("Number",fontsize=10)
        plt.legend(loc="upper right",fontsize=7)
        plt.show()

        WassersteinDistance=np.zeros(self.group_num1)
        for i in range(self.group_num1):
            WassersteinDistance[i]=wasserstein_distance(len_set1[i],len_set2[i])
        WSD=np.mean(WassersteinDistance)
        return WSD
    
    def cluster_comprasion(self,magnifier_index1=1):
        size11 = self.map1.x_max
        size12 = self.map1.y_max
        size21 = self.map2.x_max
        size22 = self.map2.y_max
        
        P1=line2point(size11,size12,self.map1,magnifier_index1,'False',)
        P2=line2point(size21,size22,self.map2,magnifier_index1,'False',)
        fig, axs = plt.subplots(1, 2, constrained_layout=True)
        fig.suptitle("Cluster Comprasion",fontsize=20)
        for i,ax in enumerate(axs.flat):
            if i ==0:
                P1=np.asarray(P1)
                af = AffinityPropagation(random_state=5).fit(P1)
                cluster_centers_indices = af.cluster_centers_indices_
                labels = af.labels_
                n_clusters_ = len(cluster_centers_indices)
                colors = cycle("bgrcmykbgrcmykbgrcmykbgrcmyk")

                for k, col in zip(range(n_clusters_), colors):
                    class_members = labels == k
                    cluster_center = P1[cluster_centers_indices[k]]
                    ax.plot(P1[class_members, 0], P1[class_members, 1], col + ".")
                    ax.plot(
                        cluster_center[0],
                        cluster_center[1],
                        "o",
                        markerfacecolor=col,
                        markeredgecolor="k",
                        markersize=14,
                    )

                ax.tick_params(axis='both', which='major', labelsize=8)
                ax.set_title("Estimated number of clusters: %d" % n_clusters_,fontsize=10)

            elif i ==1:
                P2=np.asarray(P2)
                af = AffinityPropagation(random_state=5).fit(P2)
                cluster_centers_indices = af.cluster_centers_indices_
                labels = af.labels_
                n_clusters_ = len(cluster_centers_indices)
                colors = cycle("bgrcmykbgrcmykbgrcmykbgrcmyk")

                for k, col in zip(range(n_clusters_), colors):
                    class_members = labels == k
                    cluster_center = P2[cluster_centers_indices[k]]
                    ax.plot(P2[class_members, 0], P2[class_members, 1], col + ".")
                    ax.plot(
                        cluster_center[0],
                        cluster_center[1],
                        "o",
                        markerfacecolor=col,
                        markeredgecolor="k",
                        markersize=14,
                    )
                    # for x in P2[class_members]:
                    #     ax.plot([cluster_center[0], x[0]], [cluster_center[1], x[1]], col)
                ax.tick_params(axis='both', which='major', labelsize=8)
                ax.set_title("Estimated number of clusters: %d" % n_clusters_,fontsize=10)
                
        plt.show()


        return None


    def density_comprasion_matrix(self):
            size11 = self.map1.x_max
            size12 = self.map1.y_max
            size21 = self.map2.x_max
            size22 = self.map2.y_max
            if size11==size21 and size12==size22 :
                size_x,size_y=size11,size22
                min_hcf=1
                magnifier_index1=int(10/min_hcf)
                points1=line2point(size_x,size_y,self.map1,magnifier_index1,'False',)
                points2=line2point(size_x,size_y,self.map2,magnifier_index1,'False',)
                #fig.suptitle("Overall Density Comprasion",fontsize=20)
                magnifier_index2=1/15
                density_z1=np.array(density(size_x,size_y,points1,magnifier_index2))
                density_z2=np.array(density(size_x,size_y,points2,magnifier_index2))
                sum=0
                for i in range(density_z1.shape[0]):
                    for j in range(density_z1.shape[1]):
                        if density_z1[i][j]==0 or density_z2[i][j]==0:
                            temp=0
                        else:
                            temp=min(density_z1[i][j]/density_z2[i][j],density_z2[i][j]/density_z1[i][j])
                        sum+=temp
                similarity=sum/(density_z1.shape[0]*density_z1.shape[1])
                return similarity
            else:
                warnings.warn("CANNOT Compare the two given crack maps!!")
                return None