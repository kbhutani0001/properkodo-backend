class StaticPagesController < ApplicationController



include HTTParty
require 'rubygems'
require 'nokogiri'
require 'rest-client'
HTTParty::Basement.default_options.update(verify: false)
  def home

# Github Api fetching

    @username = params[:username]
        if @username && @username!=''
            @data = HTTParty.get('https://api.github.com/users/'+ @username)
            @language = Hash.new(0)
            a = 1
            stop = 0
            while(stop==0)
            @url = HTTParty.get('https://api.github.com/users/'+ @username +'/repos?page='+ a.to_s)
            if @url.count<30
              stop=1
            end

            @url.each do |repo|
              if repo['language']!=nil
                x = repo['language'].downcase
                @language[x] += 1
              end
             end

             a+=1
           end
         end


# Codechef Data scraping

             @chefname = params[:codechef]
             if @chefname!='' && @chefname
                 @codechef = Nokogiri::HTML(RestClient.get("https://www.codechef.com/users/"+ @chefname))
                 @d=Array.new
                 i_count=0
                 @codechef.xpath("//div[@class='content']/h5").each do |x|
                  aword = x.text.split(" ")
                   aword[2].slice! "("
                   aword[2].slice! ")"
                   @d[i_count] = aword[2].to_i
                   i_count+=1
                 end
                # CODECHEF RATING
                 @codechef.xpath("//div[@class='rating-number']").each do |x|
                    @current_codechef_rating = x.text.to_i
                 end
                 @codechef.xpath("//div[@class='rating-header text-center']/small").each do |x|
                    @splitrating = x.text.split(" ")
                     @splitrating[2].slice! ")"
                    @highest_codechef_rating = @splitrating[2].to_i
                 end
             end

#  Codeforces data fetch using API

            @forcename = params[:codeforce]
            if @forcename!='' && @forcename
                @codeforce = HTTParty.get("http://codeforces.com/api/user.info?handles="+ @forcename)
            end


            # hackerrank data

            @hackerrankname = params[:hackerrank]
            if @hackerrankname!='' && @hackerrankname
                @hackerrank = Nokogiri::HTML(RestClient.get("https://www.hackerrank.com/"+@hackerrankname+"?hr_r=1"))
                @bl = Array.new
                i=0
                 @hackerrank.xpath("//div[@class='bold mlB']/span").each do |x|
                  @bl[i] = x.text
                  i+=1
                end
            end

            @hackerearthname = params[:hackerearth]
            if @hackerearthname!='' && @hackerearthname
                @hackerearth = Nokogiri::HTML(RestClient.get("https://www.hackerearth.com/@"+ @hackerearthname))
                @hackerearthproblem = Nokogiri::HTML(RestClient.get("https://www.hackerearth.com/@"+@hackerearthname+"/activity/hackerearth/#user-rating-graph"))

                @hackerearth.xpath("//div/span[@class='track-following-num']/a").each do |x|
                  @bla = x.text.to_i
                  end

            end

    end
    def about
    end
  end
