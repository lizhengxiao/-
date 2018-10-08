
# ================================================================
# 1. ���ɷֲ�
# ================================================================
# density function ���ʺ���
dpois(x, lambda, log = FALSE) # lambda ��ʾ��ֵ, log = TRUE ��ʾ���log(f(x))
# distribution function �ֲ�����
ppois(q, lambda, lower.tail = TRUE, log.p = FALSE)
# quantile function �ֲ��������溯������λ��������
qpois(p, lambda, lower.tail = TRUE, log.p = FALSE)
# ���ɷֲ�������� - ģ��
rpois(n, lambda = 10) # ģ�� n ����������Ϊ10�Ĳ��ɷֲ�
# -----------------------------------------------------------------
# ��ͼ- ��ͬlambda�Ĳ��ɷֲ��ĸ��ʺ���ͼ
# -----------------------------------------------------------------
lambda.po <- c(1, 2, 5, 10) # lambda ȡֵΪ 1,2,5,10
x0 <- seq(0, 25)            # x ȡֵΪ 0-25 ������
f1 <- dpois(x0, lambda = lambda.po[1], log = FALSE) 
f2 <- dpois(x0, lambda = lambda.po[2], log = FALSE) 
f3 <- dpois(x0, lambda = lambda.po[3], log = FALSE) 
f4 <- dpois(x0, lambda = lambda.po[4], log = FALSE) 
com <- rbind('lambda = 1' = f1, 
            'lambda = 2' = f2, 'lambda = 5' = f3, 'lambda = 10' = f4)
barplot(com,
        col = 1:4, 
        beside = TRUE, 
        names.arg = 0:25, legend.text = TRUE)


## �����������3�ĸ���
dpois(3, lambda = 2)
## �������С�ڵ���4�ĸ���Ϊ
ppois(4, lambda = 2)
## ����������ڵ���3С�ڵ���5�ĸ���
ppois(5, 2) - ppois(2, 2)

## ģ��20����������۲�ֵ
set.seed(111) # �趨�������
sim = rpois(n = 20, lambda = 2) # ģ������20������lambda=2�Ĳ��ɷֲ����������
sim
## ��ģ���������������б�
table(sim)


# ================================================================
# 2. ������ֲ�
# ================================================================
# ���� r = size
# ���� beta = q
dnbinom(x, size, prob, mu, log = FALSE)
pnbinom(q, size, prob, mu, lower.tail = TRUE, log.p = FALSE)
qnbinom(p, size, prob, mu, lower.tail = TRUE, log.p = FALSE)
rnbinom(n, size, prob, mu)

# -----------------------------------------------------------------
# ���� ��ضϸ�����ֲ��ļ���
# -----------------------------------------------------------------
##������ֲ��ĸ���
x = 0:10
p = dnbinom(x, 4, 0.7)
round(p,3)
##��ضϸ�����ֲ��ĸ���
p0 = p[1]   
##���ĸ���
pt1 = p[2:11]/(1-p0)  
##�������ϵĸ���
pt = c(0, pt1)
round(pt, 3)
##��ͼ�Ƚϸ��������ضϸ�����ĸ���
com = rbind(������ = p, ��ضϸ����� = pt)
par(mfrow = c(1, 1))
barplot(com, beside = TRUE, names.arg = 0:10,legend.text = TRUE)

# -----------------------------------------------------------------
#���� �����������ֲ��ļ���
# -----------------------------------------------------------------
##������ֲ��ĸ���
x = 0:10
p = dnbinom(x, 4, 0.7)
round(p,3)
##�����������ֲ��ĸ���
p0 = 0.3  
##�������ĸ���
pm = (1 - p0)*p[2:11]/(1 - p[1])  
##�������ϵĸ���
pm = c(p0, pm)
round(pm, 3)
##��ͼ
com = rbind(������ = p, ����������� = pm)
barplot(com, beside = TRUE, names.arg = 0:10, legend.text = TRUE)




# ================================================================
# ����ֲ�
# ================================================================
# ���� m = size
# ���� prob = q
dbinom(x, size, prob, log = FALSE)
pbinom(q, size, prob, lower.tail = TRUE, log.p = FALSE)
qbinom(p, size, prob, lower.tail = TRUE, log.p = FALSE)
rbinom(n, size, prob)



# ��ͼ 
m0 <- c(1, 5, 10, 10, 10, 10)
q0 <- c(0.3, 0.3, 0.3, 0.1, 0.2, 0.3)
x0 <- seq(0, 10)

par(mfrow = c(2, 3) )
for (i in 1:length(m0)){
  fpo <- dbinom(x0, size = m0[i], prob = q0[i], log = FALSE)
  barplot(fpo, 
          main = paste0('m = ', m0[i], ',  ','q = ', q0[i]),
          names.arg = x0
  )
}



# ================================================================
# ���ηֲ�
# ================================================================
# ��ͼ 
r0 <- 1
beta0 <- c(0.1, 0.2, 0.3)
x0 <- seq(0, 10)


par(mfrow = c(1, 3) )
for (i in 1:length(beta0)){
  fpo <- dnbinom(x0, size = r0, prob = beta0[i], log = FALSE)
  barplot(fpo, main = paste0('beta = ', beta0[i]), names.arg = x0)
}



# ================================================================
# ����-���˹�ֲ��ĸ���
# ================================================================
# ���ɲ���Ϊlambda =1.2�����˹�ֲ���ֵΪ1��tao = 0.5������㲴��-���˹�ֲ��ĸ��ʡ�

lam = 1.2
tao = 0.5
f = function(theta) exp(-lam * theta) * (lam * theta)^k/gamma(k + 1) * exp(-(theta - 1)^2/2/tao/theta)/sqrt(2 * pi * theta^3 * tao)
p = NULL
i = 0
for (k in 0:20) {
  i = i + 1
  p[i] = integrate(f, 0, Inf)$value
}
p
sum(p)

# ================================================================
# ����-������̬�ֲ��ĸ���
# ================================================================
# ���ɲ���Ϊlambda =1.2��������̬�ֲ��ľ�ֵΪ1��sigma=0.5������㲴��-������̬�ֲ��ĸ��ʡ�
lam = 1.2
sig = 0.5
f = function(x) exp(-lam * x) * (lam * x)^k/gamma(k + 1) * dlnorm(x, meanlog = -sig^2, sdlog = sig^2)
p = NULL
i = 0
for (k in 0:10) {
  i = i + 1
  p[i] = integrate(f, 0, Inf)$value
  }
p
sum(p)

# ================================================================
# ���ϲ��ɷֲ��ĵ��ƹ�ʽ��1�� - (a, b, 0)
# ================================================================

COMPO = function (lam, f0, f) {
  cum = g = exp(lam*(f0 - 1)) 
  k = 0 # ѭ����ʶ
  repeat {
    k = k + 1
    last = lam / k * sum(1:k * head(f, k) * rev(g))
    g = c(g, last)
    cum = cum + last
    if (cum > 0.9999999) break  
  }
  return(g) 
}
#������ֲ��ĸ��ʺ���\
f0 = dnbinom(0, size = 4, prob = 0.3)     #���ĸ���
f = dnbinom(1:500, size = 4, prob = 0.3)  #1:500�ĸ���
#����-������ֲ��ĸ���
g = COMPO(lam = 2, f0, f) 
plot(0:(length(g)-1), g, type = 'h', col = 2, xlim = c(0, 50))

# Ӧ��actuar�����
library(actuar)
par(mfrow = c(1, 3))
sev = dnbinom(0:500, size = 4, prob = 0.3)
Fs1 = aggregateDist(method = "recursive", model.freq = "poisson", model.sev = sev, lambda = 2)
plot(0:10, dpois(0:10, 2), type = "h", col = 2, xlab = "", ylab = "", main = "poisson")
plot(0:50, dnbinom(0:50, size = 4, prob = 0.3), type = "h", col = 2, xlab = "",  ylab = "", main = "negative binomial")
plot(diff(Fs1), type = "h", col = 2, xlab = "", ylab = "", xlim = c(0, 50), main = "poisson-negative binomial")



# ================================================================
# ���Ϸֲ��ľ����1��- ���Ʒ���
# ================================================================
# ���� S1 �ǲ���Ϊ l1 = 2�ĸ��ϲ��ɷֲ����ηֲ�Ϊ��
# q1 = 0.2,    q2=0.7,      q3 = 0.1
# ���� S2 �ǲ���Ϊ l2 = 3 �ĸ��ϲ��ɷֲ����ηֲ�Ϊ��
# q2 = 0.25,    q3 = 0.6,    q4 = 0.15. 
# ��ȷ�� S = S1 + S2�ķֲ���
# S1 �Ĳ���
lam1 <- 1
p1 <- c(0, 0.2, 0.7, 0.1, 0)
# S2 �Ĳ���
lam2 <- 3
p2 <- c(0, 0, 0.25, 0.6, 0.15)
# S �Ĳ���
lam <- lam1 + lam2
p <- (lam1*p1 + lam2*p2)/lam
p

# ���ƹ�ʽ
COMPO = function (lam, f0, f) {
  cum = g = exp(lam*(f0 - 1)) 
  k = 0 # ѭ����ʶ
  repeat {
    k = k + 1
    last = lam / k * sum(1:k * head(f, k) * rev(g))
    g = c(g, last)
    cum = cum + last
    if (cum > 0.9999999) break  
  }
  return(g) 
}

# ���㸴�ϲ��ɵĸ��� PS ����ͼ
par(mfrow = c(1, 1))
p <- c(p, rep(0, 100))
pS <- COMPO(lam, f0 = p[1], f = p[-1])
plot(pS, type = 'h', col = 2)


# ================================================================
# ���Ϸֲ��ľ����2��- Fast Fourier Transformation
# ================================================================
# S1 �Ĳ���
lam1 <- 1
p1 <- c(0, 0.2, 0.7, 0.1, 0)
# S2 �Ĳ���
lam2 <- 3
p2 <- c(0, 0, 0.25, 0.6, 0.15)
# S �Ĳ���
lam <- lam1 + lam2
p <- (lam1*p1 + lam2*p2)/lam
p

z <- fft(c(p, rep(0, 100)))
y <- fft(exp(lam*(z - 1)), inverse = T)/length(z)
pS <- Re(y)

# ���㸴�ϲ��ɵĸ��� PS ����ͼ
plot(pS, type = 'h', col = 2, xlim = c(0, 50))


# ============================================================================
# ��ϰ
# ������10����ͬ�ı�����ϣ����ǵ�������������Ӹ�����ֲ����ֲ������ֱ����£�
# r = 1:10
# �� = 1:10
# ������ 10 ��������Ϻϲ������������ֲ���
# ============================================================================ 

r = 1:10
beta = 1:10
lam = sum(r*log(1+beta))    
fn = function(n)  sum(r*(beta/(1+beta))^n/n/sum(r*log(1+beta)))
x = Vectorize(fn)(1:1000)
z = fft(c(0,x))
y1 = exp(lam * (z - 1))
y2 = fft(y1, inverse = TRUE)/length(z)
p = Re(y2)

sum(p)
n = 1000
mu = sum(p * 0:n)
sigma2 = sum(p * (0:n)^2) - mu^2
plot(0:n, p, type = 'h', xlab = 'n', ylab = 'p_n')
lines(0:n, dnorm(0:n, mean = mu, sd = sqrt(sigma2)), col = 2, lwd = 2)

