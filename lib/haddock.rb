# A more memorable password generator. Swordfish? No, I got tired of that. I
# changed it.
module Haddock
  VERSION = '0.2.2'

  module Password
    # The minimum password legnth.
    MINIMUM = 8

    # The maximum password length.
    MAXIMUM = 31

    # The default password length.
    DEFAULT = 12

    # Paths used to detect default words files.
    PATHS = %w(/usr/share/dict/words /usr/share/words)

    @@delimiters = '`~!@#$%^&*()-_=+[{]}\\|;:\'",<.>/?'

    class << self
      # Generates a more memorable password. Its one optional argument
      # determines the length of the generated password, and cannot be less
      # than 8 or greater than 31 characters (default: 12). Allows simplification
      # with options
      #
      #   Password.generate     # => "bowl9&bracky"
      #   Password.generate(30) # => "Phlebotomus2473?nonconditioned"
      #   Password.generate(8)  # => "amy7@rax"
      #   Password.generate(8, {:use_delimeter=>false} => "bonk5and"
      #   Password.generate(8, {:use_numbers=>false} => "jack!man"

      def generate(length = DEFAULT, options = {})
        unless defined? @@diction
          self.diction = PATHS.find { |path| File.exist? path }
        end
	options = {
	  :use_delimeter=>true, 
	  :use_number=>true
        }.merge(options)

        raise LengthError, "Invalid length" unless length.is_a? Integer
        raise LengthError, "Password length is too short" if length < MINIMUM
        raise LengthError, "Password length is too long" if length > MAXIMUM

        words_limit = length * 0.75 # Ensure over-proportionate word lengths.

        begin
          words = %W(#{random_word} #{random_delimiter if options[:use_delimeter]}#{random_word})
          words_length = words.join.length
	  return words.join if words_length == length && !options[:use_number]
        end until words_length < length && words_length > words_limit && options[:use_number]
        
	words.join random_number(length - words_length) if options[:use_number]
      end

      # Sets the dictionary. Uses "/usr/share/dict/words" or
      # "/usr/share/words" otherwise.
      #
      #   Password.diction = File.expand_path(__FILE__) + "/my_words.txt"
      def diction=(path)
        @@diction = IO.readlines path
      rescue TypeError
        raise NoWordsError, "No words file found"
      rescue Errno::ENOENT
        raise NoWordsError, "No words file at #{path.inspect}"
      end

      # Sets the list of characters that can delimit words. Default:
      #
      #   `~!@#$%^&*()-_=+[{]}\|;:'",<.>/?
      def delimiters=(string)
        @@delimiters = string
      end

      private

      def random_word
        @@diction[rand(@@diction.length)].chomp
      end

      def random_delimiter
        @@delimiters[rand(@@delimiters.length), 1]
      end

      def random_number(digits)
        begin
          number = rand(10 ** digits).to_s
        end until number.length == digits

        number
      end
    end

    # Raised if a password is generated with too few or too many characters.
    class LengthError < ArgumentError
    end

    # Raised if no words file is found.
    class NoWordsError < StandardError
    end
  end
end
