def read_file
  signal=Array.new
  signal = File.read("signal.txt").chars
  return signal
end



def identify_code_please (signal, length)
  signal.each.with_index do |input, index|
    c=index
    n=(index+1)
    final_index = c + length-1 
    if final_index > signal.length-1
      final_index = signal.length-1
    end
    while c < final_index
      while n <= final_index
        if signal[c] != signal[n]
         puts "#{signal[c]} is not equal to #{signal[n]}"
          n+=1
          if c == (final_index-1)
            return n
          end
        elsif signal[c] == signal[n]
          puts "next letter"
          c = final_index+1
          break
        end
      end
      c+=1
      n=c+1
  end
end
end



def identify_code(signal)
  n=0
  signal.each do |input|
    if (input != signal[n+1]) && (input != signal[n+2]) && (input != signal[n+3])
      puts "we are on our way and n = #{n}"
      if (signal[n+1] != signal[n+2]) && (signal[n+1] != signal[n+3])
        puts "we passed the second test"
        if (signal[n+2] != signal[n+3])
          puts "are we there yet?"
          return (n+3)
        end
      end 
    end
   n+=1
 end

 return ("there is no packet")
end

puts (identify_code_please(read_file, 14))