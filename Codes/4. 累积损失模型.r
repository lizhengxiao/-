# =============================================================================
# һ���������ģ��
# ============================================================================

# =============================================================================
# ��������������
# ============================================================================
library(actuar)
pn = c(0.3, 0.5, 0.2)              #��ʧ�����ĸ��ʷֲ�
fx = c(0.2, 0.4, 0.2, 0.1, 0.1)    #��ʧ���ĸ��ʷֲ�
Fc = aggregateDist("convolution", model.freq = pn, model.sev = fx, x.scale = 100)
plot(Fc)

#�ۻ���ʧ�ĸ���
diff(Fc) # Ʃ�磬�ۻ���ʧ����0�ĸ���Ϊ0.408���ۻ���ʧ����800�ĸ���Ϊ0.02��

# =============================================================================
# ���Ʒ�
# ============================================================================
# �����ͷֲ���ɢ��
# 1. rouding and mathcing method (��ʽ����)
x = 1:30;
y1 = exp(-0.1*(2*x-1))-exp(-0.1*(2*x+1))
y2 = -10*exp(-0.2*x) + 5*exp(-0.2*(x-1))+5*exp(-0.2*(x+1))
y_rounding = c(0.09516, y1)
y_matching = c(0.09365, y2)
par(mfrow = c(1,2))
matplot(c(0,x), cbind(y_rounding, y_matching), type = 'h', xlab = 'i', ylab = 'fi', col = c(2,4), lwd = 2)
plot(y_rounding, y_matching)
abline(0,1)

# 2. rouding and mathcing method (���� discretize ����)
x = 0:30;
y_rounding2 <- discretize(cdf = pexp(x, rate = 0.1), from = 0, to = 60, step = 2, method = "rounding")
y_rounding2
par(mfrow = c(1,1))
plot(y_rounding[1:30], y_rounding2[1:30]) # ���ַ�����õĽ����һ����

# 3. �����ͷֲ� VS ��ɢ�ͷֲ�
par(mfrow = c(1,1))
x <- seq(0, 50, 2)
curve(pexp(x, rate = 0.1), xlim = c(0, 50), type = 'l', ylim = c(0, 1),
     ylab = 'ָ���ֲ����ۻ��ֲ�����')
fr <- discretize(pexp(x, rate = 0.1), from = 0, to = 50, step = 2, method = "rounding")                              # ��ɢ���ֲ���ĸ��ʺ���
fu <- discretize(pexp(x, rate = 0.1), from = 0, to = 50, step = 2, method = "unbiased", lev = levexp(x, rate = 0.1)) # ��ɢ���ֲ���ĸ��ʺ���

plot(stepfun(head(x, -1), diffinv(fr)), pch = 18,
     add = TRUE,
     col = 'red')
plot(stepfun(x, diffinv(fu)), pch = 18,
     add = TRUE,
     col = 'blue')
legend(30, 0.4, 
       legend = c("�����ֲ�", "Rounding", "Unbiased"),
       col = c('black', "red", "blue"), 
       pch = 19, lty = 1)

# 4. ���Ʒ� (aggregateDist����)
# ���ȶ�ָ���ֲ�������ɢ���õ�ǿ�ȷֲ���Ƶ���ֲ�ѡ�� poisson �ֲ�, �ر�
# ָ��poisson �ֲ����� lambda = 2��
x <- seq(0, 50, 0.1)
fx <- discretize(pexp(x, 1), from = 0, to = 100, method = "rounding")
Fs <- aggregateDist(method = "recursive", model.freq = "poisson",
                    model.sev = fx, lambda = 2)
par(mfrow = c(1,1))
plot(Fs)


# =============================================================================
# ���Ʒ���������ϰ(�Զ��庯��)
# ============================================================================
# �� pareto ��ɢ�����󸴺Ϸֲ�S
dpareto <- function(x) {
  L = 4 * (10^4)/((x + 10)^(4 + 1))
  return(L)
  }
ppareto <- function(x) {
  L = 1 - (10/(x + 10))^4
  return(L)
  }
v = 1 - ppareto(6)
lambda = 3 * v
Yp <- function(y) {
  if (y < 13.5)
    L = 1 - (1 - ppareto(y/0.75 + 6))/v else L = 1
    return(L)
}
# pareto�ֲ�����ɢ��
h = 2.25
f = Yp(h/2)
k = 0
repeat {
  k = k + 1
  last = Yp((k + 0.5) * h) - Yp((k - 0.5) * h)
  f = c(f, last)
  if (sum(f) >= 0.99) 
  break
  }
# ���ƹ�ʽ��S
g = exp(-lambda * (1 - f[1]))
k = 0
repeat {
  k = k + 1
  summ = 0
  if (k < length(f)) 
    upper = k else upper = length(f) - 1
  for (j in 1:upper) {
    summ = summ + j * f[j + 1] * g[k - j + 1]
    }
  g = c(g, summ * lambda/k)
  if (sum(g) > 0.999999) 
    break
  }
sum(g)
## [1] 0.9999995
g
plot(g, type = 'h', lwd = 2, xlab = '0:(k)')


# =============================================================================
# ��ת����Inversion method����FFT - ���ٸ���Ҷ����
# ============================================================================
x = c(0,  0.5,   0.4,   0.1 ,   rep(0,  40))      # ��ʧ���
phi_x = fft(x)                                    # ��ʧ������������
phi_s = exp(3*( phi_x - 1));                      # �ۻ���ʧ����������
fs = fft(phi_s,  inverse = TRUE)/length(phi_s) 
fs = Re(fs)                                       # �ۻ���ʧ�ĸ��ʺ���(returning the real part)
Fs = cumsum(fs)                                  # �ۻ���ʧ�ķֲ�����
par(mfrow = c(1,  2))
plot(0:(length(fs)-1),  fs,  type = 'h',  xlim = c(0,  30),  col = 2, xlab = 'fs', ylab = 'f(s)')
plot(0:(length(Fs)-1),  Fs,  type = 's',  xlim = c(0,  30),  col = 2,  xlab = 's', ylab = 'Fs')




# =============================================================================
# ���ģ�⣨Simluation��
# ============================================================================
lam = 3                   #���ɲ���
mu = 6; sigma = 1.5       #������̬�ֲ��Ĳ���
u = 1000
s = n = NULL
for ( i in 1:10000) {
  n[i] = rpois(1, lambda = lam)
  s[i] = sum(pmin(rlnorm(n[i], meanlog = mu, sdlog = sigma), u))
  s[i] = round(s[i])
}
par(mfrow = c(1, 2))
hist(s, freq = F, breaks = 1000, col = 2, main = '')
s = sort(s)
plot(s, cumsum(s)/sum(s), type = 's', col = 2)





# =============================================================================
# �����������ģ��
# ============================================================================
# =======================================
# 1. ����ֲ��Ͳ��ɷֲ�(��ȷ�ֲ�)
# =======================================
q <- 0.001
n <- 1000
# ����� S ���Ӷ���ֲ�(1000,0.001)��Ҳ���Խ��Ʒ���lambda = 1�Ĳ��ɷֲ�
# P(S>=3.5)�ĸ���Ϊ
1 - pbinom(3.5, 1000, 0.001)
ps1 <- 1 - ppois(3.5, 1)
ps1
# =======================================
# 2. ��̬����
# =======================================
# ���ݾع��Ƶõ���̬�ֲ����������� mu �� sigma
mu <- 1
sigma2 <- 0.999
ps2 <- 1 - pnorm(3.5, mean = mu, sd = sqrt(sigma2))
ps2

# =======================================
# 3. ������̬����
# =======================================
# ���ݾع��Ƶõ�������̬�ֲ����������� mu �� sigma
mu <- -0.34657
sigma <- 0.83256
ps3 <- 1 - plnorm(3.5, mu, sigma)
ps3
# =======================================
# 4. ƽ��٤�����
# =======================================
# ���ݾع��Ƶõ�ƽ��٤��ֲ����������� x0 alpha beta
x0 <- -1
alpha <- 4 
beta <- 2
# S + 1 ���Ӳ���Ϊ (4,2) ��٤��ֲ�
ps4 <- 1 - pgamma(4.5, shape = 4, rate = 2)
ps4
# =======================================
# 5. NP ����
# =======================================
# ���ɷֲ��ľ�ֵ�����ƫ��ϵ��Ϊ 1
mu <- sigma <- gamma <- 1
a <- - 3/gamma + sqrt(9/gamma^2 + 1 + 6/gamma * (3.5 - mu)/ sigma)
ps5 <- 1 - pnorm(a)
# =======================================
# 6. �ȽϽ��
# =======================================
dt <- data.frame(rbind(ps2, ps3, ps5, ps4))
rownames(dt) <- c('Normal', 'Lognormal', 'Normal power', 'Translated gamma')
colnames(dt) <- '��ȷֵ��0.0190'
dt$Error <- rbind(ps2, ps3, ps5, ps4) - ps1
round(dt, 4)


# =======================================
# 7. �������ģ�͵ĸ��ϲ��ɽ���
# =======================================
# ����һ��
q = c(0.00149, 0.00142, 0.00128, 0.00122, 0.00123, 0.00353, 0.00394, 0.00484, 0.02182, 0.0005, 0.0005, 0.00054, 0.00103, 0.00479)
B = c(15, 16, 20, 28, 31, 18, 26, 24, 60, 14, 17, 19, 30, 55)
library(distr)
S = 0
for (i in 1:14)
  S = S + B[i]*Binom(1, q[i])
F1 = p(S)(0:100)
plot(S, do.points = FALSE, xlim = c(0, 100), lwd = 2)

# ��������
q = c(0.00149, 0.00142, 0.00128, 0.00122, 0.00123, 0.00353, 0.00394, 0.00484, 0.02182, 0.00050, 0.00050, 0.00054, 0.00103, 0.00479)
B = c(15, 16, 20, 28, 31, 18, 26, 24, 60, 14, 17, 19, 30, 55)

library(distr)
S = DiscreteDistribution(supp = c(0, B[1]),prob = c(1 - q[1], q[1]))
for (i in 2:length(B)){
  S = S + DiscreteDistribution(supp = c(0,B[i]),prob = c(1-q[i], q[i]))
}

F2 = p(S)(0:100)
plot(S, do.points = FALSE, xlim=c(0, 100), lwd = 1)

# ��������
q = c(0.00149, 0.00142, 0.00128, 0.00122, 0.00123, 0.00353, 0.00394, 0.00484, 0.02182, 0.00050, 0.00050, 0.00054, 0.00103, 0.00479)
B = c(15, 16, 20, 28, 31, 18, 26, 24, 60, 14, 17, 19, 30, 55)
library(data.table)
dt = data.table(q, B)
dt[, list(p = sum(q)), by = B]  #�ϲ���ͬ���ս��������
setkey(dt, B)       #�����ս�˳������
lam = dt[, sum(q)]  #���㲴�ɷֲ���lambda����
dt[, p:= p/lam]     #���㲻ͬ���ս�ĸ���p
#������ֵ,  ʹ��b1��p1�Ǵηֲ����������ʷֲ�
b1 = p1 = rep(0,  500)
b1[b + 1] = dt$B
p1[b + 1] = dt$p


f = fft(exp(lam*(fft(p1) - 1)), inverse = TRUE)/length(p1) #FFT
f = Re(f)
F3 = cumsum(f)
plot(F3, type = 'l')



plot(F1, type='l')
lines(F3, col=2, lty=2)
legend(60,0.97,c('���','���ϲ��ɽ���'),,col=1:2,lty=1:2)


