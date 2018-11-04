import matplotlib.pyplot as plt
import numpy as np
import scipy.io 
from sklearn.decomposition import MiniBatchDictionaryLearning
from sklearn.feature_extraction.image import extract_patches_2d
from sklearn.feature_extraction.image import reconstruct_from_patches_2d


patch_size = (6, 6)
data=scipy.io.loadmat('distorted.mat')
data=data['distorted']/255
patches = extract_patches_2d(data, patch_size)
scipy.io.savemat('patches.mat', {'patches':patches})