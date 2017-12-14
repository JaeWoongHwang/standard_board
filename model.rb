DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/board.db")

class Post
  include DataMapper::Resource # DataMapper 객체로 Question클래스를 만들겠다.
  property :id, Serial
  property :title, String
  property :content, Text
  property :author, String, :default => "anoymous"
  property :created_at, DateTime
end

class User
  include DataMapper::Resource
  # property를 쓰고, 컬럼이름 쓰고, 자료형을 써서 선언한다.
  property :id, Serial
  property :email, String
  property :password, String
  property :name, String, :default => ""
  property :story, String, :default => ""
  property :created_at, DateTime
end

DataMapper.finalize
Post.auto_upgrade!
User.auto_upgrade!
