if(!"tidyverse" %in% installed.packages()) install.packages("tidyverse")

library("tidyverse")

n <- 100 
tibble(x = runif(n),  
       y = runif(n),  
       s = runif(n, min = 4, max = 20)) %>%
  ggplot(aes(x, y, size = s)) +
  geom_point(color = "white", pch = 42) +
  scale_size_identity() +
  coord_cartesian(c(0,1), c(0,1)) +
  theme_void() +
  theme(panel.background = element_rect("black"))


### ANIMATED SNOW === BY PAULVANDERLAKEN.COM
### PUT THIS FILE IN AN RPROJECT FOLDER

# load in packages
pkg <- c("here", "tidyverse", "gganimate", "animation")
sapply(pkg, function(x){
  if (!x %in% installed.packages()){install.packages(x)}
  library(x, character.only = TRUE)
})

# parameters
n <- 100 # number of flakes
times <- 100 # number of loops
xstart <- runif(n, max = 1) # random flake start x position
ystart <- runif(n, max = 1.1) # random flake start y position
size <- runif(n, min = 4, max = 20) # random flake size
xspeed <- seq(-0.02, 0.02, length.out = 100) # flake shift speeds to randomly pick from
yspeed <- runif(n, min = 0.005, max = 0.025) # random flake fall speed

# create storage vectors
xpos <- rep(NA, n * times)
ypos <- rep(NA, n * times)

# loop through simulations
for(i in seq(times)){
  if(i == 1){
    # initiate values
    xpos[1:n] <- xstart
    ypos[1:n] <- ystart
  } else {
    # specify datapoints to update
    first_obs <- (n*i - n + 1)
    last_obs <- (n*i)
    # update x position
    # random shift
    xpos[first_obs:last_obs] <- xpos[(first_obs-n):(last_obs-n)] - sample(xspeed, n, TRUE)
    # update y position
    # lower by yspeed
    ypos[first_obs:last_obs] <- ypos[(first_obs-n):(last_obs-n)] - yspeed
    # reset if passed bottom screen
    xpos <- ifelse(ypos < -0.1, runif(n), xpos) # restart at random x
    ypos <- ifelse(ypos < -0.1, 1.1, ypos) # restart just above top
  }
}

# store in dataframe
data_fluid <- cbind.data.frame(x = xpos,
                               y = ypos,
                               s = size,
                               t = rep(1:times, each = n))

# create animation
snow <- data_fluid %>%
  ggplot(aes(x, y, size = s, frame = t)) +
  geom_point(color = "white", pch = 42) +
  scale_size_identity() +
  coord_cartesian(c(0, 1), c(0, 1)) +
  theme_void() +
  theme(panel.background = element_rect("black"))

# save animation
gganimate(snow, filename = here("snow.gif"), title_frame = FALSE, interval = .1)