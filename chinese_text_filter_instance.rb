# encoding: utf-8

require 'singleton'
require 'rmmseg'


MEANINGLESS = %w(的 得 地)

class Chinese_text_filter

  attr_accessor :text
  RMMSeg::Dictionary.load_dictionaries
  @text = String.new.force_encoding("utf-8")

  def initialize(text)
    @text = text
  end

  def segment
    algor = RMMSeg::Algorithm.new(@text)
    words = String.new.force_encoding("utf-8")

    loop do
      tok = algor.next_token
      break if tok.nil?
      words << tok.text << " "
    end

    @text = words.force_encoding("utf-8")
    self
  end

  def remove_punctuation 
    words = String.new.force_encoding("utf-8")
    #words = text.gsub(/，|。|：/, '').squeeze;
    words = @text.gsub(/\u3002|\uFF0C|\uFF1A/, '').squeeze
    @text = words.force_encoding("utf-8")
    self
  end

  def remove_meaningless_words
    words = @text.split

    new_words = String.new.force_encoding("utf-8")

    words.each do |word|
      unless MEANINGLESS.include?(word)
        new_words << word << " " 
      end
    end

    @text = new_words.force_encoding("utf-8")
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


text = "知名程序员 Ken Thompson 说：想发现有天赋的程序员，重点在激情，在谈话的过程中你会感受到这种激情有多少。我会问他做过最有趣的程序是什么，然后让他描述该程序的细节。如果经不起我的盘问，或者是发现算法和解决方案有问题，而他不能解释清楚，或不能比我做得更投入，那么他也不是好的程序员。"

text.force_encoding("utf-8")

cfilter = Chinese_text_filter.new(text)

cfilter.segment.remove_punctuation.remove_meaningless_words

puts cfilter.text

hash = cfilter.convert_to_hashes 
hash.each do |key, value|
  puts "#{key}:#{value}"
end
