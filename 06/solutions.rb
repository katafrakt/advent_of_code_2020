puts File.read('input').split("\n\n").map{ |g| g.scan(/[a-z]/).uniq.size }.sum
puts File.read('input').split("\n\n").map{ |g| g.scan(/[a-z]/).tally.select{|k,v| v == g.split("\n").size }.size }.sum