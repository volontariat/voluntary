When /^(?:|I )fill in the name field of the 1st task with "([^"]*)"$/ do |value|
  find(:xpath, '/html/body/div[2]/div/div/div/div[2]/div[2]/form/fieldset/div[1]//input[1]').set(value)
end

When /^(?:|I )fill in the text field of the 1st task with "([^"]*)"$/ do |value|
  find(:xpath, '/html/body/div[2]/div/div/div/div[2]/div[2]/form/fieldset//textarea[1]').set(value)
end

When /^(?:|I )fill in the name field of the 2nd task with "([^"]*)"$/ do |value|
  find(:xpath, '/html/body/div[2]/div/div/div/div[2]/div[2]/form/div[2]/fieldset/div[1]//input[1]').set(value)
end

When /^(?:|I )fill in the text field of the 2nd task with "([^"]*)"$/ do |value|
  find(:xpath, '/html/body/div[2]/div/div/div/div[2]/div[2]/form/div[2]/fieldset//textarea[1]').set(value)
end

When /^(?:|I )press the first update tasks button$/ do
  find(:xpath, '/html/body/div[2]/div/div/div/div[2]/div[2]/form/div[1]/div/div/input').click
end