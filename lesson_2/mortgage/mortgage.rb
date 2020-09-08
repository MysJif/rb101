def prompt(message) # Separates calculator display from user input
  puts "=> #{message}"
end

def verify?(number) # Verifies that the input
  number.to_i >= 1
end

def monthly_interest(apr) # Converts APR to monthly interest
  apr / 12
end

def duration_in_months(years) # Converts duration from years to months
  years * 12
end

def monthly_payment(loan_amount, month_interest, duration) # Monthly payment
  loan_amount * (month_interest / (1 - (1 + month_interest)**(-duration)))
end

def result(amount, interest, duration) # Formats result
  month_interest = monthly_interest(interest)
  month_duration = duration_in_months(duration)
  monthly_payment(amount, month_interest, month_duration).round(2)
end

prompt "Welcome to Mortgage Calculator!"

loop do
  amount = nil # Loan amount
  duration = nil # Loan duration

  loop do
    prompt "Please enter your loan amount."
    amount = gets.chomp.to_f

    verify?(amount) ? break : prompt("Please enter a positive number.")
  end

  prompt "Please enter your Annual Percentage Rate (as a whole number)."
  interest = gets.chomp.to_f / 100

  loop do
    prompt "Please enter your loan duration (in years)."
    duration = gets.chomp.to_f
    verify?(duration) ? break : prompt("Please enter a positive number.")
  end

  prompt "Your monthly payment is $#{result(amount, interest, duration)}"

  prompt "Do you want to calculate more? (Y for more)"
  answer = gets.chomp

  break unless answer.downcase.start_with?("y")
end
