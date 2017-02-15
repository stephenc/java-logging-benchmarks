#!/usr/bin/env Rscript

require(ggplot2)
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00", "#CC79A7", "#0066CC", "#56B4E9", "#009E73", "#0072B2", "#D55E00")
shPalette <- c(16, 17, 22, 25, 16, 17, 22, 25, 16, 17, 22, 25)
subtitle <- if(is.na(commandArgs(TRUE)[1])) "" else commandArgs(TRUE)[1]

png('logback-fmt.sample.png', width=1024, height=600, units="px", res=90)
if (file.exists('logback-fmt.sample.dat')) {
    print("Generating Logback output format graph")
    ggplot(read.csv('logback-fmt.sample.dat'),aes(x=Threads,y=Time/1000,group=Benchmark,colour=Benchmark,shape=Benchmark))+
    ggtitle(paste("Logback output format",subtitle,sep="\n"))+
    geom_point()+
    geom_line()+
    ylab("Time (µs)")+
    xlab("Number of threads")+
    scale_x_continuous(expand = c(0, 0))+
    scale_y_continuous(expand = c(0, 0))+expand_limits(y=0,x=0)+
    scale_colour_manual(values=cbPalette,name="Framework") +
    scale_shape_manual(values=shPalette,name="Framework") +
    theme(legend.justification=c(0,1), legend.position=c(0.02,0.98))
}
dev.off()

png('log4j-fmt.sample.png', width=1024, height=600, units="px", res=90)
if (file.exists('log4j-fmt.sample.dat')) {
    print("Generating Log4j output format graph")
    ggplot(read.csv('log4j-fmt.sample.dat'),aes(x=Threads,y=Time/1000,group=Benchmark,colour=Benchmark,shape=Benchmark))+
    ggtitle(paste("Log4J output format",subtitle,sep="\n"))+
    geom_point()+
    geom_line()+
    ylab("Time (µs)")+
    xlab("Number of threads")+
    scale_x_continuous(expand = c(0, 0))+
    scale_y_continuous(expand = c(0, 0))+expand_limits(y=0,x=0)+
    coord_cartesian(ylim=c(0,75000))+
    scale_colour_manual(values=cbPalette,name="Framework") +
    scale_shape_manual(values=shPalette,name="Framework") +
    theme(legend.justification=c(0,1), legend.position=c(0.02,0.98))
}
dev.off()

png('jul-fmt.sample.png', width=1024, height=600, units="px", res=90)
if (file.exists('jul-fmt.sample.dat')) {
    print("Generating Java Util Logging output format graph")
    ggplot(read.csv('jul-fmt.sample.dat'),aes(x=Threads,y=Time/1000,group=Benchmark,colour=Benchmark,shape=Benchmark))+
    ggtitle(paste("Java Util Logging output format",subtitle,sep="\n"))+
    geom_point()+
    geom_line()+
    ylab("Time (µs)")+
    xlab("Number of threads")+
    scale_x_continuous(expand = c(0, 0))+
    scale_y_continuous(expand = c(0, 0))+expand_limits(y=0,x=0)+
    coord_cartesian(ylim=c(0,50000))+
    scale_colour_manual(values=cbPalette,name="Framework") +
    scale_shape_manual(values=shPalette,name="Framework") +
    theme(legend.justification=c(0,1), legend.position=c(0.02,0.98))
}
dev.off()

png('nolog.sample.png', width=1024, height=600, units="px", res=90)
if (file.exists('nolog.sample.dat')) {
    print("Generating No logging output graph")
    ggplot(read.csv('nolog.sample.dat'),aes(x=Threads,y=Time/1000,group=Benchmark,colour=Benchmark,shape=Benchmark))+
    ggtitle(paste("No logging output",subtitle,sep="\n"))+
    geom_point()+
    geom_line()+
    ylab("Time (µs)")+
    xlab("Number of threads")+
    scale_x_continuous(expand = c(0, 0))+
    scale_y_continuous(expand = c(0, 0))+expand_limits(y=0,x=0)+
    scale_colour_manual(values=cbPalette,name="Framework") +
    scale_shape_manual(values=shPalette,name="Framework") +
    theme(legend.justification=c(0,1), legend.position=c(0.02,0.98))
}
dev.off()
png('logback-fmt.thrpt.png', width=1024, height=600, units="px", res=90)
if (file.exists('logback-fmt.thrpt.dat')) {
    print("Generating Logback output format graph")
    ggplot(read.csv('logback-fmt.thrpt.dat'),aes(x=Threads,y=Score,group=Benchmark,colour=Benchmark,shape=Benchmark))+
    ggtitle(paste("Logback output format",subtitle,sep="\n"))+
    geom_point()+
    geom_line()+
    ylab("Throughput (messages/sec)")+
    xlab("Number of threads")+
    scale_x_continuous(expand = c(0, 0))+
    scale_y_continuous(expand = c(0, 0))+expand_limits(y=0,x=0)+
    scale_colour_manual(values=cbPalette,name="Framework") +
    scale_shape_manual(values=shPalette,name="Framework") +
    theme(legend.justification=c(1,1), legend.position=c(0.98,0.98))
}
dev.off()

png('log4j-fmt.thrpt.png', width=1024, height=600, units="px", res=90)
if (file.exists('log4j-fmt.thrpt.dat')) {
    print("Generating Log4j output format graph")
    ggplot(read.csv('log4j-fmt.thrpt.dat'),aes(x=Threads,y=Score,group=Benchmark,colour=Benchmark,shape=Benchmark))+
    ggtitle(paste("Log4J output format",subtitle,sep="\n"))+
    geom_point()+
    geom_line()+
    ylab("Throughput (messages/sec)")+
    xlab("Number of threads")+
    scale_x_continuous(expand = c(0, 0))+
    scale_y_continuous(expand = c(0, 0))+expand_limits(y=0,x=0)+
    scale_colour_manual(values=cbPalette,name="Framework") +
    scale_shape_manual(values=shPalette,name="Framework") +
    theme(legend.justification=c(1,1), legend.position=c(0.98,0.98))
}
dev.off()

png('jul-fmt.thrpt.png', width=1024, height=600, units="px", res=90)
if (file.exists('jul-fmt.thrpt.dat')) {
    print("Generating Java Util Logging output format graph")
    ggplot(read.csv('jul-fmt.thrpt.dat'),aes(x=Threads,y=Score,group=Benchmark,colour=Benchmark,shape=Benchmark))+
    ggtitle(paste("Java Util Logging output format",subtitle,sep="\n"))+
    geom_point()+
    geom_line()+
    ylab("Throughput (messages/sec)")+
    xlab("Number of threads")+
    scale_x_continuous(expand = c(0, 0))+
    scale_y_continuous(expand = c(0, 0))+expand_limits(y=0,x=0)+
    scale_colour_manual(values=cbPalette,name="Framework") +
    scale_shape_manual(values=shPalette,name="Framework") +
    theme(legend.justification=c(1,1), legend.position=c(0.98,0.98))
}
dev.off()

png('nolog.thrpt.png', width=1024, height=600, units="px", res=90)
if (file.exists('nolog.thrpt.dat')) {
    print("Generating No logging output graph")
    ggplot(read.csv('nolog.thrpt.dat'),aes(x=Threads,y=Score,group=Benchmark,colour=Benchmark,shape=Benchmark))+
    ggtitle(paste("No logging output",subtitle,sep="\n"))+
    geom_point()+
    geom_line()+
    ylab("Throughput (messages/sec)")+
    xlab("Number of threads")+
    scale_x_continuous(expand = c(0, 0))+
    scale_y_continuous(expand = c(0, 0))+expand_limits(y=0,x=0)+
    scale_colour_manual(values=cbPalette,name="Framework") +
    scale_shape_manual(values=shPalette,name="Framework") +
    theme(legend.justification=c(0,1), legend.position=c(0.02,0.98))
}
dev.off()
