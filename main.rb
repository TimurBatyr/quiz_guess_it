require 'yaml'

ans_order = 'A'.ord
correct_answer_count = 0
incorrect_answer_count = 0

puts 'Type your name'
name = gets.strip

current_time = Time.now.strftime('%Y-%m-%d_%H-%M-%S')

file_name = "QUIZ_#{name}_#{current_time}.txt"

File.write(file_name, "Results of user #{name}\n\n#{current_time}", mode: 'a')


all_questions = YAML.safe_load_file('questions.yml', symbolize_names: true)
# puts all_questions.inspect

all_questions.shuffle.each do |question_data|
  formatted_question = "\n\n=== #{question_data[:question]} ===\n\n"
  puts formatted_question

  File.write(file_name, formatted_question, mode: 'a')

  correct_answer = question_data[:answer].first
 
  answers = question_data[:answer].shuffle.each_with_index.inject({}) do |result, (ans, index)|
    answer_char = (ans_order + index).chr
    result[answer_char] = ans  
  
    puts "#{answer_char}. #{ans}"
    result
  end

  user_answer = nil
  loop do
    puts 'Your answer:'
    user_answer = gets.strip[0].upcase
    if user_answer.between?('A', 'D')
      break
    else
      puts 'Answers are between A-D'
    end
  end

  File.write(
    file_name, 
    "User answer: #{answers[user_answer]}\n\n",
    mode: 'a')
  
  if answers[user_answer] == correct_answer
    puts "Correct!!!"
    correct_answer_count += 1

    File.write(
      file_name, 
      "Correct answer",
      mode: 'a')
  else
    puts "Not correct!"
    puts "Correct answer: #{correct_answer}"
    incorrect_answer_count += 1

    File.write(
      file_name, 
      "Incorrect answer! Correct answer: #{correct_answer}",
      mode: 'a')
  end
end

File.write(
  file_name, 
  "\n\nCorrect answers: #{correct_answer_count}\n\n",
  mode: 'a')

File.write(
  file_name, 
  "\n\nIncorrect answers: #{incorrect_answer_count}\n\n",
  mode: 'a')

correct_answer_percentage = (correct_answer_count / all_questions.size.to_f) * 100

File.write(
  file_name, 
  "\n\nCorrect answers percentage: #{correct_answer_percentage.floor(2)}%\n\n",
  mode: 'a')