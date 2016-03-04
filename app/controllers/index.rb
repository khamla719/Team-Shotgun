get '/' do
  # Look in app/views/index.erb
  redirect '/login'
end

# login and signup page
get '/login' do
  erb :login
end

#POST login to existing account
post '/login' do
  user = User.find_by(user_name: params[:user_name])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/homepage'
    else
      erb :login
    end
end

#view user homepage
get '/homepage' do
  @tweets = Tweet.where(user_id: session[:user_id])
  @tweets = @tweets.to_a
  @leaders = Friendship.where(follower_id: session[:user_id])
  @leaders = @leaders.to_a
  @leader_tweet = []
  @leaders.each do |leader|
    @leader_tweet << Tweet.where(user_id: leader.leader_id).to_a
  end
  p @leader_tweet
  erb :homepage
end


#view signup form
get '/signup' do
  @user = User.new
  erb :signup, locals: {user: @user}
end


#POST create new account
post '/users/new' do
  @user = User.new(params[:user])
    if @user.save
      redirect "/homepage"
    else
      @errors = @user.errors.full_messages
      redirect '/signup'
    end
end

post '/tweets/new' do
  p session
  @tweet = Tweet.new(text:params[:text], user_id: (session[:user_id]))
    if @tweet.save
      redirect "/homepage"
    else
      @errors = @tweet.errors.full_messages
      redirect '/signup'
    end
end

post '/logout' do
  session.delete(:user_id)
  redirect '/login'
end

post '/search' do
  @leader = User.find_by(user_name: params[:leader])
  redirect "/users/#{@leader.id}/show"
end


get '/users/:id/show' do
  @tweets = Tweet.where(user_id: params[:id])
  @id = params[:id]
  erb :users_profile_public
end

post '/users/:id/add_leader/' do
  @id = params[:id]
  @friendship = Friendship.create(leader_id: @id, follower_id: session[:user_id])
  redirect "/users/#{@id}/show"
end
