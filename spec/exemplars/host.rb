class Host < ActiveRecord::Base
  
  generator_for(:name) { "Hello" }
  generator_for(:addr) { "Hello" }
  generator_for(:port) { 1 }
  generator_for(:info) { "Lorem ipsum dolor sit amet..." }
  
end