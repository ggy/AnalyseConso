library(strucchange)


b <- breakpoints(z ~ index(z))
f <- Fstats(z ~ index(z))


plot(b)  # 2 breakpoints
plot(f)  # Only 1 F-statistic above the threshold
lines(b)


fm0 <- lm(z ~ 1)
fm1 <- lm(z ~ breakfactor(b))
plot(z)
lines(zoo(fitted(fm0)), col = "red")
lines(zoo(fitted(fm1)), col = "blue")
lines(b, col = "yellow")
d <- z - zoo(fitted(fm0))
plot(cumsum(d))
boxplot(data.frame(d))
o<-outlier(d)
plot(density(d))
?density
bw.nrd0(d)
d<-density(d)

set.seed(1)
x<-d
hist(x, prob=TRUE)

lines(density(x), col='red')

library(ks)
tmp <- kde(x, hpi(x))
lines(tmp$eval.points, tmp$estimate, col='green')

library(logspline)
lsfit <- logspline(x, lbound=0)
curve( dlogspline(x,lsfit), add=TRUE, col='blue' )

curve( dlnorm, add=TRUE, col='orange' )
