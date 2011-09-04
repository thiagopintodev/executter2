namespace :ex2 do
namespace :city do

  desc "imports all city-bases from a location into the current database"
  task :import, [:location] => [:environment] do |t, args|
    return 'CSV file location required' unless location = args[:location]
    f_or_io = open(location)
    
    while line = f_or_io.readline rescue nil
      CityBase.create_from_csv_line(line)
    end
    
    puts "done"
  end

end
end
