require 'jumpstart_auth'

class MicroBlogger
  attr_reader :client
  
  def initialize
    puts "Initializing MicroBlogger"
    @client = JumpstartAuth.twitter
  end
  
  def tweet(message)
    if message.length <= 140
      @client.update(message)
    else
      puts "Uh-oh, that message is too long! Please keep tweets to 140 characters or less!"
    end
  end
  
  def dm(target, message)
    screen_name = @client.followers.collect { |follower| @client.user(follower).screen_name }
    
    puts "Trying to send #{target} this direct message:"
    puts message
    message = "d @#{target} #{message}"
    if screen_name.include?(target)
      tweet(message)
    else
      puts "You don't currently follow this user."
    end
  end
  
  def followers_list
    screen_names = []
    @client.followers.each { |follower| screen_names << @client.user(follower).screen_name }
    return screen_names
  end
  
  def spam_my_followers(message)
    followers = followers_list
    
    followers.each do |follower|
      dm(follower, message)
    end
  end
  
  def run
    puts "Welcome to the JSL Twitter Client!"
    
    command = ""
    while command != "q"
      printf "enter command: "
      input = gets.chomp
      parts = input.split(" ")
      command = parts[0]
      
      case command
        when 'q' then puts "Goodbye!"
        when 't' then tweet(parts[1..-1].join(" "))
        when 's' then spam_my_followers(parts[1..-1].join(" "))
        when 'dm' then dm(parts[1], parts[2..-1].join(" "))
        else
          puts "Sorry, I don't know how to #{command}"
      end
    end
  end
  
end

blogger = MicroBlogger.new
# blogger.tweet("This tweet should be short enough to post ... ?")
blogger.run
          