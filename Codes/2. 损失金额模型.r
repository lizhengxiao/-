# ==============================================================================================
# 2. ��ʧ���ģ��
# ==============================================================================================
# -----------------------------------------------------------------------------------
# 2.1 ���˹�ֲ�ͼ
# -----------------------------------------------------------------------------------
x = seq(0, 4, 0.01)
f1 = sqrt(0.5/(2*pi*x^3))*exp(-0.5*(x-1)^2/(2*1^2*x))
f2 = sqrt(1/(2*pi*x^3))*exp(-1*(x-1)^2/(2*1^2*x))
f3 = sqrt(5/(2*pi*x^3))*exp(-5*(x-1)^2/(2*1^2*x))
f4 = sqrt(10/(2*pi*x^3))*exp(-10*(x-1)^2/(2*1^2*x))
matplot(x, cbind(f1, f2, f3, f4), type='l', lty=1:4, lwd=2)
legend(2, 1, c('IG(1, 0.5)', 'IG(1, 1)', 'IG(1, 5)', 'IG(1, 10)'), lty=1:4, col=1:4, lwd=c(3, 3, 3, 3))
# -----------------------------------------------------------------------------------
# 2.2 Tweedie �ֲ�ģ��
# -----------------------------------------------------------------------------------
lambda = 1                         # ���ɵĲ���
alpha = 10  ;   beta = 2      # ٤��ֲ��Ĳ�����betaΪrate����
n = 10000                            # ģ�����
Y = NULL                              # tweedieģ��ֵ
set.seed(11)
for ( i in 1:n) {
  N = rpois(1,  lambda)
  Y[i] = sum(rgamma(N, shape =  alpha,  rate = beta))
}
hist(Y,  breaks = 50,  col = 'grey',  main = 'Tweedieģ��')

# -----------------------------------------------------------------------------------
# 2.3 ����X���Ӳ���Ϊ (3,  4) ��٤��ֲ�, ��g(X)�ķֲ���
# -----------------------------------------------------------------------------------
# ٤��ֲ����ܶȺ���
f = function(x)  dgamma(x,  3,  4)
### �߶ȱ任,   Y = 2X
f1 = function(x)  f(x/2)/2
### �ݱ任,  Y = X ^ (1/2)
f2 = function(x)  f(x^2) * 2 * x
### ��任,  Y = 1/X
f3 = function(x)   f(1/x)/x^2
### ָ���任,  Y = exp(X)
f4 = function(x)   f(log(x))/x
### �����任,   Y = log(X)
f5 = function(x)    f(exp(x)) * exp(x)
x <- seq(0, 4, 0.01)
matplot(x, cbind(f1(x), f2(x), f3(x), f4(x), f5(x)), type='l', lty=1:4, lwd=2)
legend(3, 1.5, c('X', '2X', 'X^1/2', '1/X', 'ln(x)'), lty=1:4, col=1:4, lwd=c(3, 3, 3, 3))


# -----------------------------------------------------------------------------------
# 2.4 ���� ����������̬�ֲ��Ĳ����ֱ�Ϊ(1, ????)��(????, ????), �������30%��70%�ı��������ǽ��л��, ���Ϸֲ����ܶȺ�����
# -----------------------------------------------------------------------------------
p = 0.3
m1 = 1; s1 = 2
m2 = 3; s2 = 4
## ��϶�����̬�ֲ����ܶȺ���
f = function(x)  p * dlnorm(x,  m1,  s1) + (1 - p) * dlnorm(x,  m2,  s2)
curve(f,  xlim = c(0,  1),  ylim = c(0,  2),   lwd = 2,  col = 2)
curve(dlnorm(x,  m1,  s1),  lty = 2,  add = TRUE)
curve(dlnorm(x,  m2,  s2),  lty = 3,  add = TRUE)
legend("topright",  c("mixed lnorm",  "lnorm(1, 10)",  "lnorm(2, 20)"),  lty = c(1,  2,  3),  col = c(2,  1,  1),  lwd = c(2,  1,  1))


# -----------------------------------------------------------------------------------
# 2.5 ���ָ���ֲ�
# -----------------------------------------------------------------------------------
x = seq(0,  10,  0.01)
y1 = 1-pexp(x,  rate = 2)
y2 = 1-pexp(x,  rate = 3)
q = 0.7
y = q*y1 + (1 - q)* y2
matplot(x,  cbind(y1,  y2,  y),  lty=c(2,3,1),type = 'l',  col=c(1,2,4), xlim = c(0,  3), lwd=2, main = '���溯��')
legend('topright',  c('ָ����rate = 2��', 'ָ����rate = 3��',  '���ָ����q = 0.7��'),  lty=c(2,3,1), col=c(1,2,4))


# -----------------------------------------------------------------------------------
# 2.6 ���ֹ��Ʒ����ıȽ�
# -----------------------------------------------------------------------------------
# ģ��٤��ֲ��������
set.seed(123);  x = rgamma(50, 2)  
# ����fitdistrplus�����
library(fitdistrplus)  
# �ü�����Ȼ�����Ʋ���
fit1 = fitdist(x,  'gamma',  method = 'mle')  
# �þع��Ʒ����Ʋ���
fit2 = fitdist(x, 'gamma', method = 'mme')  
# �÷�λ����ȷ����Ʋ���
fit3 = fitdist(x, 'gamma', method = 'qme', probs = c(1/3, 2/3))  
#����С���뷨���Ʋ���
fit4 = fitdist(x, 'gamma', method = 'mge', gof = 'CvM')  
#����������ƽ��
fit1  
plot(fit1)

#  ���� optim/optimize �����Էֲ��Ĳ������й���
lower = c(0, 100, 200, 500)    #��ʧ����
upper = c(100, 200, 500, Inf)  #��ʧ����
freq = c(15, 20, 10, 5)       #��ʧ����
# ָ���ֲ��ļ�����Ȼ����
f1 = function(a) {-sum(freq * log(pexp(upper, a) - pexp(lower, a)))}
optimize(f1,  c(1/10000, 1/100))   #��ʼֵ���ݾع���ֵѡ��

# -----------------------------------------------------------------------------------
# 2.7 ��������
# ------------------------------------------------------------------------------------------------
# ���ó����CASdatasets�е����ݼ�freMTPLsev, Ӧ���ʵ���ģ�����ClaimAmount�ķֲ���
# ׼����
library(CASdatasets)
#׼������
data(freMTPLsev)  
x <- freMTPLsev$ClaimAmount
summary(x)
quantile(x, 90:100/100)
x <- x[x<=100000]
hist(x, breaks = 100000, xlim = c(0, 10000))
#------------��������x�ֶ�---------------
c1 = 400; c2 = 1000; c3 = 1300; c4 = 5000
index1 <- which(x<=c1)
index2 <- which(x>c1 & x<=c2)
index3 <- which(x>c2 & x<=c3)
index4 <- which(x>c3 & x<=c4)
index5 <- which(x>c4)
#������̬�ֲ����
fit1 = fitdist(x[index1], 'lnorm')
fit2 = fitdist(x[index2], 'lnorm')
fit3 = fitdist(x[index3], 'lnorm')
fit4 = fitdist(x[index4], 'lnorm')
##��β�������зֲ����
dpareto = function(x, alpha, theta=c4) alpha*theta^alpha/x^(alpha+1) 
ppareto = function(x, alpha, theta=c4) 1-(theta/x)^alpha
fit5=fitdist(x[index5], 'pareto', start = 5)  #�����д�c3�Ժ��ж���

hist(x[index5], freq = F)
curve(dpareto(x, fit5$estimate[1]), add = T)

#------------�õ�����ֲ��Ĺ��Ʋ���-----------
m1 <- fit1$estimate[1]
s1 <- fit1$estimate[2]
m2 <- fit2$estimate[1]
s2 <- fit2$estimate[2]
m3 <- fit3$estimate[1]
s3 <- fit3$estimate[2]
m4 <- fit4$estimate[1]
s4 <- fit4$estimate[2]
m5 <- fit5$estimate[1]
s5 <- fit5$estimate[2]

#######ʹ�÷ֶ���ϵ�Ȩ��
w1 = length(index1)/length(x)
w2 = length(index2)/length(x)
w3 = length(index3)/length(x)
w4 = length(index4)/length(x)
w5 = length(index5)/length(x)

f = function(x) {
  ifelse(x <= c1, w1*dlnorm(x, m1, s1)/(plnorm(c1, m1, s1)),
         ifelse(x > c1 & x <= c2, w2*dlnorm(x, m2, s2)/(plnorm(c2, m2, s2) - plnorm(c1, m2, s2)), 
                ifelse(x > c2 & x<= c3, w3*dlnorm(x, m3, s3)/(plnorm(c3, m3, s3) - plnorm(c2, m3, s3)),
                       ifelse(x > c3 & x<= c4, w4*dlnorm(x, m4, s4)/(plnorm(c4, m4, s4) - plnorm(c3, m4, s4)),
                              w5*dpareto(x, m5)))))
}  

hist(x, breaks=5000, xlim = c(0, 6000), prob=TRUE,  main = "",  xlab = "�����", col='grey')
curve(f, xlim=c(0, 6000), add=T,  col=2,  lwd=2)





