require 'json'
require 'net/http'
require 'uri'
require 'date'
require 'wtf_lang'
module LikeModule
  module Like
    class << self
      ACCESS_TOKEN = ENV['WP_ACCESS_TOKEN']
      WtfLang::API.key = ENV['WTFLANG_API_KEY']
      def likeposts
        # {"access_token":"XXXX",
        # "token_type":"bearer",
        # "blog_id":"000000",
        # "blog_url":"XXXX",
        # "scope":""}
        # uri = URI.parse("XXXX")
        # req = Net::HTTP::Post.new(uri.request_uri)
        # req.set_form_data({
        #   'client_id' => 'XXXX',
        #   'redirect_uri' =>'XXXX',
        #   'client_secret' =>'XXXX',
        #   'code' =>'XXXX',
        #   'grant_type' =>'authorization_code'
        #   })
        #
        files = LikeModule::Share.getfiles("feedposts")
        files.each do |file|
          posts = JSON.parse(File.read(file))
          # Loop through all posts
          posts.each_with_index do |post,index|
            content_length = post['content_length']

            # All params dependes on your interest
            if post['i_like'] == true
              puts "Like #{post['ID']} : #{post['i_like']}"
              next
            end

            if (content_length < 80 && post['attachment_count'] < 3) || (content_length > 2000)
              puts "Content #{post['ID']} : #{content_length} #{post['attachment_count']}"
              next
            end

            if post['like_count'] > 5
              puts "Like Count #{post['ID']} : #{post['like_count']} "
              next
            end

            if post['content'].lang != "en" && post['content'].lang != "ja"
              puts "Language  #{post['ID']} : #{post['content'].lang}"
              next
            end

            access_token = ACCESS_TOKEN
            token_type = 'bearer'

            uri = URI.parse("https://public-api.wordpress.com/rest/v1.1/sites/#{post['site_ID']}/posts/#{post['ID']}/likes/new?pretty=1")
            req = Net::HTTP::Post.new(uri.request_uri)
            req['authorization'] = "#{token_type} #{access_token}"
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            # http.set_debug_output STDERR
            resp = http.start{|h| h.request(req)}
            # STDERR.puts resp.body

            # Check response code 2xx/3xx are ok and 401/404/500/etc are failure
            if resp.code.to_i < 400
              puts "[#{Util.now_datetime}] == Liked #{index + 1}:#{post['URL']}  =="
              File.open("output/liked.txt", 'a') do |file|
                file.puts "#{index + 1}:#{post['URL']}"
              end
            else
              puts "[#{Util.now_datetime}] == Post Like Failed URL:#{post['URL']} Status: #{resp.code} =="
            end

            if index != posts.length - 1
              # Avoid to like as spammer
              case content_length
              when 1..130
                sleep(1.minutes)
              when 131..260
                sleep(2.minutes)
              when 261..390
                sleep(3.minutes)
              when 391..520
                sleep(4.minutes)
              when 521..650
                sleep(5.minutes)
              when 651..1300
                sleep(10.minutes)
              when 1301..2000
                sleep(16.minutes)
              end
            end
          end
        end
      end
      # }}}
    end
  end
end
