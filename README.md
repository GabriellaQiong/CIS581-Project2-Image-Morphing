
==================================
CIS 581, Project 2: Image Morphing
==================================
==================================
Fall 2013
==================================
==================================
Qiong Wang
==================================

---
INTRODUCTION
----

This is the course project for CIS 581, Computer Vision and Photography. 
It mainly focuses on image morphing techniques for human faces. All the codes in this project are implemented in MATLAB 2013a. 


---
CONTENTS
---

* REQUIREMENT

The detailed requirement can be found in the coursee wiki page through the following link:

http://alliance.seas.upenn.edu/~cis581/wiki/Projects/Fall2013/Project2/Proj2-2013-Fall.pdf

* IMPLEMENTATION

A morph is a simultaneous warp of the image shape and a cross-dissolve of the image colors. 
The warp is controlled by the transformation between correspondence.

In this project, two method are used for image morphing. One is the triangulation method with a defined triangular mesh 
over the control points. For each meshed triangle, it is easy to find the affine transformation of three points. Detailed
description can be found here:

https://docs.google.com/viewer?url=http%3A%2F%2Falliance.seas.upenn.edu%2F~cis581%2Fwiki%2FLectures%2FFall2013%2FCIS581-09-13-triangle.pdf

The other is the Thin-plate-spline (TPS) method using sparse and irregular positioned feature points and smooth interpolation. 
Detailed description is here:

http://alliance.seas.upenn.edu/~cis581/wiki/Lectures/Fall2013/CIS581-10-13-thin-plate.pdf

Here is an easy implementation tutorial for both of the two methods:

http://alliance.seas.upenn.edu/~cis581/wiki/Projects/Fall2013/Project2/project_2_review.pptx

The primary morphing here is from my face to a minion's face, and the detailed process of this can be found in the result part.

* CODES DESCRIPTION

Here are the functions, scripts and data mainly used to generate the final face morphing:

|         Name           |                      Description                         |
|:----------------------:|:---------------------------------------------------------|
| click_correspondences.m|  Using "cpselect()" to choose the corresponding points   |
|      mytsearch.cpp     |  You can use this cpp file after "mex mytsearch.cpp"     |
|    mytsearch.mexa64    |  This mexa64 file is generated from mytsearch.cpp        |
|          morph.m       |  Morphing function using triangulation method            |
|      morph_tps.m       |  Morphing function using thin plate spline method        |
|        est_tps.m       |  Estimate the parameters for TPS method                  |
| morph_wrapper_tps.m    |  Wrapper function including computation of TPS parameters|
|    pixel_limit.m       |  Validate the pixel result after transformation          |
| script_image_morphing.m|  Script to run the image morphing with either method     |
|       points.mat       |  Saved corresponding control points for image morphing   |

---
RESULTS
---
Here are the links for the videos of face morphing using Triangulation and Thin-plate-spline method.

1.Triangulation Method

[![ScreenShot](https://raw.github.com/GabriellaQiong/Project2-Pathtracer/master/10021534.PNG)](http://www.youtube.com/watch?v=W3h_t3rLg0Q&feature=youtu.be)

2.Thin-Plate-Sline Method

[![ScreenShot](https://raw.github.com/GabriellaQiong/Project2-Pathtracer/master/10021534.PNG)]()

---
THIRD PARTY CODE
---
Here the mytsearch.cpp is from David R. Martin, Boston College which will save a lot of time to do the triangular index search. The original code is attacked on this link:

http://graphics.cs.cmu.edu/courses/15-463/2011_fall/hw/proj3/mytsearch_mod.c

Note: please first mex this cpp file and use it in MATLAB. Thank you :)
