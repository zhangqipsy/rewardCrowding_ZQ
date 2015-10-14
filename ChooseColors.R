cat('Consider using these websites as well:\n', 'http://colorizer.org/\n', 'http://davidjohnstone.net/pages/lch-lab-colour-gradient-picker\n')
require(plyr)
require(graphics)
require(stats) # for na.omit

## The displayable colors from four planes of Lab space
a = (-100:150)
b = (-150:100)
ab <- expand.grid(a,b)

L = 50
Lab <- cbind(L, ab)

cat(sprintf('Generating...\n'))
srgb <- convertColor(Lab, from = "Lab", to = "sRGB", clip = NA)
clipped <- attr(na.omit(srgb), "na.action")
srgb[clipped, ] <- 0
cols <- rgb(srgb[, 1], srgb[, 2], srgb[, 3])

cat(sprintf('Drawing...\n'))
image(a, b, matrix(1:(length(a)*length(b)), ncol = length(a)), col = cols,
      xlab = "a", ylab = "b", main = "Lab: L=50")

cat('1.Maximize the Figure window to have better precision\n 2.Click on the figure and select several preferred colors,\n 3. then press ESC (or Right Click on some systems)\n')

selectedList <- locator()
cat(sprintf('Got %d color points.\n', length(selectedList$x)))

coor = data.frame(selectedList)
colnames(coor) <- c("a", "b")
coor$L = 50

# transfer back from Lab to RGB for the selected colors
sRGBcolors <- adply(coor, 1, function (Lab) 255*convertColor(Lab, from="Lab", to="sRGB", clip = NA))
colnames(sRGBcolors)[4:6] <- c("R", "G", "B")

print(sRGBcolors)
write.csv(sRGBcolors, file="LabConvertedColors.csv")
