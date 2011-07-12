# encoding: utf-8
# internal_encoding: utf-8

#for ruby1.8 only now, if you want to change it to te compatible with ruby1.9, 
#you should force the string to be encoded by utf-8

if RUBY_VERSION < '1.9'
  require "rubygems"
  $KCODE = 'U'
  require 'jcode'
  gem 'rmmseg-cpp' , '=0.2.7'
else
  gem 'rmmseg-cpp-huacnlee' , '>0.2.7'
end
require 'rmmseg'

$LOAD_PATH.unshift '.'
require 'zh_conversion'

MEANINGLESS = %w(的 得 地)

class Chinese_text_filter

  attr_accessor :text
  
  # add the private dictionary for segmentation
  #RMMSeg::Dictionary.add_dictionary("ywb_words.dic", :words)
  RMMSeg::Dictionary.load_dictionaries
  @text = String.new

  def initialize(text)
    @text = text
  end

  def map_to_simplified 
    map = ZH2SIMPLIFIED
    
    char_arr = Array.new
    @text.each_char do |ch|
      char_arr << ch
    end

    i = char_arr.size - 1
    simplified_rarr = Array.new
    while i >= 0 do
      if i >= 3 
        quad_word = char_arr[i-3..i].to_s
        if map[quad_word] 
          simplified_rarr << map[quad_word]
          i = i - 4
          next
        end
      end

      if i >= 2 
        triple_word = char_arr[i-2..i].to_s
        if map[triple_word] 
          simplified_rarr << map[triple_word]
          i = i - 3
          next
        end
      end

      if i >= 1
        dual_word = char_arr[i-1..i].to_s
        if map[dual_word] 
          simplified_rarr << map[dual_word]
          i = i - 2
          next
        end
      end

      single_word = char_arr[i]
      if map[single_word] 
          simplified_rarr << map[single_word]
      else
          simplified_rarr << single_word
      end

      i = i - 1
    end

    @text = simplified_rarr.reverse.to_s
    self

    #@text.each_char do |word|
      #if map[word]
         #simplified_text << map[word]
      #else
         #simplified_text << word
      #end
    #end

    #@text = simplified_text 
    #self
  end

  def segment
    algor = RMMSeg::Algorithm.new(@text)
    words = String.new

    loop do
      tok = algor.next_token
      break if tok.nil?
      words << tok.text << " "
    end

    @text = words
    self
  end

  def remove_punctuation 
    words = String.new
    words = text.gsub(/，|。|：|　|、|《|》|“|”|？/, '').squeeze
    #words = @text.gsub(/\u3002|\uFF0C|\uFF1A/, '').squeeze
    @text = words
    self
  end

  def remove_meaningless_words
    words = @text.split

    new_words = String.new

    words.each do |word|
      unless MEANINGLESS.include?(word)
        new_words << word << " " 
      end
    end

    @text = new_words
    self
  end

  def convert_to_hashes
    words = @text.split
    dic = Hash.new

    words.each do |word|
      if dic.member?(word)
        dic[word] = dic[word] + 1
      else
        dic[word] = 1
      end
    end

    dic.sort_by {|k, v| v}.reverse
  end

end


if $0 == __FILE__ 
  #text = "知名程序员 Ken Thompson 说：想发现有天赋的程序员，重点在激情，在谈话的过程中你会感受到这种激情有多少。我会问他做过最有趣的程序是什么，然后让他描述该程序的细节。如果经不起我的盘问，或者是发现算法和解决方案有问题，而他不能解释清楚，或不能比我做得更投入，那么他也不是好的程序员。"
  #puts text

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
end
