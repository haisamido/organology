#!/usr/bin/env python3

import matplotlib as plt
import numpy as np
import zipfile

frequencies=np.loadtxt("frequencies.csv", dtype=float) 
scale_lengths=range(500, 1205, 5)
mass_per_lengths = np.arange (.01,.105,.005)

#x=np.loadtxt("tensions.csv", dtype=float) 


#s=range(500, 1200, 5)

# table = np.array([
#     frequencies,
#     [4, 5, 6],
#     [7, 8, 9]
# ])

arr = np.array([])


for frequency in frequencies:
    for scale_length in scale_lengths:
        for mass_per_length in mass_per_lengths:

            tension=(mass_per_length*(frequency*2*scale_length)**2)/(1000*980.665)
            
#            result = np.append(arr, [frequency, scale_length, mass_per_length, tension], axis=0)

        #    table = np.array[ [frequency,scale_length,mass_per_length,tension] ]
#            print(frequency,scale_length,mass_per_length,tension)

# print(result)
# #fig = plt.figure()

# arr = np.array([[1, 2, 3], [4, 5, 6]])

# # Append a new row [7, 8, 9]
# new_row = np.array([7, 8, 9])
# result = np.append(arr, [new_row], axis=0)

#print(x)

import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d
import numpy as np

# Create a figure and 3D axes
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Generate sample data
X, Y = np.meshgrid(np.arange(-5, 5, 0.25), np.arange(-5, 5, 0.25))
Z = np.sin(np.sqrt(X**2 + Y**2))

# Plot the 3D contour
ax.contour3D(X, Y, Z, 20, cmap='viridis')

# Add labels and title
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')
plt.title('3D Contour Plot')

# Show the plot
plt.show()