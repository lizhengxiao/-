# ==============================================
# ���� Copula �����ĳ������
# ==============================================

library(rgl)
u1 <- seq(0, 1, length = 100)
u2 <- seq(0, 1, length = 100)
f <- function(u1, u2) u1 * u2  #����copula
CI <- outer(u1, u2, f)
persp3d(u1, u2, CI, col = "blue")
CU <- array(NA, dim = c(100, 100))
for (i in 1:100) {
  for (j in 1:100) CU[i, j] = min(u1[i], u2[j])
}  # ͬ����copula���Ͻ�
persp3d(u1, u2, CU, col = "red")
CL <- array(NA, dim = c(100, 100))
for (i in 1:100) {
  for (j in 1:100) CL[i, j] = max(u1[i] + u2[j] - 1, 0)
  }  # ������copula���½�
persp3d(u1, u2, CL, col = "yellow")

# ==============================================
# Spearman��s rho �� Kendall��s tau�Ĺ�ϵ
# ==============================================
# tao >= 0
k = seq(0, 1, 0.01)  #tao��ȡֵ
s1 = (3 * k - 1)/2   #rho���½�
s2 = (1 + 2 * k - k^2)/2  #rho���Ͻ�
plot(k, s1, type = "l", xlab = "tau", ylab = "rho", las = 1)
lines(k, s2, col = 2, lty = 2)
legend("bottomright", c("rho������", "rho������"), col = c(1, 2), lty = c(1, 2))

# tao < 0
k = seq(-1, 0, 0.01)
s1 = (k^2 + 2 * k - 1)/2
s2 = (1 + 3 * k)/2
plot(k, s1, type = 'l', ylim = c(-1, 1), xlab = 'tau', ylab = 'rho', las = 1)
lines(k, s2, col = 2, lty = 2)
legend('topleft', c('rho������', 'rho������'), col = c(1, 2), lty = c(1, 2))


# ==============================================
# ��ϰ
# ==============================================
options(digits = 2)
# ��������
shape = 2
scale = 500
meanlog = 5
sdlog = 1
alpha = 10
# ģ��X�Ĺ۲�ֵ
set.seed(111)
n = 10  #ģ��10���۲�ֵ
u1 = runif(n, 0, 1)
x1 = qgamma(u1, shape = shape, scale = scale)
# u2�������ֲ��������溯��
f2 = function(q, alpha, u) {
  -1/alpha * log(1 - (1 - exp(-alpha))/(1 + (1/q - 1) * exp(-alpha * u)))
  }
# ģ���λ��ˮƽq
q = runif(n, 0, 1)
# ģ��u2��X2
u2 = f2(q, alpha, u1)
x2 = qlnorm(u2, meanlog = meanlog, sdlog = sdlog)
# ��x1,x2����ģ��ֵ
cbind(x1, x2)
# frank copula���ܶȺ���
pdffrank = function(alpha, u1, u2) {
  alpha * exp(-alpha * (u1 + u2) * (1 - exp(-alpha)))/(exp(-alpha * (u1 + 
                                                                       u2) - exp(-alpha * u1) - exp(-alpha * u2) + exp(-alpha)))^2
  }
# ����(x1,x2)���ܶȺ���
pdf = function(x1, x2) {
  f1 = function(x1) dgamma(x1, shape = shape, scale = scale)
  F1 = function(x1) pgamma(x1, shape = shape, scale = scale)
  f2 = function(x2) dlnorm(x2, meanlog = meanlog, sdlog = sdlog)
  F2 = function(x2) plnorm(x2, meanlog = meanlog, sdlog = sdlog)
  return(f1(x1) * f2(x2) * pdffrank(alpha, F1(x1), F2(x2)))
  }
# ����ͼ
x1 = seq(0, 5000, 50)
x2 = seq(0, 2000, 50)
D = outer(x1, x2, pdf)
library(rgl); persp3d(x1,x2,D,col=2) #��ά����
persp(x1, x2, D, col = "lightblue", theta = 20, phi = 40, expand = 0.5)
# imageͼ
x1 = seq(0, 4000, 10)
x2 = seq(0, 2000, 10)
D = outer(x1, x2, pdf)
image(x1, x2, D)



# �����ģ��ķ��������ٱ��յĴ�����
set.seed(111)
sim = 1000  #ģ��sim��
n = 5000  #ÿ��ģ��n������
prem = NULL
for (i in 1:sim) {    # ģ��u1��X1
  u1 = runif(n, 0, 1)
  x1 = qgamma(u1, shape = shape, scale = scale)
  # u2�������ֲ��������溯��
  f2 = function(q, alpha, u) {
    -1/alpha * log(1 - (1 - exp(-alpha))/(1 + (1/q - 1) * exp(-alpha * u)))
  }
  # ģ���λ��ˮƽq
  q = runif(n, 0, 1)
  # ģ��u2��X2
  u2 = f2(q, alpha, u1)
  x2 = qlnorm(u2, meanlog = meanlog, sdlog = sdlog)
  # �ٱ��յĴ�����
  dt = data.frame(x1, x2)
  dt1 = subset(dt, x1 > 100 & x2 > 100)
  prem[i] = sum(dt1$x1 + dt1$x2 - 200)/n
}

# ��������ѵ�ģ��ֵ
summary(prem)

# ==============================================
# ģ���Ԫ�ֲ���������Copula
# ==============================================
library(copula)
shape1 = 10
scale1 = 30
shape2 = 20
scale2 = 40
mycop = normalCopula(0.6)  #������̬copula
mycop
## Normal copula family 
## Dimension:  2 
## Parameters:
##   rho.1  =  0.6
rCopula(10, mycop)  #ģ��10��۲�ֵ
f1 = function(x1) dgamma(x1, shape = shape1, scale = scale1)
F1 = function(x1) pgamma(x1, shape = shape1, scale = scale1)
f2 = function(x2) dgamma(x2, shape = shape2, scale = scale2)
F2 = function(x2) pgamma(x2, shape = shape2, scale = scale2)
x1 = seq(0, 1000, 10)
x2 = seq(0, 2000, 10)
D = array(NA, dim = c(length(x1), length(x2)))
for (i in 1:length(x1)) {
  for (j in 1:length(x2)) D[i, j] = f1(x1[i]) * f2(x2[j]) * dCopula(c(F1(x1[i]), 
                                                                      F2(x2[j])), mycop)
  }
persp(x1, x2, D, col = 2)

# ==============================================
# �����׵�Copula��ģ�⣺
# ==============================================
options(digits=2)
library(copula)
mycop = frankCopula(8)  #����copula
mycop
## Frank copula family; Archimedean copula 
## Dimension:  2 
## Parameters:
##   param  =  8
u = rCopula(10, mycop)  #ģ��copula�������
plot(u)                 #�������ɢ��ͼ
dCopula(u, mycop)  #copula���ܶȺ���ֵ
pCopula(u, mycop)  #copula�ķֲ�����ֵ
persp(mycop, dCopula, col ='lightblue')  #�ܶȺ���
persp(mycop, pCopula, col='lightblue')  #�ֲ�����
contour(mycop, pCopula)     #�ȸ���
