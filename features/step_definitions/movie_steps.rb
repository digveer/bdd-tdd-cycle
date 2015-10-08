# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    @movie = Movie.find_by_title(movie['title'])
         if @movie.nil?
    	@movie = Movie.create!(movie)
         else
    	@movie.update_attributes!(movie) if @movie != movie
         end
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
#  fail "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page
Then /^the director of "([^"]*)" should be "([^"]*)"/ do |t, d|
  Movie.find_by_title(t)[:director].should == d
end


Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  titles = page.all("table#movies tbody tr td[1]").map {|t| t.text}
     titles.index(e1).should < titles.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(",").each do |field|
         field = field.strip
         if uncheck == "un"
             step %Q{I uncheck "ratings_#{field}"}
             #step %Q{the "#{field}" checkbox should not be checked}
         else
             step %Q{I check "ratings_#{field}"}
             #step %Q{the "#{field}" checkbox should be checked}
         end
     end
end

When /I press the Refresh button/ do
   step %{I press "ratings_submit"}
end


Then /I should (not )?see movies with ratings: (.*)/ do |nosee, list| 
   @movies = Movie.find_all_by_rating(list.split(%r{,\s*}))
   @movies.each do |m|
	step %{I should #{nosee}see "#{m["title"]}"}
   end
end
Then /I should not see any of the movies/ do
  rows = page.all('#movies tr').size - 1
  assert rows == 0
end
Then /I should see all of the movies/ do
  # Make sure that all the movies in the app are visible in the table
  count =0;
  page.all("table#movies tbody tr").each do |tr|
    count=count+1
  end
  #rows = page.all("table#movies tr")
  (count).should == Movie.all.count  
  
end
