10.times do
  `curl http://localhost:8080/add_url?url=http://fakeurl111#{rand(1..100000)}.ru`
end