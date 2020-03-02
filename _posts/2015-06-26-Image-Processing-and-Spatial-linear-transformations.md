---
title: "Image Processing and Spatial linear transformations"
author: "Manuel Mendes"
date: "Monday, June 22, 2015"
layout: post
category: R Mathematics Image Processing Matrix Operation
---

We can think of an **image** as a function, f, from  $$\pmb R^2 \rightarrow  R$$ (or a 2D signal):    

- f (x,y) gives the **intensity** at position (x,y)

Realistically, we expect the image only to be defined over a rectangle, with a finite range:    
f: [a,b]x[c,d] -> [0,1]

A color image is just three functions pasted together. We can write this as a “vector-valued” function:

$$\pmb {f(x,y)} = \Bigg[ \begin{array}
{c}
& r(x,y) \cr \\
& g(x,y) \cr \\
& b(x,y) 
\end{array} \Bigg] 
$$

* Computing Transformations

If you have a transformation matrix you can evaluate the transformation that would be performed by multiplying the transformation matrix by the original array of points.     

### Examples of Transformations in 2D Graphics

In 2D graphics Linear transformations can be represented by 2x2 matrices. Most common transformations such as rotation, scaling, shearing, and reflection are linear transformations and can be represented in the 2x2 matrix. Other affine transformations can be represented in a 3x3 matrix. 

#### Rotation
For rotation by an angle θ clockwise about the origin, the functional form is \\( x' = xcosθ + ysinθ \\)      
and \\( y' = − xsinθ + ycosθ \\). Written in matrix form, this becomes:    
$$
\begin{bmatrix} x' \cr \ y' \end{bmatrix} = \begin{bmatrix} \cos \theta & \sin\theta \cr \ -\sin \theta & \cos \theta \end{bmatrix} \begin{bmatrix} x \cr \ y \end{bmatrix} 
$$


#### Scaling
For scaling we have \\( x&#39; = s\_x \cdot x \\) and \\( y&#39; = s\_y \cdot y \\). The matrix form is:         
$$ \begin{bmatrix} x' \cr \ y' \end{bmatrix} = \begin{bmatrix} s_x & 0 \cr \ 0 & s_y \end{bmatrix} \begin{bmatrix} x \cr \ y \end{bmatrix} $$

#### Shearing
For shear mapping (visually similar to slanting), there are two possibilities.    
For a shear parallel to the x axis has \\( x&#39; = x + ky \\) and \\( y&#39; = y \\) ; the shear matrix, applied to column vectors, is:    
$$ \begin{bmatrix} x' \cr \ y' \end{bmatrix} = \begin{bmatrix} 1 & k \cr \ 0 & 1 \end{bmatrix} \begin{bmatrix} x \cr \ y \end{bmatrix} $$

A shear parallel to the y axis has \\( x&#39; = x \\) and \\( y&#39; = y + kx \\) , which has matrix form:    
$$ \begin{bmatrix} x' \cr \ y' \end{bmatrix} = \begin{bmatrix} 1 & 0 \cr \ k & 1 \end{bmatrix} \begin{bmatrix} x \cr \ y \end{bmatrix} $$



### Image Processing

The package **EBImage** is an R package which provides general purpose functionality for the reading, writing, processing and analysis of images.



{% highlight r %}
# source("http://bioconductor.org/biocLite.R")
# biocLite()
# biocLite("EBImage")
library(EBImage)

# Reading Image
img <- readImage("images/lena_std.tif")

#str(img1)
dim(img)
{% endhighlight %}



{% highlight text %}
## [1] 512 512   3
{% endhighlight %}



{% highlight r %}
display(img, method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-1](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-1-1.png)

#### Image Properties

Images are stored as multi-dimensional arrays containing the pixel intensities. All EBImage functions are also able to work with matrices and arrays. 


{% highlight r %}
print(img)
{% endhighlight %}



{% highlight text %}
## Image 
##   colorMode    : Color 
##   storage.mode : double 
##   dim          : 512 512 3 
##   frames.total : 3 
##   frames.render: 1 
## 
## imageData(object)[1:5,1:6,1]
##           [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
## [1,] 0.8862745 0.8862745 0.8862745 0.8862745 0.8862745 0.8901961
## [2,] 0.8862745 0.8862745 0.8862745 0.8862745 0.8862745 0.8901961
## [3,] 0.8745098 0.8745098 0.8745098 0.8745098 0.8745098 0.8901961
## [4,] 0.8745098 0.8745098 0.8745098 0.8745098 0.8745098 0.8705882
## [5,] 0.8862745 0.8862745 0.8862745 0.8862745 0.8862745 0.8862745
{% endhighlight %}

* Adjusting Brightness


{% highlight r %}
img1 <- img + 0.2
img2 <- img - 0.3
display(img1, method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-3](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-3-1.png)

{% highlight r %}
display(img2, method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-3](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-3-2.png)

* Adjusting Contrast


{% highlight r %}
img1 <- img * 0.5
img2 <- img * 2
display(img1, method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-4](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-4-1.png)

{% highlight r %}
display(img2, method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-4](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-4-2.png)

* Gamma Correction


{% highlight r %}
img1 <- img ^ 4
img2 <- img ^ 0.9
img3 <- (img + 0.2) ^3
display(img1, method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-5](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-5-1.png)

{% highlight r %}
display(img2, method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-5](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-5-2.png)

{% highlight r %}
display(img3, method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-5](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-5-3.png)

* Cropping Image


{% highlight r %}
img1 <-img[(1:400)+100, 1:400,]
display(img1, method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-6](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-6-1.png)

### Spatial Transformation

Spatial image transformations are done with the functions resize, rotate, translate and the functions flip and flop to reflect images.

Next we show the functions flip, flop, rotate and translate:

{% highlight r %}
y <- flip(img)
display(y, title='flip(img)', method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-7](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-7-1.png)

{% highlight r %}
y = flop(img) 
display(y, title='flop(img)', method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-7](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-7-2.png)

{% highlight r %}
y <- rotate(img, 30) 
display(y, title='rotate(img, 30)', method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-7](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-7-3.png)

{% highlight r %}
y <- translate(img, c(120, -20)) 
display(y, title='translate(img, c(120, -20))', method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-7](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-7-4.png)


#### All spatial transforms except flip and flop are based on the general affine transformation.

Linear transformations using the function **affine**:     

*  **Horizontal flip**

$${m} = \left[ 
\begin{array}{cc}
\ -1 & 0 \cr \\
\ 0 & 1 
\end{array}
\right] 
$$

$$
\begin{equation}
   Result = image * m
\end{equation}
$$



{% highlight r %}
m <- matrix(c(-1, 0, 0, 1, 512, 0), nrow=3,  ncol=2, byrow = TRUE)
m  # Horizontal flip
{% endhighlight %}



{% highlight text %}
##      [,1] [,2]
## [1,]   -1    0
## [2,]    0    1
## [3,]  512    0
{% endhighlight %}



{% highlight r %}
display(affine(img, m),  method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-8](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-8-1.png)

*  **Horizontal shear**
$${m} = \left[ 
\begin{array}{cc}
1, 1/2 \cr \\
0, 1 
\end{array}
\right] 
$$



{% highlight r %}
m <- matrix(c(1, 1/2, 0, 1, 0, -100), nrow=3,  ncol=2, byrow = TRUE)
m  # horizontal shear  r = 1/2 
{% endhighlight %}



{% highlight text %}
##      [,1]   [,2]
## [1,]    1    0.5
## [2,]    0    1.0
## [3,]    0 -100.0
{% endhighlight %}



{% highlight r %}
display(affine(img, m),  method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-9](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-9-1.png)

*  **Rotation by π/6**
$${m} = \left[ 
\begin{array}{cc}
cos(pi/6), -sin(pi/6) \cr \\
sin(pi/6), cos(pi/6)
\end{array}
\right] 
$$


{% highlight r %}
m <- matrix(c(cos(pi/6), -sin(pi/6), sin(pi/6) , cos(pi/6), -100, 100), nrow=3,  ncol=2, byrow = TRUE)
m  # Rotation by π/6
{% endhighlight %}



{% highlight text %}
##              [,1]        [,2]
## [1,]    0.8660254  -0.5000000
## [2,]    0.5000000   0.8660254
## [3,] -100.0000000 100.0000000
{% endhighlight %}



{% highlight r %}
display(affine(img, m),  method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-10](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-10-1.png)

*  **Squeeze mapping with r=3/2**
$${m} = \left[ 
\begin{array}{cc}
3/2, 0 \cr \\
0, 2/3
\end{array}
\right] 
$$


{% highlight r %}
m <- matrix(c(3/2, 0, 0, 2/3, 0, 100), nrow=3,  ncol=2, byrow = TRUE)
m  # Squeeze mapping with r=3/2
{% endhighlight %}



{% highlight text %}
##      [,1]        [,2]
## [1,]  1.5   0.0000000
## [2,]  0.0   0.6666667
## [3,]  0.0 100.0000000
{% endhighlight %}



{% highlight r %}
display(affine(img, m),  method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-11](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-11-1.png)

*  **Scaling by a factor of 3/2**
$${m} = \left[ 
\begin{array}{cc}
3/2, 0 \cr \\
0, 3/2
\end{array}
\right] 
$$


{% highlight r %}
m <- matrix(c(3/2, 0, 0, 3/2, -100, -100), nrow=3,  ncol=2, byrow = TRUE)
m  # Scaling by a factor of 3/2
{% endhighlight %}



{% highlight text %}
##        [,1]   [,2]
## [1,]    1.5    0.0
## [2,]    0.0    1.5
## [3,] -100.0 -100.0
{% endhighlight %}



{% highlight r %}
display(affine(img, m),  method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-12](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-12-1.png)

*  **Scaling horizontally by a factor of 1/2** 
$${m} = \left[ 
\begin{array}{cc}
1/2, 0 \cr \\
0, 1
\end{array}
\right] 
$$


{% highlight r %}
m <- matrix(c(1/2, 0, 0, 1, 0, 0), nrow=3,  ncol=2, byrow = TRUE)
m  # scale a figure horizontally  r = 1/2 
{% endhighlight %}



{% highlight text %}
##      [,1] [,2]
## [1,]  0.5    0
## [2,]  0.0    1
## [3,]  0.0    0
{% endhighlight %}



{% highlight r %}
display(affine(img, m),  method = "raster")
{% endhighlight %}

![plot of chunk unnamed-chunk-13](/../figure/Image-Processing-and-Spatial-linear-transformations/unnamed-chunk-13-1.png)


### References

* [http://www.iitg.ernet.in/scifac/qip/public_html/cd_cell/chapters/dig_image_processin.pdf](http://www.iitg.ernet.in/scifac/qip/public_html/cd_cell/chapters/dig_image_processin.pdf)
* [http://www.math.ksu.edu/research/i-center/UndergradScholars/manuscripts/FernandoRoman.pdf](http://www.math.ksu.edu/research/i-center/UndergradScholars/manuscripts/FernandoRoman.pdf)
* [http://www.statpower.net/Content/310/R%20Stuff/SampleMarkdown.html](http://www.statpower.net/Content/310/R%20Stuff/SampleMarkdown.html)
* [http://linear.ups.edu/html/section-LT.html](http://linear.ups.edu/html/section-LT.html)
* [http://www.r-bloggers.com/r-image-analysis-using-ebimage/](http://www.r-bloggers.com/r-image-analysis-using-ebimage/)
* [http://www.maa.org/external_archive/joma/Volume8/Kalman/Linear3.html](http://www.maa.org/external_archive/joma/Volume8/Kalman/Linear3.html)
* [https://en.wikipedia.org/wiki/Linear_map](https://en.wikipedia.org/wiki/Linear_map)
* [https://en.wikipedia.org/wiki/Matrix_%28mathematics%29](https://en.wikipedia.org/wiki/Matrix_%28mathematics%29)
* [https://en.wikipedia.org/wiki/Affine_transformation](https://en.wikipedia.org/wiki/Affine_transformation)     
* [http://mathforum.org/mathimages/index.php/Transformation_Matrix](http://mathforum.org/mathimages/index.php/Transformation_Matrix)   










