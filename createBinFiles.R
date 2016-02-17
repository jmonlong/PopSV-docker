## In order to avoid installing the heavy BSgenome.Hsapiens.UCSC.hg19 package
## we can pre-compute bins definition and GC content.
## Then both 'fragment.genome.hg19' and 'getGC.hg19' steps can be skipped by
## loading one of the .RData files.

library(PopSV)

bins.df = fragment.genome.hg19(500, XY.chr = TRUE)
bins.df = getGC.hg19(bins.df)
save(bins.df, file="bins-500bp.RData")

bins.df = fragment.genome.hg19(1e3, XY.chr = TRUE)
bins.df = getGC.hg19(bins.df)
save(bins.df, file="bins-1kbp.RData")

bins.df = fragment.genome.hg19(2e3, XY.chr = TRUE)
bins.df = getGC.hg19(bins.df)
save(bins.df, file="bins-2kbp.RData")

bins.df = fragment.genome.hg19(5e3, XY.chr = TRUE)
bins.df = getGC.hg19(bins.df)
save(bins.df, file="bins-5kbp.RData")

