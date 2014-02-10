Thread.new do
   system("rackup private_pub.ru -s thin -E production")
end