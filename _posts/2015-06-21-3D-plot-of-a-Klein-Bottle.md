---
title: "3D plot of a Klein Bottle"
author: "Manuel Mendes"
date: "Sunday, June 21, 2015"
layout: post
category: R  3D Klein-Bottle Mathematics
---

The [Klein bottle][1] was discovered in 1882 by [Felix Klein][2] and since then has joined the gallery of popular mathematical shapes.   
The Klein bottle is a one-sided closed surface named after Klein. We note however this is not a continuous surface in 3-space as the surface cannot go through itself without a discontinuity.



{% highlight r %}
#install.packages('animation', repos = 'http://rforge.net', type = 'source')
#install.packages("plot3D")

library(plot3D)
library(animation)

saveGIF({
  par(mai = c(0.1,0.1,0.1,0.1))
  r = 3
  for(i in 1:100){
    X <- seq(0, 2*pi, length.out = 200)
    #Y <- seq(-15, 6, length.out = 100)
    Y <- seq(0, 2*pi, length.out = 200)
    M <- mesh(X, Y)
    u <- M$x
    v <- M$y
    
    # x, y and z grids
    #   x <- (1.16 ^ v) * cos(v) * (1 + cos(u))
    #   y <- (-1.16 ^ v) * sin(v) * (1 + cos(u))
    #   z <- (-2 * 1.16 ^ v) * (1 + sin(u))

    ######   Klein bottle   ##########
    x <- (r + cos(u/2) * sin(v) - sin(u/2) * sin(2*v)) * cos(u)
    y <- (r + cos(u/2) * sin(v) - sin(u/2) * sin(2*v)) * sin(u)
    z <- sin(u/2) * sin(v) + cos(u/2) * sin(2*v)
    ##################################
    
    # full colored image
    surf3D(x, y, z, colvar = z, 
           col = ramp.col(col = c("red", "red", "orange"), n = 100),
           colkey = FALSE, shade = 0.5, expand = 1.2, box = FALSE, 
           phi = 35, theta = i, lighting = TRUE, ltheta = 560,
           lphi = -i)
  }
}, interval = 0.1, ani.width = 550, ani.height = 350)
{% endhighlight %}



{% highlight text %}
## [1] TRUE
{% endhighlight %}

Here is the result from the code above:

![plot of chunk unnamed-chunk-1](/../images/animation.gif) 

### References      

[1]: https://en.wikipedia.org/wiki/Klein_bottle    
[2]: http://www-history.mcs.st-andrews.ac.uk/history/Biographies/Klein.html      
[Klein Bottle] (https://www.math.hmc.edu/funfacts/ffiles/30002.7.shtml)     
[http://genedan.com/no-39-exploring-sage-as-an-alternative-to-mathematica/] (http://genedan.com/no-39-exploring-sage-as-an-alternative-to-mathematica/)    
[Imaging maths - Inside the Klein bottle] (https://plus.maths.org/content/imaging-maths-inside-klein-bottle)    
[Fun with surf3D function] (http://alstatr.blogspot.pt/2014/02/r-fun-with-surf3d-function.html)



