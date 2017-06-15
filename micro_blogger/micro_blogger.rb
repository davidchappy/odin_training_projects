require 'jumpstart_auth'
require 'bitly'
Bitly.use_api_version_3

class MicroBlogger

  attr_reader :client

  def initialize
    puts "Initializing MicroBlogger"
    @client = JumpstartAuth.twitter
  end

  def run
    puts "Welcome to the JSL Twitter Client"
    command = ""
    while command != "q"
      printf "enter command: "
      input = gets.chomp
      parts = input.split(" ")
      command = parts[0]
      case command
      when "q" then puts "Goodbye!"
      when "t" then tweet parts[1..-1].join(" ")
      when "dm" then dm(parts[1], parts[2..-1].join(" "))
      when "spam" then spam_my_followers parts[1..-1].join(" ")
      when "elt" then everyones_last_tweet
      when "s" then shorten parts[1..-1].join("")
      when "turl" then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
      else
        puts "Sorry, I don't know how to #{command}"
      end
    end
  end

  def tweet(message)
    if message.length <= 140
      @client.update(message)
    else
      puts "That Message is too long (140 chars. max)"
      return false
    end
  end

  def dm(target, message)
    puts "Trying to send #{target} this direct message:"
    puts message
    screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
    message = "d @#{target} #{message}"
    if screen_names.include?(target)
      tweet(message)
      puts "Message sent successfully!"
    else
      puts "#{target} is not one of your followers."
    end
  end

  def followers_list
    screen_names = []
    @client.followers.each do |follower|  
      screen_names << @client.user(follower).screen_name
    end
    screen_names
  end

  def spam_my_followers(message)
    followers = followers_list
    followers.each do |follower|
      dm(follower, message)
    end
  end

  def everyones_last_tweet
    puts "Getting your friends latest tweets."
    friends = @client.friends
    friends = friends.sort_by {|f| f.screen_name.downcase }

    friends.each do |friend|
      timestamp = friend.status.created_at
      message = friend.status
      puts friend.screen_name + " said on " + timestamp.strftime("%A %b %d") + "..."
      puts message.text
      puts ""
    end 
  end

  def shorten(url)
    puts "Shortening this URL: #{url}"
    bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
    bitly.shorten(url).short_url
  end

end

blogger = MicroBlogger.new
blogger.run