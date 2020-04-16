---
title: "COVID-19 outbreak: the case of Portugal(Update)"
author: "Manuel Mendes"
date: "Wednesday, Monday 16, 2020"
layout: post
category: R COVID-19 outbreak "The SIR model"
---

### COVID-19: a data epidemic
With the outbreak of COVID-19 one thing that is certain is that never before a virus has gone so much viral on the internet. Especially, a lot of data about the spread of the virus is going around.   

In the space of a few weeks, complex terms like “group immunity” (herd immunity) or “flattening the curve” started to circulate on social networks.

Here we will try an approach that demonstrates the limitations of the model from the previous post [The importance of “flattening the curve”](https://mpmendespt.github.io/The-importance-of-flattening-the-curve.html).    
This post is based on [Contagiousness of COVID-19 Part I: Improvements of Mathematical Fitting (Guest Post)](https://blog.ephorie.de/contagiousness-of-covid-19-part-i-improvements-of-mathematical-fitting-guest-post), this post compared to the previous one shows that the fitting of the data with the SIR model is tricky, the general problem is that the fitting-algorithm is not always finding it’s way to the best solution. 

### Why doesn’t the algorithm converge to the optimal solution?
There are two main reasons why the model is not converging well.   

### Early stopping of the algorithm
The first reason is that the optim algorithm is stopping too early before it has found the right solution.   

### Ill-conditioned problem
The second reason for the bad convergence behaviour of the algorithm is that the problem is ill-conditioned. 


### The latest data from:
[https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series](https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series)   



{% highlight r %}
x <- util_scrape_table("https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")

deaths <- util_scrape_table("https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")
recovered <- util_scrape_table("https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv")

y <- x %>% row_to_names(1) %>% clean_names %>% remove_empty() %>%
    gather(date, infections, -1:-4) %>%
    mutate(date = str_remove_all(date, "x")) %>%
    mutate(date = mdy(date)) %>%
    mutate(infections = parse_number(infections))

dy <- deaths %>% row_to_names(1) %>% clean_names %>% remove_empty() %>%
    gather(date, infections, -1:-4) %>%
    mutate(date = str_remove_all(date, "x")) %>%
    mutate(date = mdy(date)) %>%
    mutate(infections = parse_number(infections))

ry <- recovered %>% row_to_names(1) %>% clean_names %>% remove_empty() %>%
    gather(date, infections, -1:-4) %>%
    mutate(date = str_remove_all(date, "x")) %>%
    mutate(date = mdy(date)) %>%
    mutate(infections = parse_number(infections))
###################
from_date <-  dmy("02/03/2020")
sir_start_date <- "2020-03-02"
####################

pti    <- y %>% filter(country_region == "Portugal") %>%
    filter(date >= from_date) %>%
    group_by(date) %>% summarise(infections_pt = sum(infections)) #%>%

ptd    <- dy %>% filter(country_region == "Portugal") %>%
    filter(date >= from_date) %>%
    group_by(date) %>% summarise(death_pt = sum(infections)) #%>%

ptr    <- ry %>% filter(country_region == "Portugal") %>%
    filter(date >= from_date) %>%
    group_by(date) %>% summarise(recovered_pt = sum(infections)) #%>%



pt <- pti %>%
    left_join(ptd, by ="date") %>%
    left_join(ptr, by ="date")
{% endhighlight %}



{% highlight r %}
Infected <- pt$infections_pt
Infected
{% endhighlight %}



{% highlight text %}
##  [1]     2     2     5     8    13    20    30    30    41    59    59   112   169   245   331   448   448
## [18]   785  1020  1280  1600  2060  2362  2995  3544  4268  5170  5962  6408  7443  8251  9034  9886 10524
## [35] 11278 11730 12442 13141 13956 15472 15987 16585 16934 17448 18091
{% endhighlight %}



{% highlight r %}
D <- pt$death_pt
D
{% endhighlight %}



{% highlight text %}
##  [1]   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   2   3   6  12  14  23  33  43  60
## [26]  76 100 119 140 160 187 209 246 266 295 311 345 380 409 435 470 504 535 567 599
{% endhighlight %}



{% highlight r %}
R <- pt$recovered_pt
R
{% endhighlight %}



{% highlight text %}
##  [1]   0   0   0   0   0   0   0   0   0   0   0   1   2   2   3   3   3   3   5   5   5   5  22  22  43
## [26]  43  43  43  43  43  43  68  68  75  75 140 184 196 205 233 266 277 277 347 383
{% endhighlight %}



{% highlight r %}
Day <- 1:(length(Infected))
#N <- 1400000000 # population of mainland china
N <- 10276617 # população de Portugal do INE

RSS <- function(parameters) {
    names(parameters) <- c("beta", "gamma")
    out <- ode(y = init, times = Day, func = SIR, parms = parameters)
    fitInfected <- out[,3]
    sum((Infected - fitInfected)^2)
}

SIR <- function(time, state, parameters) {
    par <- as.list(c(state, parameters))
    with(par, {
        dS <- -beta/N * I * S
        dI <- beta/N * I * S - gamma * I
        list(c(dS, dI))
    })
}

SIR2 <- function(time, state, parameters) {
    par <- as.list(c(state, parameters))
    with(par, {
        dS <- I * K * (-S/N *  R0/(R0-1))
        dI <- I * K * ( S/N *  R0/(R0-1) - 1/(R0-1))
        list(c(dS, dI))
    })
}

RSS2 <- function(parameters) {
    names(parameters) <- c("K", "R0")
    out <- ode(y = init, times = Day, func = SIR2, parms = parameters)
    fitInfected <- out[,3]
    #fitInfected <- N-out[,2]
    sum((Infected - fitInfected)^2)
}

### Two functions RSS to do the optimization in a nested way
Infected_MC <- Infected
SIRMC2 <- function(R0,K) {
    parameters <- c(K=K, R0=R0)
    out <- ode(y = init, times = Day, func = SIR2, parms = parameters)
    fitInfected <- out[,3]
    #fitInfected <- N-out[,2]
    RSS <- sum((Infected_MC - fitInfected)^2)
    return(RSS)
}
SIRMC <- function(K) {
    optimize(SIRMC2, lower=1,upper=10^5,K=K, tol = .Machine$double.eps)$objective
}

#####
# wrapper to optimize and return estimated values
getOptim <- function() {
    opt1 <- optimize(SIRMC,lower=0,upper=1, tol = .Machine$double.eps)
    opt2 <- optimize(SIRMC2, lower=1,upper=10^5,K=opt1$minimum, tol = .Machine$double.eps)
    return(list(RSS=opt2$objective,K=opt1$minimum,R0=opt2$minimum))
}

# starting condition
init <- c(S = N-Infected[1], I = Infected[1]-R[1]-D[1])
#init <- c(S = N-Infected[1], I = Infected[1])
{% endhighlight %}

### Result of estimation of the reproduction number (R0)


{% highlight r %}
Opt <- optimr(par=c(0.5, 0.5), fn=RSS,
              #x=x,
              method = "L-BFGS-B",
              lower=c(0, 0),
              upper = c(1, 1),
              control = list(parscale = c(10^-4,10^-4)))
Opt$message
{% endhighlight %}



{% highlight text %}
## [1] "CONVERGENCE: REL_REDUCTION_OF_F <= FACTR*EPSMCH"
{% endhighlight %}



{% highlight r %}
#
Opt_par <- setNames(Opt$par, c("beta", "gamma"))
Opt_par
{% endhighlight %}



{% highlight text %}
##      beta     gamma 
## 1.0000000 0.7826315
{% endhighlight %}



{% highlight r %}
#
R0 <- as.numeric(Opt_par[1] / Opt_par[2])
R0
{% endhighlight %}



{% highlight text %}
## [1] 1.277741
{% endhighlight %}
### Currently the calculation of R0 by the model of the previous post   
gives: **R0 = 1.2777406**



{% highlight r %}
# fit <- data.frame(ode(y = init, times = t, func = SIR, parms = Opt_par))
#
# height_pand<- fit[fit$I == max(fit$I), "I", drop = FALSE] # height of pandemic
# height_pand
# attributes(height_pand)
# height_day <- as.integer(row.names(height_pand))
# from_date + height_day # height of pandemic
# # [1] "2020-05-02"
################################################################
Opt3 <- getOptim()
Opt3
{% endhighlight %}



{% highlight text %}
## $RSS
## [1] 163285478
## 
## $K
## [1] 0.2632098
## 
## $R0
## [1] 1.06201
{% endhighlight %}



{% highlight r %}
Opt3$R0
{% endhighlight %}



{% highlight text %}
## [1] 1.06201
{% endhighlight %}



{% highlight r %}
#  Opt3$R0
# [1] 1.0607

# Opt_par2 <- setNames(Opt2$par, c("K", "R0"))
# Opt_par2
{% endhighlight %}

### R0 by the current model
The current model gives: **R0 = 1.0620105** as we see the result is quite different.

### Some differences of the SIR model
This SIR model uses the parameters **$K = \beta - \gamma$ and    
$R_0 = \frac{\beta}{\gamma}$**   



{% highlight r %}
Opt_par3 <- setNames(Opt3[2:3], c("K", "R0"))
Opt_par3
{% endhighlight %}



{% highlight text %}
## $K
## [1] 0.2632098
## 
## $R0
## [1] 1.06201
{% endhighlight %}



{% highlight r %}
# plotting the result
t <- 1:80 # time in days

fit3 <- data.frame(ode(y = init, times = t, func = SIR2, parms = Opt_par3))

par(mar = c(1, 2, 3, 1.1)) # Set the margin on all sides to 2
# par(mar = c(bottom, left, top, right))
old <- par(mfrow = c(1, 1))

#Opt3 <- getOptim()
#Opt_par3 <- setNames(Opt3[2:3], c("K", "R0"))
Opt_par3
{% endhighlight %}



{% highlight text %}
## $K
## [1] 0.2632098
## 
## $R0
## [1] 1.06201
{% endhighlight %}



{% highlight r %}
##############
from_date <-  dmy("02/03/2020")
sir_start_date <- "2020-03-02"

height_pand<- fit3[fit3$I == max(fit3$I), "I", drop = FALSE] # height of pandemic
height_pand
{% endhighlight %}



{% highlight text %}
##           I
## 41 17870.26
{% endhighlight %}



{% highlight r %}
#           I
# 57 330697.5 # 10-04-2020
# 58 318210.1 # 11-04-2020
attributes(height_pand)
{% endhighlight %}



{% highlight text %}
## $names
## [1] "I"
## 
## $row.names
## [1] 41
## 
## $class
## [1] "data.frame"
{% endhighlight %}



{% highlight r %}
height_day <- as.integer(row.names(height_pand))
height_day
{% endhighlight %}



{% highlight text %}
## [1] 41
{% endhighlight %}



{% highlight r %}
max_infected <- max(fit3$I)
height_of_pandemic <- max_infected

forecast_infections <- fit3$I

max_infected_day <- from_date + height_day # height of pandemic
max_infected_day
{% endhighlight %}



{% highlight text %}
## [1] "2020-04-12"
{% endhighlight %}



{% highlight r %}
# [1] "2020-04-11"

height_of_pandemic_date <- max_infected_day

actual_infections <- Infected

days_from_inic <- data.frame(
    date = as.Date(from_date + t))

#
fit_i <- fit3 %>%
    cbind(days_from_inic)

fit_i$actual_infections <- c(Infected, rep(NA, nrow(fit_i)-length(Infected)))

#
full_forecast_plot <- fit_i %>% # output_df
  ggplot(aes(x = date)) +
  geom_line(aes(y = I / 1000), colour = "blue") +
  geom_point(aes(y = actual_infections / 1000), colour = "red") +
  geom_vline(xintercept = height_of_pandemic_date, line_type = "dotted") +
  annotate(geom = "text",
           x = height_of_pandemic_date,
           y = (height_of_pandemic / 1000) / 2,
           inherits = FALSE,
           label = str_glue("Max. infections of {comma(height_of_pandemic / 1000, accuracy = 0.01)} on {height_of_pandemic_date}"),
           color = "black",
           angle = 90,
           vjust = -0.25,
           size = 3) + #  size = 4
  
  theme_bw() +
  xlab("") +
  ylab("Number of Infections - Thousands") +
  scale_x_date(breaks = scales::pretty_breaks(n = 12))+   # for one year date labels
  scale_y_continuous(label = comma) +
  ggtitle(label = "Portugal - Corona Virus Infections Forecast",
          subtitle = "Blue Points are Forecast and Red Points are Actuals")
# caption  = "Data: https://github.com/CSSEGISandData/COVID-19")


full_forecast_plot
{% endhighlight %}

![plot of chunk unnamed-chunk-366](/../figure/COVID-19_outbreak_the_case_of_Portugal_(Update)/unnamed-chunk-366-1.png)

{% highlight r %}
height_of_pandemic_date
{% endhighlight %}



{% highlight text %}
## [1] "2020-04-12"
{% endhighlight %}

### Final conclusions
Based on this model the peak of the epidemic has already happened on day **2020-04-12** with a maximum of **17 870**.   
This is all we want, but it doesn't mean it is correct.
Just because we use a mathematical model does not mean that our conclusions/predictions are trustworthy. We need to challenge the premises which are the underlying data and models.    




### References   
* [https://blog.ephorie.de/contagiousness-of-covid-19-part-i-improvements-of-mathematical-fitting-guest-post](https://blog.ephorie.de/contagiousness-of-covid-19-part-i-improvements-of-mathematical-fitting-guest-post)   
* [https://www.tibco.com/blog/2020/03/18/covid-19-a-visual-data-science-analysis-and-review/](https://www.tibco.com/blog/2020/03/18/covid-19-a-visual-data-science-analysis-and-review/)   
* [https://stats.stackexchange.com/questions/446712/fitting-sir-model-with-2019-ncov-data-doesnt-conververge](https://stats.stackexchange.com/questions/446712/fitting-sir-model-with-2019-ncov-data-doesnt-conververge)   


