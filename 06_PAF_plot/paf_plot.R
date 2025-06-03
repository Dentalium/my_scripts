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

input_paf="00032vsselected.paf"

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
chrs_order <- c("ptg001551l",
                "ptg000831l",
                "ptg000098l",
                "ptg000323l",
                "ptg000093l",
                "ptg001835l",
                "ptg000245l",
                "ptg002568l",
                "ptg002045l",
                "ptg000450l",
                "ptg003343l",
                "ptg000705l",
                "ptg001293l",
                "ptg002279l",
                "ptg000419l",
                "ptg000677l",
                "ptg001745l",
                "ptg000047l",
                "ptg001088l",
                "ptg000893l",
                "ptg000359l")

# 定向
chrs_reverse <- c("ptg001551l",
                  "ptg000098l",
                  "ptg000245l",
                  "ptg002568l",
                  "ptg000450l",
                  "ptg000677l",
                  "ptg001745l",
                  "ptg000893l",
                  "ptg000359l")

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
  geom_segment(aes(y=refStart, x=queryStart, yend=refEnd, xend=queryEnd, color=percentID), linewidth=1) +
  geom_point(aes(y=refStart, x=queryStart, color=percentID), size=0.375) +
  geom_point(aes(y=refEnd, x=queryEnd, color=percentID), size=0.375) +
  scale_colour_viridis_c(name = "approx. identity", begin = 1,end = 0.3, limits=c(NA,1))  +
  facet_grid(.~queryID, scales = "free_x", space = "free_x", switch = "x") +
  scale_x_continuous(breaks = seq(-3e6,3e6,0.5e6), labels = function(x){x/1e6}) +
  scale_y_reverse(breaks = seq(0, 4e7, 1e7), labels = function(x){x/1e6}) +
  labs(y="l94 ptg000032l (Mb)",x="SusPtrit contigs (Mb)") +
  theme(strip.text = element_text(angle = 60),
        axis.title.y = element_text(angle = 270)) +
  coord_cartesian(expand = F, ylim = c(NA,0)) +
  geom_blank()
