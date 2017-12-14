require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'
require './model.rb'

set :bind, '0.0.0.0'
# database이름을 정의 가능


before do
# 하위 로직이 실행되기 전 이 로직을 실행한다
  check_login
end

get '/' do
  # posts라는 임시변수에 모두 데이터를 넣는다
  @posts = Post.all
  erb :index
end

get '/new' do
  erb :new
end

get '/create' do
  # db에 날아온값을 저장
  Post.create(
    :title => params["title"],
    :content => params["content"]
  )
  redirect to '/'
end

get '/edit/:id' do
  @post = Post.get(params[:id])
  erb :edit
end

get '/update/:id' do
    post = Post.get(params[:id])
    post.update(
      :title => params["title"],
      :content => params["content"]
    )
    redirect to '/'
end

get '/destroy/:id' do
  # Post를 지우는 코드 -> destroy
  # 프라이머리 키를 기준으로 레코드를 찾아서 변수에 저장해 놓고 그 변수에 destroy 메소드를 통해 삭제
  # post = Post.get("지우고 싶은 post의 id값")
  # post.destroy

  # 1번 글을 지우게 될거면
  # destroy/:num 에서 num을 1로

  post = Post.get(params[:id])
  post.destroy

  redirect to '/'
end

get '/signup' do
  erb :signup
end

get '/register'do
  User.create(
    # :email => params["email"],
    # :password => params["password"]
    # 위 아래는 같은 결과값을 가지는 문법. 밑에가 새로 추가 된 문법
    email: params["email"],
    password: params["password"]
  )

  redirect to '/'
end

get '/login'do
  erb :login
end

get '/login_session' do
  # 지금 param으로 넘어온 email이 있을 경우
  if User.first(:email => params["email"])
    if User.first(:email => params["email"]).password == params["password"]
      session[:email] = params["email"]
      @message = "Log-in success"
      # session = {}
      # {:email => "asdf@asdf.com"}
    else
      @message = "Wrong password"
    end
  else
    @message = "Do not exist the User"
  end
end
# :name 어떤 특정 입력 값을 정의해서 받는게 아니라 사용자가 입력한 값에 상관없이 pass하는 기능
# get '/hello/:name'  do
#   @name = params[:name]
#   erb :hello
# end
#
# # 사용자가 square해서 숫자를 입력하면 그 제곱을 리턴해준다.
# get '/square/:num' do
#   num = params[:num].to_i
#   @square = num*num
#   @result = num **3
#   erb :square
# end

def check_login
  unless session[:email]
    redirect to '/'
  end
end
