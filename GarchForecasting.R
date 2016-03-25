
forecast.horizon <- 10
forecast.steps <- c(1,7,14,21,30)
forecast.sigma <- matrix(0,nrow=forecast.horizon,ncol=length(forecast.steps))
colors <- sample(colours(), forecast.horizon)

for (i in 1:forecast.horizon)
{
  garch.fit <- garchFit(formula=~garch(1,1), data=returns, trace=F, cond.dist='std', include.mean = F)
  #plot(xts(sqrt(252) * garch.fit@sigma.t, order.by=index(spy.ret.train)))
  sigma.predict.1day <- garchForecastVolatility1Day(garch.fit, tail(returns,1), tail(garch.fit@h.t,1))
  sigma.predict <- garchForecastVolatility(garch.fit, forecast.steps[-1])
  forecast.sigma[i,] <- c(sigma.predict.1day, sigma.predict)
  returns <- c(returns, as.vector(spy.ret.test[i,1]))
  
  if (i == 1) {
    plot(i:(i+length(forecast.steps)-1), forecast.sigma[i,], col=colors[i], type='l', xlim=c(1,forecast.horizon+length(forecast.steps)+1))
  } else {
    lines(i:(i+length(forecast.steps)-1), forecast.sigma[i,], col=colors[i])
  }
}

plot(1:forecast.horizon, forecast.sigma[,1], col='red', type='l')