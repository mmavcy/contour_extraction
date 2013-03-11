contour_extraction
==================

An efficient matlab implementation of a dynamic programming algorithm to extract contours from images.

Report.pdf was the report submited with the code for this university assignment. (Unfortunately it was rushed and writen in OpenOffice)

MATLAB FILES:

searchspace.m is called from script.m given an image and two (equal-length) contours. It splits the area between the contours to a given number of equidistant points and returns a matrix with their intensities.

script.m applies a dynamic programming algorithm for contour extraction that considers two features: pixel intensity and line continuity (with some hard-coded weighting).

slow.m was the first implementation with no vectorisation (ie it is of higher complexity).

time.m can run and time the previous scripts.
