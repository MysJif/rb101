CHARS = %w(a b c d e f 0 1 2 3 4 5 6 7 8 9)

def uuid
  uuid = []
  current = ''
  8.times do
    current << CHARS.sample
  end
  uuid << current
  current = ''
  4.times do
    current << CHARS.sample
  end
  uuid << current
  current = ''
  4.times do
    current << CHARS.sample
  end
  uuid << current
  current = ''
  4.times do
    current << CHARS.sample
  end
  uuid << current
  current = ''
  12.times do
    current << CHARS.sample
  end
  uuid << current

  uuid.join('-')
end

puts uuid()