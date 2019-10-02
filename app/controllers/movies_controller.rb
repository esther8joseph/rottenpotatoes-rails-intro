class MoviesController < ApplicationController
#check back on this website on how to do the sessions for part 3
# https://guides.rubyonrails.org/action_controller_overview.html

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    #this takes the index value of the movie in model i believe
    id = params[:id] 
    @movie = Movie.find(id) 
  end

  def index
    
    #sort the following movies in the database so that views can display the data from model
    if params[:sort]
        #use order from Active Record to filter the movies,
        @movies = @movies.order(params[:sort])# @movies preserves the links 
    end
    
    #check the key for params to provide filtering
    if params.key?(:sort_by)
			session[:sort_by] = params[:sort_by]
		#check is the key for the session exists to filter
		elsif session.key?(:sort_by)
			params[:sort_by] = session[:sort_by]
			redirect_to movies_path(params) and return
		end
		 
		#check from piazza on post on how to change headers to links
		@hilite = sort_by = session[:sort_by] #use the css addition
		@all_ratings = Movie.all_ratings #display all
		
		if params.key?(:ratings)
			session[:ratings] = params[:ratings]
			#if the key for params exist, filter the ratings accordingly
		elsif session.key?(:ratings)
		#if the key for the session exists, filter the ratings adjusted by the user
			params[:ratings] = session[:ratings]
			#return all
			redirect_to movies_path(params) and return
		end
		#initialize on how to verify the filtering of the ratings
		@checked_ratings = (session[:ratings].keys if session.key?(:ratings)) || @all_ratings
		#movies are sorted, fix the order error
    @movies = Movie.order(sort_by).where(rating: @checked_ratings)
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
    
  end

  def destroy
    
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    
    redirect_to movies_path
    
  end

end
