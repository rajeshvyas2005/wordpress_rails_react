# rake like:posts
namespace :like do
  desc "Import post data"
  task :posts => :environment do |t, args|
    puts "[#{Util.now_datetime}] == Start like post data =="
    LikeModule::Like.likeposts
    puts "[#{Util.now_datetime}] == End like post data =="
  end
end
