require 'json'
require 'net/http'
module LikeModule
  module Share
    class << self
      # {{{ def getfiles
      def getfiles(file)
        # Dir.glob("output/exported/*").select{|e| e =~ /#{file}_\d+.json/}
        Dir.glob("output/exported/*")
      end
    end
  end
end
