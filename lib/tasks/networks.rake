require 'open-uri'

namespace :networks do

  task :ping => :environment do
    open('http://www.dayable.com')
  end

end
