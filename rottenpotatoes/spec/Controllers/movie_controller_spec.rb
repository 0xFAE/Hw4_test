require 'rails_helper'
if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end 

RSpec.describe MoviesController, type: :controller do
    
    describe "#director" do
    before :each do
         @test1 = Movie.create!({
            :id => 1,
            :title => "A", 
            :rating => "G", 
            :description => "description",
            :release_date => "2100-02-04", 
            :director => "Fatima"})
            
            @test2 = Movie.create!({
            :id => 2,
            :title => "B", 
            :rating => "R", 
            :description => "description",
            :release_date => "2001-10-04", 
            :director => "Not"})
            
            @test3 = Movie.create!({
            :id => 3,
            :title => "C", 
            :rating => "R", 
            :description => "description",
            :release_date => "2000-09-04", 
            :director => "Not"})

        @movies = Movie.all
      end

      it "Should be redirect to the home page when can't find similar movies" do
        movie = @movies.where(title: 'A').take
        get :find_same_director, movie_id: movie.id
        expect(response).to redirect_to('/movies')
        expect(flash[:warning]).to eq("'#{movie.title}' has no director info")
      end
end

  describe "#create" do
      
      let(:movie_params) {{title: "Star Wars", rating: "P", release_date: "1977-05-25"}}
        let(:movie) {double('movie', title: "Star Wars")}
        
        it 'should create a new movie' do
            expect(Movie).to receive(:create!)
                .with(movie_params).and_return(movie)
            
            post :create, {movie: movie_params}
        end
        
  end
  
  describe "#destroy" do
      
    it "should delete the specific movie" do
        @test1 = Movie.create!({
            :id => 100,
            :title => "Movie test", 
            :rating => "G", 
            :description => "This is a movie description",
            :release_date => "2000-11-04", 
            :director => "dir"})
        expect(Movie).to receive(:find).with(@test1.id).and_return(@test1)
        expect(@test1).to receive(:destroy)
        delete :destroy, :id => @test1.id
        expect(response).to redirect_to(movies_path)
    end
    
  end
  
  describe "#edit" do
    @movie = Movie.create!({
            :id => 100,
            :title => "Movie test", 
            :rating => "G", 
            :description => "This is a movie description",
            :release_date => "2000-11-04", 
            :director => "dir"})
    it "should edit an existing movie" do
        expect(Movie).to receive(:find).and_return(@movie)
        get :edit, :id => @movie_id
        expect(response).to render_template(:edit)
    end
  end
  
  describe "#new" do
    it "should render the new template" do
        get :new 
        expect(response).to render_template(:new)
    end
  end
end

 describe "update method" do
        before do
       @test1 = Movie.create!({
            :id => 1,
            :title => "A", 
            :rating => "G", 
            :description => "description",
            :release_date => "2100-02-04", 
            :director => "Fatima"})
            
        end
        it "should update list" do
            patch :update, :id => @test1.id, 
            :movie => {:title => "Q", 
            :rating => "G", 
            :description => "description", 
            :release_date => "1001-11-11 10:10:10", 
            :director => "some other director"}
            @test1.reload
            expect(@test1.title).to eq("B")
        end
    end