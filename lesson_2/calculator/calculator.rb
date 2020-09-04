require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

def messages(message, lang='en')
  MESSAGES[lang][message]
end

def prompt(message)
  puts("=> #{message}")
end

def valid_number?(num)
  /^-?\.?\d+?\.*\d*$/.match(num)
end

def operation_to_message(op)
  word = case op
         when '1'
           messages 'add'
         when '2'
           messages 'sub'
         when '3'
           messages 'mul'
         when '4'
           messages 'div'
         end
  word
end

prompt messages 'welcome'

name = ''
loop do
  name = gets.chomp

  if name.empty?()
    prompt messages 'valid_name'
  else
    break
  end
end

prompt "#{messages 'hi'} #{name}!"

loop do # main loop
  number1 = ''
  number2 = ''
  operator = ''

  loop do
    prompt messages 'first_num'
    number1 = gets.chomp

    if valid_number?(number1)
      break
    else
      prompt messages 'invalid_num'
    end
  end

  loop do
    prompt messages 'second_num'
    number2 = gets.chomp

    if valid_number?(number2)
      break
    else
      prompt messages 'invalid_num'
    end
  end

  prompt messages 'what_op'

  loop do
    operator = gets.chomp
    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt messages 'invalid_op'
    end
  end

  prompt "#{operation_to_message(operator)} #{messages 'op_msg'}"

  result = case operator
           when '1'
             number1.to_f + number2.to_f
           when '2'
             number1.to_f - number2.to_f
           when '3'
             number1.to_f * number2.to_f
           when '4'
             number1.to_f / number2.to_f
           end

  prompt "#{messages 'result'} #{result}"

  prompt messages 'again'
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt messages 'goodbye'
