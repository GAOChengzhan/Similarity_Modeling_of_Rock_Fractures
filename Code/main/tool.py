from re import X
from tkinter import Y
import numpy as np
def deg2rad(deg):                                                               #弧度制转换函数
    return deg/360*2*np.pi

def theta_standardlize(theta): 
    if theta>=np.pi:
        while  theta>=np.pi:
            theta-=np.pi
    elif theta<0:
        while theta<0:
            theta+=np.pi
    return theta

def length_check(len_dis):
    for i in range(len(len_dis)):
        if len_dis[i]<0:
            len_dis[i]=0.1
    
    return len_dis

def matrix_similarity(arr1,arr2):
    if arr1.shape!=arr2.shape:
        minx=min(arr1.shape[0]-arr2.shape[0])
        miny=min(arr1.shape[1]-arr2.shape[1])
        diff=arr1[:minx,:miny]-arr2[:minx,:miny]
    else:
        diff=arr1-arr2
    dist=np.linalg.norm(diff,ord='fro')
    len1=np.linalg.norm(arr1)
    len2=np.linalg.norm(arr2)
    denom=(len1-len2)/2
    similarity_index=1-(dist/denom)
    return similarity_index

def center_weight_point(points):
    X,Y=0,0
    number_of_P=len(points)
    if number_of_P>0:
        for point in points:
            X+=point[0]
            Y+=point[1]
        x_mean=X/number_of_P
        y_mean=Y/number_of_P
        CW_P=(x_mean,y_mean)
        return CW_P
    elif number_of_P==0:
        return (-1,-1)
    
    