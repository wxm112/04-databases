class Plant < ActiveRecord::Base
 #:Butterfly => 'butterflies'
 # if you use the singlar n of table as the class's name, then you don't need to writ the prious code.
 has_many :butterflies
end
