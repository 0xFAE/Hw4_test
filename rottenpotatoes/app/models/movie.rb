class Movie < ActiveRecord::Base
        def self.movies_director(director)
		if director=='' || director==nil
			return
		end
		return Movie.where(director:director)
	end
	    @@all_ratings = ['G', 'PG', 'PG-13', 'R']
    def self.all_ratings
        @@all_ratings
    end
	
end