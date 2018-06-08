module Affable
    
    def ratio_hash       
        # "adap:0.35,dummy:0.65" => {"adap"=>"0.35", "dummy"=>"0.65"}
       @ratio_hash ||= Hash[ratio_values.split(',').map{|value|value.split(":")}.sort{|a,b| a[1] <=> b[1]}]
    end


    def distributor_ratio
       # {"s"=>0.35, "x"=>0.2, "y"=>0.2} => {"s"=>0.4666, "x"=>0.2666, "y"=>0.2666}
       sum = ratio_hash.values.map(&:to_f).inject(:+)
       ratio_hash.inject({}) { |ratios,adxchange| ratios.merge!(adxchange[0]=>(adxchange[1].to_f/sum.to_f).to_f) }         
    end


    def reversal_ratio
      # {"s"=>0.4666, "x"=>0.2666, "y"=>0.2666} =>  {"0.4666"=>"s", "0.2666"=>["x","y"]}
      distributor_ratio.inject({}) do | res,adxchange | 
          if res.keys.include? adxchange[1].to_s
              res[adxchange[1].to_s] << adxchange[0]
          else
              res.merge! adxchange[1].to_s => [adxchange[0]]
          end
          res
      end
    end


    def analysis_ratio
      @analysis_ratio ||= Hash[reversal_ratio.map  do |pair|  
        if pair[1].length > 1 
         [(pair[0].to_f * pair[1].length).to_s,pair[1]]
        else
          [pair[0],pair[1]]
        end
       end.sort{|a,b| a[0] <=> b[0]}]
    end



    def deliver_ratio
       #{"0.2"=>["8494"], "0.3"=>["8495"], "0.5"=>["8521"]} => {"0.2"=>["8494"], "0.5"=>["8495"], "1"=>["8521"]} 
       #{"0.2666"=>["x","y"],"0.4666"=>"s"}=>{"0.4666"=>"s", "0.5332"=>["x","y"]}
       @deliver_ratio ||= analysis_ratio.inject({}) do |res,pair|
          sum = res.keys.last || 0
          res["#{pair[0].to_f+sum.to_f}"] = pair[1]
          res
       end
    end

  
    def average_deliver_array
      return "" if deliver_ratio.empty?
      return @average_deliver_array unless @average_deliver_array.nil?
      seed = SecureRandom.random_number
      keys = deliver_ratio.keys
      deliver_ratio.each_pair do |pair| 
        if seed < pair[0].to_f 
          @average_deliver_array =  pair[1]
          break 
        end
      end
      @average_deliver_array
    end   


  end