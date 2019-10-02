class Movie < ActiveRecord::Base
    
	@@all_ratings = ['G','PG','PG-13','R']
	#this will set up the checkboxes for the ratings for filtering for part ii
	def self.all_ratings
		@@all_ratings
	end
	
end
