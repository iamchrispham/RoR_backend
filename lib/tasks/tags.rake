namespace :tags do
  require 'securerandom'

  desc 'Create Random Tags'
  task generate_tags: :environment do
    (0..100).each do |_tag|
      random_string = SecureRandom.urlsafe_base64(6)
      Tag.find_or_create_by(text: random_string)
    end
  end

  desc 'Create Baseline Tags'
  task generate_baseline_tags: :environment do
    tags = ['Soccer',
            'cricket',
            'AFL',
            'football',
            'golf',
            'Hurling',
            'rugby',
            'snooker',
            'pool',
            'darts',
            'icehockey',
            'camogie',
            'hockey',
            'netball',
            'basketball',
            'boxing',
            'athletics',
            'cycling',
            'beachvolleyball',
            'mountainbike',
            'judo',
            'swimming',
            'triathlon',
            'wrestling',
            'archery',
            'horseracing',
            'fishing',
            'tennis',
            'gaelicfootball',
            'targetshooting',
            'MMA',
            'carracing',
            'motorcross',
            'formula1',
            'Rugbytour',
            'footballsociety',
            'teamsports',
            'whatgoesontourstaysontour',
            'notourtalk',
            'Nike',
            'Adidas',
            'newyorkyankees',
            'worldcup',
            'manchesterunited',
            'realmadrid',
            'F.C. Barcelona',
            'Chelseafc',
            'arsenalfc',
            'Liverpoolfc',
            'conormcgregor']

    tags.each do |tag|
      Tag.find_or_create_by(text: tag)
    end
  end
end
