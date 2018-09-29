"""
=========================================
Image denoising using dictionary learning
=========================================

"""
print(__doc__)

from time import time

import matplotlib.pyplot as plt
import numpy as np
import scipy as sp

from sklearn.decomposition import MiniBatchDictionaryLearning
from sklearn.feature_extraction.image import extract_patches_2d
from sklearn.feature_extraction.image import reconstruct_from_patches_2d


patch_size = (6, 6)
data=sp.io.loadmat('C:\\Users\\paulo\\Downloads\\FaceRecogToolv4\\distorted.mat')
data=data['distorted']/255
patches = extract_patches_2d(data, patch_size)
sp.io.savemat('C:\\Users\\paulo\\Downloads\\FaceRecogToolv4\\patches.mat', {'patches':patches})

