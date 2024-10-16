require "openai"
require "dotenv/load"

client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

# Set up the message list with a system message
message_list = [
  {
    "role" => "system",
    "content" => "You are a helpful assistant."
  }
]

# Start the conversation loop
user_input = ""

# Loop until the user types "bye"
while user_input != "bye"
  puts "Hello! How can I help you today?"
  puts "-" * 50

  # Get user input
  user_input = gets.chomp
  
  # Add the user's message to the message list
  if user_input != "bye"
    message_list.push({ "role" => "user", "content" => user_input })

    # Send the message list to the API
    api_response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: message_list
      }
    )

    # Dig through the JSON response to get the content
    choices = api_response.fetch("choices")
    first_choice = choices.at(0)
    message = first_choice.fetch("message")
    assistant_response = message["content"]
    
    # Print the assistant's response
    puts assistant_response
    puts "-" * 50

    # Add the assistant's response to the message list
    message_list.push({ "role" => "assistant", "content" => assistant_response })
  end
end

puts "Goodbye! Have a great day!"
