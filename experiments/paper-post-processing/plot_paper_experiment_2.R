library(ggplot2)
library(R.matlab)
library(RColorBrewer)
library(dplyr)

setwd('/Users/pgrigas/Documents/ExtendedFW-MatrixCompletion')

matlab_data = readMat("ggplot_data_big.mat")

num_FW = length(matlab_data$itersFW)
num_IF_11 = length(matlab_data$itersIF.11)
num_IF_01 = length(matlab_data$itersIF.01)
num_IF_0Inf = length(matlab_data$itersIF.0Inf)
num_IF_peak = length(matlab_data$itersIF.peak)
num_IF_lasttoward = length(matlab_data$itersIF.lasttoward)
num_IF_fullopt = length(matlab_data$itersIF.fullopt)
num_GM = length(matlab_data$itersGM)
num_GM_atom = length(matlab_data$itersGM.atom)



FW_data = data.frame(iters=t(matlab_data$itersFW), cputimes=matlab_data$cputimesFW, ranks=matlab_data$ranksFW, nucnorms=matlab_data$nucnormsFW, loggaps=matlab_data$log.r.opt.gapsFW, algtype=rep("FW", num_FW))

IF_11_data = data.frame(iters=t(matlab_data$itersIF.11), cputimes=matlab_data$cputimesIF.11, ranks=matlab_data$ranksIF.11, nucnorms=matlab_data$nucnormsIF.11, loggaps=matlab_data$log.r.opt.gapsIF.11, algtype=rep("IF_11", num_IF_11))

IF_01_data = data.frame(iters=t(matlab_data$itersIF.01), cputimes=matlab_data$cputimesIF.01, ranks=matlab_data$ranksIF.01, nucnorms=matlab_data$nucnormsIF.01, loggaps=matlab_data$log.r.opt.gapsIF.01, algtype=rep("IF_01", num_IF_01))

IF_0Inf_data = data.frame(iters=t(matlab_data$itersIF.0Inf), cputimes=matlab_data$cputimesIF.0Inf, ranks=matlab_data$ranksIF.0Inf, nucnorms=matlab_data$nucnormsIF.0Inf, loggaps=matlab_data$log.r.opt.gapsIF.0Inf, algtype=rep("IF_0Inf", num_IF_0Inf))

IF_peak_data = data.frame(iters=t(matlab_data$itersIF.peak), cputimes=matlab_data$cputimesIF.peak, ranks=matlab_data$ranksIF.peak, nucnorms=matlab_data$nucnormsIF.peak, loggaps=matlab_data$log.r.opt.gapsIF.peak, algtype=rep("IF_peak", num_IF_peak))
# for (i in 1:length(IF_peak_data$loggaps))
# {
	# IF_peak_data$loggaps[i] = max(IF_peak_data$loggaps[i], -4)
# } 

IF_lasttoward_data = data.frame(iters=t(matlab_data$itersIF.lasttoward), cputimes=matlab_data$cputimesIF.lasttoward, ranks=matlab_data$ranksIF.lasttoward, nucnorms=matlab_data$nucnormsIF.lasttoward, loggaps=matlab_data$log.r.opt.gapsIF.lasttoward, algtype=rep("IF_lasttoward", num_IF_lasttoward))

IF_fullopt_data = data.frame(iters=t(matlab_data$itersIF.fullopt), cputimes=matlab_data$cputimesIF.fullopt, ranks=matlab_data$ranksIF.fullopt, nucnorms=matlab_data$nucnormsIF.fullopt, loggaps=matlab_data$log.r.opt.gapsIF.fullopt, algtype=rep("IF_fullopt", num_IF_fullopt))

GM_data = data.frame(iters=t(matlab_data$itersGM), cputimes=matlab_data$cputimesGM, ranks=matlab_data$ranksGM, nucnorms=matlab_data$nucnormsGM, loggaps=matlab_data$log.r.opt.gapsGM, algtype=rep("GM", num_GM))

GM_atom_data = data.frame(iters=t(matlab_data$itersGM.atom), cputimes=matlab_data$cputimesGM.atom, ranks=matlab_data$ranksGM.atom, nucnorms=matlab_data$nucnormsGM.atom, loggaps=matlab_data$log.r.opt.gapsGM.atom, algtype=rep("GM_atom", num_GM_atom))


plot_data = rbind(FW_data, IF_11_data, IF_01_data, IF_0Inf_data, IF_fullopt_data, IF_peak_data, GM_data, GM_atom_data)
#plot_data = rbind(FW_data, IF_11_data, IF_01_data, IF_fullopt_data, GM_data, GM_atom_data) # only 6

delta_found = matlab_data$delta.found
max_rankIF = max(IF_0Inf_data$ranks)
max_rankFW = max(FW_data$ranks)

alg_types = c("FW", "IF_11", "IF_01", "IF_0Inf", "IF_peak", "IF_fullopt", "GM", "GM_atom")

plot_data_shapes = plot_data[1,]
for (i in c(2,4,6)) {
	val = 50*i
	for (alg in alg_types) {
		candidates = plot_data[plot_data$algtype==alg & abs(plot_data$cputimes - val) < 1,]
		plot_data_shapes = rbind(plot_data_shapes, sample_n(candidates, 1))
	}
}
plot_data_shapes = plot_data_shapes[2:nrow(plot_data_shapes),]




legend_labels = list("Frank-Wolfe", "IF w/ gamma1 = 1, gamma2 = 1", "IF w/ gamma1 = 0, gamma2 = 1", "IF w/ gamma1 = 0, gamma2 = Inf", "IF w/ In-Face Optimization", "IF w/ Rank Strategy", "FW w/ Natural Away Steps", "FW w/ Atomic Away Steps")
#legend_labels = list("Frank-Wolfe", "IF-FW gamma1 = gamma2 = 1", "IF-FW gamma1 = 0, gamma2 = 1", "IF-FW Full In-Face Optimization", "FW w/ Away Steps", "FW w/ Atomic Away Steps") # only 6

rank_plot = ggplot(plot_data, aes(x=cputimes, y=ranks, colour=algtype)) + geom_line(size=1) + scale_colour_brewer(palette="Set1", guide = FALSE, labels=legend_labels) + theme_grey() + theme(axis.title.x=element_blank(), axis.title.y=element_blank()) + scale_y_continuous(breaks=c(0, max_rankIF, 100, 200, 300, 400))

nucnorm_plot = ggplot(plot_data, aes(x=cputimes, y=nucnorms, colour=algtype)) + geom_line(size=1) + scale_y_continuous(breaks=c(3, 4, 5, 6, delta_found)) + scale_colour_brewer(palette="Set1", guide = guide_legend(title=NULL), labels=legend_labels) + theme_grey() + theme(axis.title.x=element_blank(), axis.title.y=element_blank())

gap_plot = ggplot(plot_data, aes(x=cputimes, y=loggaps, colour=algtype)) + geom_line(size=1) + scale_colour_brewer(palette="Set1", guide = guide_legend(title=NULL), labels=legend_labels) + theme_grey() + theme(axis.title.x=element_blank(), axis.title.y=element_blank(), legend.position=c(1,1), legend.justification=c(1,1), legend.text=element_text(size=14)) + scale_y_continuous(limits=c(-4.02, -1))

# new colors
pallete1 = brewer.pal(8, "Set1")
pallete2 = pallete1
pallete2[6] = pallete1[2]
pallete2[2] = pallete1[6]
pallete2[2] = "gold3"

# OLD
rank_plot = ggplot(plot_data, aes(x=cputimes, y=ranks, colour=algtype)) + geom_line(size=1) + scale_colour_manual(values=pallete2, guide = FALSE, labels=legend_labels) + theme_grey() + theme(axis.title.x=element_blank(), axis.title.y=element_blank()) + scale_y_continuous(breaks=c(0, max_rankIF, 100, 200, 300, 400))

gap_plot = ggplot(plot_data, aes(x=cputimes, y=loggaps, colour=algtype)) + geom_line(size=1) + scale_colour_manual(values=pallete2, guide = guide_legend(title=NULL), labels=legend_labels) + theme_grey() + theme(axis.title.x=element_blank(), axis.title.y=element_blank(), legend.position=c(1,1), legend.justification=c(1,1), legend.text=element_text(size=14)) + scale_y_continuous(limits=c(-4.02, -1))


# SHAPES
gap_plot_shapes = ggplot() + geom_line(data=plot_data, aes(x=cputimes, y=loggaps, colour=algtype), size=1) + geom_point(data=plot_data_shapes, aes(x=cputimes, y=loggaps, colour=algtype, shape=algtype), size=7) + scale_colour_manual(values=pallete2, guide = guide_legend(title=NULL), labels=legend_labels) + 
scale_shape_manual(values=c(0, 2, 13, 4, 5, 6, 7, 8), guide = guide_legend(title=NULL), labels=legend_labels) + theme_grey() + theme(axis.title.x=element_blank(), axis.title.y=element_blank(), legend.position=c(1,1), legend.justification=c(1,1), legend.text=element_text(size=14)) + scale_y_continuous(limits=c(-4.02, -1))

rank_plot_shapes = ggplot() + geom_line(data=plot_data, aes(x=cputimes, y=ranks, colour=algtype), size=1) + geom_point(data=plot_data_shapes, aes(x=cputimes, y=ranks, colour=algtype, shape=algtype), size=7) + scale_colour_manual(values=pallete2, guide = FALSE, labels=legend_labels) + scale_shape_manual(values=c(0, 2, 13, 4, 5, 6, 7, 8), guide = FALSE, labels=legend_labels) + theme_grey() + theme(axis.title.x=element_blank(), axis.title.y=element_blank()) + scale_y_continuous(breaks=c(0, max_rankIF, 100, 200, 300, 400))

# LINE TYPES
gap_plot_linetypes = ggplot(plot_data, aes(x=cputimes, y=loggaps, colour=algtype, linetype=algtype)) + geom_line(size=1) + scale_colour_manual(values=pallete2, guide = guide_legend(title=NULL), labels=legend_labels) + scale_linetype_manual(values=c(2, 1, 1, 1, 3, 4, 1, 6), guide = guide_legend(title=NULL), labels=legend_labels) + theme_grey() + theme(axis.title.x=element_blank(), axis.title.y=element_blank(), legend.position=c(1,1), legend.justification=c(1,1), legend.text=element_text(size=14)) + scale_y_continuous(limits=c(-4.02, -1))

rank_plot_linetypes = ggplot(plot_data, aes(x=cputimes, y=ranks, colour=algtype, linetype=algtype)) + geom_line(size=1) + scale_colour_manual(values=pallete2, guide = FALSE, labels=legend_labels) + scale_linetype_manual(values=c(2, 1, 1, 1, 3, 4, 1, 6), guide = FALSE, labels=legend_labels) + theme_grey() + theme(axis.title.x=element_blank(), axis.title.y=element_blank()) + scale_y_continuous(breaks=c(0, max_rankIF, 100, 200, 300, 400))

# BOTH
gap_plot_both = ggplot() + geom_line(data=plot_data, aes(x=cputimes, y=loggaps, colour=algtype, linetype=algtype), size=1) + geom_point(data=plot_data_shapes, aes(x=cputimes, y=loggaps, colour=algtype, shape=algtype), size=7) + scale_colour_manual(values=pallete2, guide = guide_legend(title=NULL), labels=legend_labels) + 
scale_shape_manual(values=c(0, 2, 13, 4, 5, 6, 7, 8), guide = guide_legend(title=NULL), labels=legend_labels) + scale_linetype_manual(values=c(2, 1, 1, 1, 3, 4, 1, 6), guide = guide_legend(title=NULL), labels=legend_labels) + theme_grey() + theme(axis.title.x=element_blank(), axis.title.y=element_blank(), legend.position=c(1,1), legend.justification=c(1,1), legend.text=element_text(size=20)) + scale_y_continuous(limits=c(-4.02, -1))

rank_plot_both = ggplot() + geom_line(data=plot_data, aes(x=cputimes, y=ranks, colour=algtype, linetype=algtype), size=1) + geom_point(data=plot_data_shapes, aes(x=cputimes, y=ranks, colour=algtype, shape=algtype), size=7) + scale_colour_manual(values=pallete2, guide = FALSE, labels=legend_labels) + scale_shape_manual(values=c(0, 2, 13, 4, 5, 6, 7, 8), guide = FALSE, labels=legend_labels) + scale_linetype_manual(values=c(2, 1, 1, 1, 3, 4, 1, 6), guide = FALSE, labels=legend_labels) + theme_grey() + theme(axis.title.x=element_blank(), axis.title.y=element_blank()) + scale_y_continuous(breaks=c(0, max_rankIF, 100, 200, 300, 400))




gaplog_plot = ggplot(plot_data, aes(x=cputimes, y=loggaps, colour=algtype)) + geom_line(size=1) + scale_colour_brewer(palette="Set1", guide = guide_legend(title=NULL), labels=legend_labels) + theme_grey() + theme(axis.title.x=element_blank(), axis.title.y=element_blank(), legend.position=c(0,0), legend.justification=c(0,0)) + scale_x_log10()

rank_plot
ggsave("rank_plot_big.pdf", width=16, height=16, units="cm")

nucnorm_plot
ggsave("exp2_sim_nucnorm.pdf", width=24, height=16, units="cm")

gap_plot
ggsave("gap_plot_big.pdf", width=16, height=16, units="cm")

gaplog_plot
ggsave("exp2_sim_gaplog.pdf", width=16, height=16, units="cm")

rank_plot_shapes
ggsave("rank_plot_big_shapes.pdf", width=16, height=16, units="cm")

gap_plot_shapes
ggsave("gap_plot_big_shapes.pdf", width=16, height=16, units="cm")

rank_plot_both
ggsave("rank_plot_big_both.pdf", width=16, height=16, units="cm")

gap_plot_both
ggsave("gap_plot_big_both.pdf", width=16, height=16, units="cm")