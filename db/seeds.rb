Rake.application['db:fixtures:load'].invoke unless Rails.env.production?
