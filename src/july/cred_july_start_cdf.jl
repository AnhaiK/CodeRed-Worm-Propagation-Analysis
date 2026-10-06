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
using PyCall
@pyimport re

df=DataFrame()
df = DataFrame([[],[],[]], ["start_time", "cummulative_infected","moment"])

open("../data/codered-july.start.cdf.txt") do f

  line = 0

  reg=r"[\s+\t+]"# separators are space(+ means one or more) or tab

  while ! eof(f)

    s = readline(f)  #reads a single line of file
    
    if occursin(r"^[^#]",s)# if line does not begin with #
      
      line += 1                                             #0 is a dummy initialized value here(below)
      push!(df, [String.(split(s,reg)[1]),String.(split(s,reg)[2]),0])  #splitting the  line based on reg (the separators)
      #the first part of the split goes to the first column of df, the second part to the second comlumn  turning it to a 
      # string for later conversion to float
        # to use a float input in the unix2datetime
      df.start_time[line]=parse(Float64,df.start_time[line])
      # println(df[line,:])
      # println(df.moment[line])
      # println(df.start_time[line]) 
      println(unix2datetime.(df.start_time[line]))
    end
  end
end
println(first(df, 10))
println()
println(last(df, 10))
