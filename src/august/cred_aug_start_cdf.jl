import Queryverse
import ReadableRegex
using DataFrames
using Dates
using PyCall
@pyimport re

df=DataFrame()
df = DataFrame([[],[],[]], ["start_time", "cummulative_infected","moment"])

# Source dataset is intentionally not included in this repository.
open("../data/codered-august.start.cdf.txt") do f
  line = 0
  reg=r"[\s+\t+]"
  while ! eof(f)
    s = readline(f)
    if occursin(r"^[^#]",s)
      line += 1
      push!(df, [ split(s,reg)[1],
                   parse(Float64,String.(split(s,reg)[2])),
                   unix2datetime.(parse(Float64,String.(split(s,reg)[1]))) ])
    end
  end
end

x=df.moment
y=df.cummulative_infected
using Plots
plotlyjs()
p=plot(x,y)
savefig(p, "cred_aug_start_cdf.pdf")
