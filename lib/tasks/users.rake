namespace :users do
  desc 'Create Age Ranges'
  task create_user_age_ranges: :environment do

    puts '###################'
    puts 'Creating Age Ranges'
    UserAgeRange.find_or_create_by(name: 'Under 16 years old', start_age: 0, end_age: 15)
    UserAgeRange.find_or_create_by(name: '16-21 years old', start_age: 16, end_age: 21)
    UserAgeRange.find_or_create_by(name: '22-34 years old', start_age: 22, end_age: 34)
    UserAgeRange.find_or_create_by(name: '35-45 years old', start_age: 35, end_age: 45)
    UserAgeRange.find_or_create_by(name: '46 years or older', start_age: 46, end_age: 1000)
  end
end
