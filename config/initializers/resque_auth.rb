Resque::Server.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ["admin", "blahhebruMethubeJuCzx"]
end
