

dino <-read.table("datasaurus.txt", header=TRUE)
with(dino, plot(x,y))

# on peut aussi le faire avec ggplot2
library(ggplot2)

ggplot(dino, aes(x=x,y=y))+
  geom_point(size=3, colour="red")


ggplot(dino, aes(x=x,y=y))+
  geom_point(size=5, colour="green")
