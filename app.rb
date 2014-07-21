# id | message

require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    messages = @database_connection.sql("SELECT * FROM messages")
    comments = @database_connection.sql("SELECT * FROM comments")

    erb :home, locals: {messages: messages, comments: comments}
  end

  get "/edit/:id" do
    message = @database_connection.sql("SELECT * FROM messages WHERE id = #{params[:id]}").first
    erb :edit, locals: {message: message}
  end

  get "/comment/:id" do
    message = @database_connection.sql("SELECT * FROM messages WHERE id = #{params[:id]}").first
    erb :comment, locals: {message: message}
  end

  patch "/edit/:id" do
    message = params[:message]
    if message.length <= 140
      @database_connection.sql("UPDATE messages SET message = '#{message}' WHERE id = #{params[:id]}")
    else
      flash[:error] = "Message must be less than 140 characters."
      redirect "/edit/#{params[:id]}"
    end
    redirect "/"
  end

  patch "/comment/:id" do
    comment = params[:comment]
    @database_connection.sql("INSERT INTO comments (comment, message_id) VALUES ('#{comment}',#{params[:id]})")
    redirect "/"
  end

  post "/messages" do
    message = params[:message]
    if message.length <= 140
      @database_connection.sql("INSERT INTO messages (message) VALUES ('#{message}')")
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

  delete "/delete/:id" do
    @database_connection.sql("DELETE FROM messages WHERE id = #{params[:id]}")
    redirect "/"
  end

end