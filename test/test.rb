
if RUBY_VERSION < '1.9'
  require "rubygems"
  $KCODE = 'U'
  require 'jcode'
end

require 'chinese_text_filter'

trad_text = "知名程序員 Ken Thompson 說：想發現有天賦的程序員，重點在激情，在談話的過程中你會感受到這種激情有多少。我會問他做過最有趣的程序是什麽，然後讓他描述該程序的細節。如果經不起我的盤問，或者是發現算法和解決方案有問題，而他不能解釋清楚，或不能比我做得更投入，那麽他也不是好的程序員。"
sfilter = Chinese_text_filter.new(trad_text)
sfilter.map_to_simplified
puts trad_text
puts sfilter.text

sfilter.segment.remove_punctuation.remove_meaningless_words
puts sfilter.text

hash = sfilter.convert_to_hashes 
hash.each do |key, value|
  puts "#{key}:#{value}"
end
