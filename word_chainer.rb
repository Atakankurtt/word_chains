require 'set'

class WordChainer
    attr_reader :dictionary

    LETTERS = ("a".."z").to_a

    def initialize(dictionary_file_name)
        file = File.open(dictionary_file_name).readlines.map(&:chomp)
        @dictionary = Set.new(file)
    end

    def adjacent_words(word)
        chain_words = []
        word.each_char.with_index do |char, i|
            LETTERS.each do |ele|
                copy_cat = word.dup
                if ele != char
                    copy_cat[i] = ele
                    if @dictionary.include?(copy_cat)
                        chain_words << copy_cat
                    end
                end
            end
        end
        chain_words       
    end

    def run(source, target)
        @current_words, @all_seen_words = [source], { source => nil }

        until @current_words.empty? || @all_seen_words.include?(target)
            explore_current_words
        end
        build_path(target).join(" ")
    end

    def explore_current_words
        new_current_words = []
        @current_words.each do |current_word|
            adjacent_words(current_word).each do |adjacent_word|
                if !@all_seen_words.include?(adjacent_word)
                    new_current_words << adjacent_word
                    @all_seen_words[adjacent_word] = current_word
                end
            end
        end
        # puts @all_seen_words
        @current_words = new_current_words
    end

    def build_path(target)
        path = []
        until target == nil
            path << target
            target = @all_seen_words[target]
        end
        path.reverse
    end
end

if $PROGRAM_NAME == __FILE__
    p WordChainer.new("dictionary.txt").run("duck", "ruby")
end



