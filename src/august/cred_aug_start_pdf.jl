import Queryverse
import ReadableRegex
using DataFrames
using Dates
using PyCall
@pyimport re

df=DataFrame()
df=DataFrame([[],[],[],[]],
             ["start_time", "cummulative_infected",
              "normaltime_dur", "non_cummulative_inf"])

open("../data/codered-august.start.cdf.txt") do f
  line = 0
  reg=r"[\s+\t+]"
  prev=0
  while ! eof(f)
    s = readline(f)
    if occursin(r"^[^#]",s)
      line += 1
      if line == 1
        push!(df, [split(s,reg)[1],
                   parse(Float64,String.(split(s,reg)[2])),
                   unix2datetime.(parse(Float64,String.(split(s,reg)[1]))),
                   parse(Float64,String.(split(s,reg)[2]))])
        prev=parse(Float64,String.(split(s,reg)[2]))
      else
        push!(df, [split(s,reg)[1],
                   parse(Float64,String.(split(s,reg)[2])),
                   unix2datetime.(parse(Float64,String.(split(s,reg)[1]))),
                   parse(Float64,String.(split(s,reg)[2]))-prev])
        prev=parse(Float64,String.(split(s,reg)[2]))
      end
    end
  end
end

using Plots
println(first(df, 10))
println(last(df, 10))
x=df.normaltime_dur
y=df.non_cummulative_inf
plotlyjs()

r=plot(x,y)
xlabel!("normaltime_dur")
ylabel!("non_cummulative_inf")
savefig(r, "cred_aug_start_pdf.pdf")
