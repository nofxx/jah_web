


#
# Gen keys
#
puts "Creating keys.."
`ssh-keygen -t dsa -f jah.key`


puts "Use authentication? (Y/n)"
use_auth = gets.chomp == "n" ? false : true

puts use_auth
