import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
from crack import Crack
from tool import theta_standardlize,deg2rad,length_check
from distribution import dir_distribution, len_distribution, spacing_distribution
rrs=np.random.RandomState(5)
class Draw():
    def __init__(self,canvas_size = (100,100)):                                 #默认画布大小为100×100
        self.x_max,self.y_max = canvas_size
        self.crack_inform_pairs = []
        #美化一下颜色
        red='#CD0000';green='#2E8B57';blue='#3A5FCD';orange='#EE9A00';purple='#9B30FF'
        self.colors = [red,'darkcyan','dodgerblue','DarkOrange',purple]           #每组用不同颜色表示，暂定最多为5组
        #用于输出裂隙的信息
        self.direction_collection=[]
        self.length_collection=[]
        self.centerpoint_collection=[]
        self.endpoint_collection=[]
        self.spacing_collection=[]
    
        
    #用于输出裂隙的信息的函数----------------------------------------------
    def get_directions(self): 
        return self.direction_collection
    
    def get_length(self):
        return self.length_collection
    
    def get_centerpoints(self):
        return self.centerpoint_collection
    
    def get_endpoints(self):
        return self.endpoint_collection
    
    def get_spacing(self):
        return self.spacing_collection
    #----------------------------------------------------------------------     
                   
    def _add(self,crack,color):
        self.crack_inform_pairs.append([crack,color])
    
    def _adjust_into_canvas(self,crack,colors):
        return crack
    
    def _generate_location(self,theta,spacing,spacing_dis,length,length_dis):                         #确定中心点的坐标
        x_list,y_list=[],[]
        #将化到区间[0，pi）中
        theta=theta_standardlize(theta)
        index_max=len(length_dis)-1
        #print(index_max)
        #根据倾角分为三种情况
        if  0 <= theta and theta< np.pi/2:
            n = int((self.y_max + self.x_max*np.tan(theta))/(spacing/np.cos(theta)))
            b_list = [-self.x_max*np.tan(theta)+(i*(spacing_dis[i]/np.cos(theta))) for i in range(n)]
        elif (np.pi/2) < theta:
            n = int((self.y_max - self.x_max*np.tan(theta))/(-spacing/np.cos(theta)))
            b_list = [((i+1)*(-spacing_dis[i]/np.cos(theta))) for i in range(n)]
        elif theta==np.pi/2:                                                   #平行于y轴，情况特殊
            n = int(self.x_max/spacing)
            x_list=[ ((i+1)*spacing_dis[i]) for i in range(n)]
            y_list=[ rrs.uniform(0,self.y_max) for i in range(n)]
            b_list=[]                                               
        print(len(b_list))
        index = 0
        for b in b_list:
            if index>=500:
                break
            len_interval=(length_dis[index]+length_dis[index+1])*0.5
            len_distance=length_dis[index]*0.5+length_dis[index+1]

            x,y,again_gen,x_next_min,x_next_max,x_max=self._first_generate_xy(b,theta,length,len_interval,len_distance)
            x_list.append(x);y_list.append(y);index=index+1
            
            while again_gen==True and index<(index_max-2) and x_next_max<x_max:                                               #判断是否需要在假定线上画多条裂隙
                len_interval=(length_dis[index]+length_dis[index+1])*0.4
                len_distance=(length_dis[index]*0.5+length_dis[index+1])*1.0
                x,y,again_gen,x_next_min,x_next_max=self._again_generate_xy(b,theta,x_next_min,x_next_max,x_max,length,len_interval,len_distance)
                x_list.append(x);y_list.append(y);index=index+1
        # print(index)       
        return x_list,y_list
        
    def _again_generate_xy(self,b,theta,x_next_min,x_next_max,x_max,length,len_interval,len_distance):
        again_gen=False
        x = rrs.uniform(x_next_min,x_next_max)
        y = np.tan(theta)*x+b+rrs.uniform(-0.05*length,0.05*length)
        x_next_min,x_next_max=x+len_interval*abs(np.cos(theta)),x+len_distance*abs(np.cos(theta))
        if (x_max>x_next_min):
            again_gen=True
        return x,y,again_gen,x_next_min,x_next_max
    
    def _first_generate_xy(self,b,theta,length,len_interval,len_distance):
        again_gen=False
        x_next_min,x_next_max,x_min,x_max=0,0,0,0
        if b<0:                                                                 #截距在原点下方，计算x坐标的最小值
            x_min,x_max =-b/np.tan(theta),self.x_max
            if ((x_max-x_min)/abs(np.cos(theta)))>length and x_max>x_min:
                again_gen=True
                x = rrs.uniform(x_min,x_min+length)
                y = np.tan(theta)*x+b+rrs.uniform(-0.05*length,0.05*length)
                x_next_min,x_next_max=x+len_interval*abs(np.cos(theta)),x+len_distance*abs(np.cos(theta))
            else:
                x = rrs.uniform(x_min,x_max)
                y = np.tan(theta)*x+b+rrs.uniform(-0.05*length,0.05*length)
        elif 0<b and b<self.y_max:                                             #截距在画布内，计算x坐标的最大值，分两种情况
            if  0 < theta and theta< np.pi/2:                  
                x_min,x_max=0,(self.y_max-b)/np.tan(theta)
                if ((x_max-x_min)/abs(np.cos(theta)))>length and x_max>x_min:
                    again_gen=True
                    x = rrs.rand()*length
                    y = np.tan(theta)*x+b+rrs.uniform(-0.05*length,0.05*length)
                    x_next_min,x_next_max=x+len_interval*abs(np.cos(theta)),x+len_distance*abs(np.cos(theta))
                else:
                    x = rrs.rand()*x_max
                    y = np.tan(theta)*x+b+rrs.uniform(-0.05*length,0.05*length)
            elif (np.pi/2) < theta and theta< np.pi:
                x_min,x_max=0,-b/np.tan(theta)
                if ((x_max-x_min)/abs(np.cos(theta)))>length and x_max>x_min:
                    again_gen=True
                    x = rrs.rand()*length
                    y = np.tan(theta)*x+b+rrs.uniform(-0.05*length,0.05*length)
                    x_next_min,x_next_max=x+len_interval*abs(np.cos(theta)),x+len_distance*abs(np.cos(theta))
                else:
                    x = rrs.rand()*x_max
                    y = np.tan(theta)*x+b+rrs.uniform(-0.05*length,0.05*length)
        elif b>self.y_max:                                                      #截距在画布上边界上方，计算x坐标的最小值
            x_min,x_max = -(b-self.y_max)/np.tan(theta),self.x_max
            if ((x_max-x_min)/abs(np.cos(theta)))>length and x_max>x_min:
                again_gen=True
                x = rrs.uniform(x_min,x_min+length)
                y = np.tan(theta)*x+b+rrs.uniform(-0.05*length,0.05*length)
                x_next_min,x_next_max=x+len_interval*abs(np.cos(theta)),x+len_distance*abs(np.cos(theta))
            else:
                x = rrs.uniform(x_min,x_max)
                y = np.tan(theta)*x+b+rrs.uniform(-0.05*length,0.05*length)
        return x,y,again_gen,x_next_min,x_next_max,x_max
    
    def _is_in_canvas(self,x,y):
        return x >= 0 and x <= self.x_max and y >= 0 and y <= self.y_max
        
    def generate_crack(self,configs):
        for idx1,config in enumerate(configs):
            name = config['name']
            number = config['number']
            spacing = config['spacing']
            spacing_dis = spacing_distribution(config['spacing'] ,2,1000,"Uniform") 
            theta=deg2rad(config['theta'])
            theta_dis = dir_distribution(deg2rad(config['theta']),0.1,1000,"Fisher")  #倾角满足von-Mises-Fisher分布                   
            length=config['length']
            length_dis=len_distribution(config['length'],2,1000,"Normal")             #长度满足给定分布
            length_dis=length_check(length_dis)
#            color = self.colors[idx1] 
            x_l,y_l = self._generate_location(theta,spacing,spacing_dis,length,length_dis)       #调用随机生成中心点坐标的函数
            if number>len(x_l): 
                number=len(x_l)
                print("要求的个数溢出，已生成可能的最多的裂隙个数。最多生成"+str(len(x_l))+"条迹线。")
            idxs = rrs.choice(np.arange(len(x_l)),number,replace=False)        #从生成的坐标列表中选取指定数量

            
            i=0
            new_theta_collection,new_length_collection,new_centerpoint_collection,new_endpoint_collection=[],[],[],[]
            for idx2,(x,y) in enumerate(zip(x_l,y_l)):
                if idx2 in idxs:
                    color="black"
                    c = Crack(x = x,
                              y = y,
                              theta = theta_dis[i],
                              length = length_dis[i])
                    self._add(c,color)
                    #为输出做准备
                    new_theta_collection.append(float(c.theta))
                    new_length_collection.append(float(c.length))
                    new_centerpoint_collection.append([c.x,c.y])
                    new_endpoint_collection.append([[c.p1[0],c.p1[1]],[c.p2[0],c.p2[1]]])                   
                    
                    #------------------------
                    # self.direction_collection.append(float(c.theta))
                    # self.length_collection.append(float(c.length))
                    # self.centerpoint_collection.append([c.x,c.y])
                    # self.endpoint_collection.append([[c.p1[0],c.p1[1]],[c.p2[0],c.p2[1]]])
                                     
                    #--------------------------
                                       
                i=i+1
                        
            #为输出做准备
            self.direction_collection.append(new_theta_collection)
            self.length_collection.append(new_length_collection)
            self.centerpoint_collection.append(new_centerpoint_collection)
            self.endpoint_collection.append(new_endpoint_collection)
            self.spacing_collection.append(spacing)
    
    #画图
    def plot(self): 
        plt.title("Crack Map",fontsize=30)    
        plt.rcParams['figure.figsize'] = [5,5]
        mpl.rcParams['figure.dpi']=200                                                              #在画布上画出线段和中心点
        for c,color in self.crack_inform_pairs:
            plt.plot([c.p1[0],c.p2[0]],[c.p1[1],c.p2[1]],color=color,linewidth=1.0)
            #plt.scatter(c.x,c.y, facecolors='none', edgecolors='b')
        plt.xlim(0,self.x_max)
        plt.ylim(0,self.y_max)
        plt.show()
        
    def heatmap_plot(self):                                                                   #在画布上画出线段和中心点
        for c,color in self.crack_inform_pairs:
            plt.plot([c.p1[0],c.p2[0]],[c.p1[1],c.p2[1]],color = 'navy',linewidth=1)
        plt.xlim(0,self.x_max)
        plt.ylim(0,self.y_max)
