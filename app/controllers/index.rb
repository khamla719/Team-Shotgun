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
  @user=User.find_by(id: session[:user_id])
  p "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
  @tweets = Tweet.where(user_id: session[:user_id])
  @tweets = @tweets.to_a
  @leaders = Friendship.where(follower_id: session[:user_id])
  @leaders = @leaders.to_a
  @leader_tweet = []
  @leaders.each do |leader|
    @shit = Tweet.where(user_id: leader.leader_id).to_a
    @shit.each do |tweet|
      @leader_tweet << tweet
    end
  end
  @leader_tweet
   @leader_tweet = @leader_tweet.sort_by! &:created_at
   @leader_tweet = @leader_tweet.reverse
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
  p params
  p "*************************************************"

  @leader = User.find_by(user_name: params[:leader])
  redirect "/users/@leader.id/show"
end


get '/users/:id/show' do
  @tweets = Tweet.where(id: params[:id])
  @id = params[:id]
  @leader = User.find_by(id: params[:id])
  redirect '/users_profile_public'
end

get '/users/:id/followers' do
  p params
  p "*************************************************"

  @user = User.find(session[:user_id])
  @tweets = Tweet.where(id: params[:id])
  @id = params[:id]
  @leader = User.find_by(id: params[:id])
  erb :followers_private
end


post '/users/:id/add_leader/' do
  @id = params[:id]
  @friendship = Friendship.new(leader_id: @id, follower_id: session[:user_id])
  if @friendship.save #only increases if they are not already friends

    #increase users leaders count
    @users = User.find_by(session[:id])
    @leaders_count = @users.leaders_count + 1
    @users.update(leaders_count: @leaders_count)

    #increase leaders followers count
    @leader = User.find_by(id: @id)
    @followers_count = @leader.followers_count + 1
    @leader.update(followers_count: @followers_count)

    redirect "/users/#{@id}/show"
  end
  redirect "/homepage"
end
