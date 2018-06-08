require 'rubygems'
require 'rufus/scheduler'
require 'time'
#scheduler = Rufus::Scheduler.start_new
 Scheduler = []
10.times.each{|i| Scheduler[i] = Rufus::Scheduler.start_new}

100.times do |j|
 m = j%10
Scheduler[m].every '3s', :blocking => false do
  puts Scheduler[m].jobs
  puts "this is #{Time.now}" 
  sleep 10
end
Scheduler[m].every '5s' do
  puts "5555555555555:#{Time.now}"
end
Scheduler[m].join
end
