import numpy as np
import matplotlib.pyplot as plt
from draw import Draw
from mapplot import line2point,density,contour_map
from intersection import get_intersection_points
from similarity_comprasion import similarity_analysis
from mapplot import line2point


if __name__ =='__main__':
    plt.rcParams['figure.figsize'] = [20,20]
    plt.rcParams['figure.dpi'] = 144
    plt.rcParams['font.size'] =20
    crack_map1 = Draw((60,60))
    crack_map1.generate_crack(
        [

            {'name':'set1','spacing':3,'theta':70,'number':50,'length':6},
            {'name':'set2','spacing':3,'theta':140,'number':50,'length':9},
            {'name':'set3','spacing':5,'theta':100,'number':50,'length':3},
            {'name':'set4','spacing':4,'theta':30,'number':50,'length':18},
            {'name':'set5','spacing':9,'theta':10,'number':50,'length':12}
            
        ])
    
    crack_map1.plot()
    plt.rcParams['figure.figsize'] = [20,20]
    plt.rcParams['figure.dpi'] = 144
    plt.rcParams['font.size'] =20
    crack_map2 = Draw((60,60))
    crack_map2.generate_crack(
        [
            {'name':'set1','spacing':6,'theta':55,'number':50,'length':4},
            {'name':'set2','spacing':5,'theta':125,'number':50,'length':8},
            {'name':'set3','spacing':8,'theta':145,'number':50,'length':12},
            {'name':'set4','spacing':7,'theta':95,'number':50,'length':16},
            {'name':'set5','spacing':4,'theta':5,'number':50,'length':20}

        ])

    crack_map2.plot()
    similarity= similarity_analysis(crack_map1,crack_map2)
    # simi=similarity.density_comprasion_matrix()
    # print(simi)


    similarity.density_gravityCenter_comprasion(6,20)
    similarity.density_gravityCenter_comprasion_by_group(3,20)#density_index,magnifier_index1

    # # #----------------------------------------------------------------------------
    # #length
    x=similarity.length_comprasion_by_group()
    y=similarity.length_comprasion()
    # # print(x)
    # # print(y)
    # #----------------------------------------------------------------------------
    #direction
    #d=similarity.direction_comprasion()
    # #----------------------------------------------------------------------------
    # #density
    #similarity.density_comprasion()
    #similarity.density_comprasion_by_group(0.25)
    # #----------------------------------------------------------------------------
    # #spacing
    #similarity.spacing_comprasion_by_group()
    # #----------------------------------------------------------------------------
    # #cluster
    # similarity.cluster_comprasion()









# ##########################################################################################
    # points1=line2point(crack_map1.x_max,crack_map1.y_max,crack_map1,20)
    # points2=line2point(crack_map1.x_max,crack_map1.y_max,crack_map2,20)
    # density_z1=density(crack_map1.x_max,crack_map1.y_max,points1,0.2)
    # density_z2=density(crack_map1.x_max,crack_map1.y_max,points2,0.2)
    # plt.subplot(121)
    # plt.imshow(density_z1,interpolation='gaussian', cmap='YlOrRd')
    # #plt.colorbar()

                
    # plt.subplot(122)
    # plt.imshow(density_z2,interpolation='gaussian', cmap='YlOrRd')
    # #plt.colorbar()

    # plt.show()
# ##########################################################################################

    ###headmap--------------------------------------------------------------------------------
    # x_range,y_range=50,50
    # magnifier_index1=50
    # magnifier_index2=0.7
    # points=line2point(x_range,y_range,crack_map1,magnifier_index1)
    # density_z=density(x_range,y_range,points,magnifier_index2)
    # contour_map(crack_map1,50,50,density_z,magnifier_index2)
    ###headmap--------------------------------------------------------------------------------

    ###intersection---------------------------------------------------------------------------
    # points_number=get_intersection_points(crack_map1)
    # print("2D裂隙图中共有"+str(points_number)+"个交点。")
    ###intersection---------------------------------------------------------------------------