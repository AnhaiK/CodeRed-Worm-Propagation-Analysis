import Queryverse
import ReadableRegex
using DataFrames
using Dates
using PyCall
@pyimport re

df=DataFrame()
df=DataFrame([[],[],[],[],[]],
             ["start_time_incr", "cummulative_infected",
              "normaltime_dur", "non_cummulative_inf", "slope"])

open("../data/codered-august.start.cdf.txt") do f
  line = 1
  lfirst=1
  reg=r"[\s+\t+]"
  prev1=0
  prev2=0

  while ((!eof(f)) && (lfirst==1))
    first=readline(f)
    if occursin(r"^[^#]",first)
      lfirst+=1
      prev1=parse(Float64,String.(split(first,reg)[1]))
      prev2=parse(Float64,String.(split(first,reg)[2]))
      push!(df, [prev1,
                 parse(Float64,String.(split(first,reg)[2])),
                 unix2datetime.(parse(Float64,String.(split(first,reg)[1]))),
                 prev2, 0])
    end
  end

  while !eof(f)
    s=readline(f)
    if occursin(r"^[^#]",s)
      x=parse(Float64,String.(split(s,reg)[1]))-prev1
      y=parse(Float64,String.(split(s,reg)[2]))-prev2
      push!(df, [x,
                 parse(Float64,String.(split(s,reg)[2])),
                 unix2datetime.(parse(Float64,String.(split(s,reg)[1]))),
                 y, y/x])
      prev1=x+prev1
      prev2=y+prev2
      line += 1
    end
  end
end

using Plots
println(first(df, 30))
println(last(df, 10))
xval=df.normaltime_dur
yval=df.slope
println(size(yval))
println(first(yval))
plotlyjs()

r=plot(xval,yval)
xlabel!("normaltime_dur")
ylabel!("slope")
savefig(r, "cred_aug_start_pdf.pdf")
