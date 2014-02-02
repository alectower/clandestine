module Clandestine
  class PasswordGenerator
    LETTERS = ('a'..'z').to_a + ('A'..'Z').to_a
    NUMS = ('0'..'9').to_a * 5
    CHARS = ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')'] * 5

    def self.random_password
      password = ''
      generator = Random.new(Random.srand)
      chars = LETTERS + NUMS + CHARS
      chars.shuffle!
      12.times do |n|
        password << chars[generator.rand(0..chars.size - 1)]
      end
      password
    end
  end
end
