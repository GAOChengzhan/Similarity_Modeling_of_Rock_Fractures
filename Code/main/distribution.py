import numpy as np
#方向概率统计分布----------------------------------------------
def dir_distribution(mu,dispersion,number,dis_name):      
    if dis_name=="Fisher":#kappa;2D Form of Vonmises-Fisher Distribution
        return np.random.vonmises(mu,dispersion,number)
    elif dis_name=="Normal":
        return np.random.normal(mu,dispersion,number)
    elif dis_name=="Uniform":
        return mu
    elif dis_name=="Lognormal":#对数正态lognormal
        return np.random.lognormal(mu,dispersion,number)
    else:
        raise Warning("Wrong Distribution Name!")

#长度概率统计分布----------------------------------------------
def len_distribution(mu,dispersion,number,dis_name):      
    if dis_name=="Exponential":
        return np.random.exponential(mu,dispersion,number)
    elif dis_name=="Gamma":
        return np.random.gamma(mu/dispersion,dispersion,number)
    elif dis_name=="Normal":
        return np.random.normal(mu,dispersion,number)
    elif dis_name=="Uniform":
        return mu
    else:
        raise Warning("Wrong Distribution Name!")

#间距概率统计分布-----------------------------------------------
def spacing_distribution(mu,dispersion,number,dis_name):
    if dis_name=="Uniform":
        return np.random.uniform(0.9*mu,1.10*mu,number)
    elif dis_name=="Normal":
        return np.random.normal(mu,dispersion,number)
    else:
        raise Warning("Wrong Distribution Name!")