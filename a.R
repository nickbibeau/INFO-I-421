samples <- tibble(
  a = c(1,0,2,1,0,3),
  b = c("apple","berry","pear","apple","berry","apple"),
  class = c("yes","no","no","yes","yes","no")
)

#entropy of the entire set 0.9709506
counts <- (samples %>% 
             select(class) %>%
             group_by(class) %>%
             summarise(count=n())
)$count
entropy_set <- entropy.gini(counts, type=2)$entropy 


#======Information Gain
#1.If split on b,information(before)-information(after)
#information(before):entropy(c(3,2))
#information(after): sum up weighted entropy over subsets
info.before <- entropy_set

subsets.b <- table(samples$b,samples$class)
subsets.b["apple",]
subsets.b["berry",]
subsets.b["pear",]
#each subset
entropy.apple <- entropy.gini(subsets.b["apple",],type=2)$entropy
entropy.berry <- entropy.gini(subsets.b["berry",],type=2)$entropy
entropy.pear <- entropy.gini(subsets.b["pear",],type=2)$entropy
#weighted sum
total <- nrow(samples)
w1 <- sum(subsets.b["apple",])/total
w2 <- sum(subsets.b["berry",])/total
w3 <- sum(subsets.b["pear",])/total
info.b <- w1*entropy.apple + w2*entropy.berry + w3*entropy.pear

#information reduction via b
gain.b <- info.before - info.b #0.2075187


#2.If split on a,
unique(samples$a)
table(samples$a,samples$class)
# threshold: >1, <=1
set.left <- samples %>%
  filter(a>1) %>%
  select(a,class) %>%
  mutate(tag=ifelse(class=="yes",1,0))
set.right <- samples %>%
  filter(a<=1) %>%
  select(a,class) %>%
  mutate(tag=ifelse(class=="yes",1,0))
# subset entropy
e1 <- entropy.gini(set.left$tag, type=1, discrete=1)$entropy
e2 <- entropy.gini(set.right$tag, type=1, discrete=1)$entropy
# weighted sum
total <- nrow(samples)
w1 <- nrow(set.left)/total
w2 <- nrow(set.right)/total
info.a <- w1*e1 + w2*e2
#information reduction via b
gain.a <- info.before - info.a 


#Compare gain.b and gain.b. Pick the one with the greater gain.
# a or b?


#=======Gini-index
#weighted sum of gini over every subset
#b
g1 <- entropy.gini(subsets.b["apple",],type=2)$gini
g2 <- entropy.gini(subsets.b["berry",],type=2)$gini
g3 <- entropy.gini(subsets.b["pear",],type=2)$gini
#weighted sum
total <- nrow(samples)
w1 <- sum(subsets.b["apple",])/total
w2 <- sum(subsets.b["berry",])/total
w3 <- sum(subsets.b["pear",])/total
gini.b <- w1*g1 + w2*g2 + w3*g3 #0.48

#a
g1 <- entropy.gini(set.left$tag, type=1, discrete=1)$gini
g2 <- entropy.gini(set.right$tag, type=1, discrete=1)$gini
# weighted sum
total <- nrow(samples)
w1 <- nrow(set.left)/total
w2 <- nrow(set.right)/total
gini.a <- w1*g1 + w2*g2 #0.25

#Compare gini.b and gini.b. Pick the one with the lower gini index
# a or b?


#========Tree by rpart
library("rpart")
library("rpart.plot")
library("party")
library("tidyverse")

set.seed(20)
fit <- rpart(class~a+b,
             method="class", data=samples,
             control=rpart.control(minsplit = 1,cp=0),
             parms=list(split='information'))
summary(fit)
rpart.plot(fit,type=4,extra=2,roundint=FALSE)