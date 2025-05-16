# 这个脚本用于可视化标准paf格式比对，例如lastz的输出
# 正向比对绘制在副对角线上
library(ggplot2)
library(dplyr)

setwd("~/proj/junks/40524_L94/11_Susptrit/find_longest_match/lastz/")

set_strand <- function(input) {
  #调整正负链
  # 选取后再修改，减少计算量
  for (i in 1:dim(input)[1]) {
    if (input[i,]$strand=="-") {
      tmp <- input[i,]$queryStart
      input[i,]$queryStart <- input[i,]$queryEnd
      input[i,]$queryEnd <- tmp
    }
  }
  return(input)
}

input_paf="l94vsmorex.paf"

coords<-read.table(input_paf, fill = T)

colnames(coords)<-c("queryID","queryLen","queryStart","queryEnd","strand",
                    "refID","refLen","refStart","refEnd","numMatch","alignLen","qual")
coords <- coords[,1:12]
coords$percentID<-coords$numMatch/coords$alignLen

# 对于mashmap输出的paf，使用以下代码
#colnames(coords) <- c("queryID","queryLen","queryStart","queryEnd","strand",
#                                  "refID","refLen","refStart","refEnd","sk","alignLen","qual",
#                                  "EID","kc")
#coords$EID <- as.numeric(sapply(strsplit(coords$EID, ":"), function(x) x[3]))


# 过滤过短的片段
# 5000相当于不过滤
coords.filter<-coords[coords$alignLen >= 5000,]

# 排序方便节选
#coords.filter <- coords.filter[order(coords.filter$refStart),]

#coords.filter <- coords.filter %>% 
#  filter(refStart>=5e8)

# 排序
chrs_order <- c("ptg000205l",
                "ptg000410l",
                "ptg000242l",
                "ptg000424l",
                "ptg001294l",
                "ptg000033l",
                "ptg000477l",
                "ptg001268l",
                "ptg000955l",
                "ptg000418l",
                "ptg000072l",
                "ptg000079l",
                "ptg000204l",
                "ptg001149l",
                "ptg001122l",
                "ptg001253l",
                "ptg001165l",
                "ptg001063l",
                "ptg000351l",
                "ptg001776l",
                "ptg000124l",
                "ptg001096l",
                "ptg001877l",
                "ptg000191l",
                "ptg001338l",
                "ptg001039l",
                "ptg000868l",
                "ptg000909l",
                "ptg001681l",
                "ptg001947l",
                "ptg001439l",
                "ptg001245l")

# 定向
chrs_reverse <- c("ptg000410l",
                  "ptg000424l",
                  "ptg001294l",
                  "ptg000033l",
                  "ptg000477l",
                  "ptg000955l",
                  "ptg000418l",
                  "ptg000204l",
                  "ptg001122l",
                  "ptg001253l",
                  "ptg000351l",
                  "ptg001776l",
                  "ptg001877l",
                  "ptg000191l",
                  "ptg000868l",
                  "ptg000909l",
                  "ptg001947l")

# 选取contig并设置顺序
coords.filter <- coords.filter[is.element(coords.filter$queryID,
                                          chrs_order),]
coords.filter <- set_strand(coords.filter)

for (i in 1:dim(coords.filter)[1]) {
  if (is.element(coords.filter[i,]$queryID, chrs_reverse)) {
    coords.filter[i,]$queryStart <- -coords.filter[i,]$queryStart
    coords.filter[i,]$queryEnd <- -coords.filter[i,]$queryEnd
  }
}

coords.filter$queryID <- factor(coords.filter$queryID,
                                levels = chrs_order)


ggplot(coords.filter) +
  geom_segment(aes(y=refStart, x=queryStart, yend=refEnd, xend=queryEnd, color=percentID)) +
  geom_point(aes(y=refStart, x=queryStart, color=percentID)) +
  geom_point(aes(y=refEnd, x=queryEnd, color=percentID)) +
  scale_colour_viridis_c(name = "approx. identity",begin = 1,end = 0.3)  +
  facet_grid(.~queryID, scales = "free_x", space = "free_x", switch = "x") +
  scale_y_reverse(breaks = seq(5e8,6.5e8,5e7), labels = function(x){x/1e6}) +
  labs(y="l94 ptg000032l",x="SusPtrit contigs") +
  theme(strip.text = element_text(angle = 45),
        axis.title.y = element_text(angle = 270)) +
  coord_cartesian(expand = F, ylim = c(0,NA)) +
  geom_blank()

