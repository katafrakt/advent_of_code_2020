[2,3].each { |num| puts File.readlines('input').map(&:to_i).permutation(num).detect{|ar| ar.sum == 2020}.reduce(&:*) }
