require 'json'
require 'net/http'
require 'uri'
require 'date'
module ExportModule
  module Feedposts
    class << self
      OUTPUTDIR = "output/exported"
      def export()
        arr = []
        Dir.mkdir(OUTPUTDIR) unless File.exists?(OUTPUTDIR)
        # Get all post for login user reader panel
        tag_name = "travel"
        url = URI.parse("https://public-api.wordpress.com/rest/v1.1/read/tags/#{tag_name}/posts?http_envelope=1&pretty=1&number=40")
        req = Net::HTTP::Get.new(url.to_s)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        # http.set_debug_output STDERR
        res = http.start{|h| h.request(req)}

        posts = JSON.parse(res.body)["body"]["posts"]
        posts.each_with_index {|post,index|
          # # Get post text without html tag
          full_sanitizer = Rails::Html::FullSanitizer.new
          content = full_sanitizer.sanitize(post["content"])
          arr << {
            :ID => post["ID"],
            :site_ID => post["site_ID"],
            :title => post["title"],
            :URL => post["URL"],
            :content => content.split[0...20].join(' '),
            :content_length => content.split(/\s+/).length,
            :likes_enabled => post["likes_enabled"],
            :like_count => post["like_count"],
            :i_like => post["i_like"],
            :is_following => post["is_following"],
            :global_ID => post["global_ID"],
            :tag_count => post["tags"].length,
            :site_URL => post["site_URL"],
            :attachment_count => post["attachments"].length
          }

          puts "[#{Util.now_datetime}] == Export POST ID:#{post["ID"]}  Counter: #{index + 1}=="
        }

        pretty_json_str =  JSON.pretty_generate(arr)
        File.open("#{OUTPUTDIR}/feedposts.json", 'w') do |file|
          file.puts pretty_json_str
        end
      end
    end
  end
end
