# rake export:feed
namespace :export do
  desc "Export feed data"
  task :feed => :environment do |t, args|
    puts "[#{Util.now_datetime}] == Start exporting feed data =="
    ExportModule::Feedposts.export()
    puts "[#{Util.now_datetime}] == End exporting feed data =="
  end
end
