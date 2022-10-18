import numpy as np
class Crack():
    def __init__(self,x,y,theta,length):
        self.x = x                                                              #中心点横坐标
        self.y = y                                                              #中心点纵坐标
        self.theta = theta                                                      #角度
        self.length = length                                                    #长度
        self.p1, self.p2 = self._get_points()                       
    def _get_points(self):                                                      #通过中心点和长度确定端点坐标
        p1 = (self.x + self.length/2*np.cos(self.theta), self.y + self.length/2*np.sin(self.theta))
        p2 = (self.x - self.length/2*np.cos(self.theta), self.y - self.length/2*np.sin(self.theta))
        return p1,p2

