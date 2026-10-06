# # Adding the Queryverse package
# using Pkg
# Pkg.add("Queryverse")

import Queryverse
import ReadableRegex

# using Pkg
# Pkg.add("DataFrames") 

using DataFrames
using Dates

# use PyCall
# import Pkg
# Pkg.add("PyCall")       
 # import python library

# using Pkg
# Pkg.add("Plots")
# using Plots

# using Pkg
# # Pkg.add("PyPlot") # or  Pkg.add("PlotlyJS")
# Pkg.add("PlotlyJS")

using PyCall
@pyimport re

df=DataFrame()
df = DataFrame([[],[],[],[]], ["dur_time", "cummulative_infected","normaltime_dur","non_cummulative_inf"])

open("../data/codered-july.duration.cdf.txt") do f

  line = 0

  reg=r"[\s+\t+]"# separators are space or tab (+ means one or more) 
  prev=0
  while ! eof(f)

    s = readline(f)  #reads a single line of file
    
    if occursin(r"^[^#]",s)# if line does not begin with #
      
      line += 1                             
      if (line==1)                
        push!(df, [ split(s,reg)[1], parse(Float64,String.(split(s,reg)[2])), unix2datetime.(parse(Float64,String.(split(s,reg)[1]))),parse(Float64,String.(split(s,reg)[2]))])  
        #splitting the  line based on reg (the separators)
        #the first part of the split goes to the first column of df, the second part to the second comlumn  ,
        #turning it to a string for later conversion to float
        #parse to  use a float input in the unix2datetime
        prev=parse(Float64,String.(split(s,reg)[2]))
      else
        push!(df, [ split(s,reg)[1], parse(Float64,String.(split(s,reg)[2])), unix2datetime.(parse(Float64,String.(split(s,reg)[1]))),parse(Float64,String.(split(s,reg)[2]))-prev])
        prev=parse(Float64,String.(split(s,reg)[2]))
      end
    end
  end
end
println(first(df, 10))
# println()
# println(last(df, 10))

# pyplot()
x=df.normaltime_dur
# y=df.cummulative_infected
# last(df)
using Plots


# p=plot(x,y)
# savefig(p, "cred_july_duration_cdf_time_y.pdf")

# q=plot(y,x)
# savefig(q, "cred_july_duration_cdf_time_x.pdf")

println(first(df, 10))
println(last(df, 10))
y=df.non_cummulative_inf
plotlyjs()

r=plot(x,y)
xlabel!("normaltime_dur")
ylabel!("non_cummulative_inf")
# savefig(r, "cred_july_infected_dur_non_cummulative.pdf")
