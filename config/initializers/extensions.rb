# require all .rb files from app/lib/extensions folder
Dir[File.join(Rails.root, "app", "lib", "extensions", "**", "*.rb")].each { |l| require l }
