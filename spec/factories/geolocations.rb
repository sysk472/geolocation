FactoryBot.define do
  factory :geolocation do
    ip    { '195.245.224.52' }
    url   { 'stackoverflow.com' }
    data  {
      "{\"ip\": \"195.245.224.52\", \"type\": \"ipv4\", \"continent_code\": \"EU\", \"continent_name\": \"Europe\", \"country_code\": \"PL\", \"country_name\": \"Poland\", \"region_code\": \"SL\", \"region_name\": \"Silesia\", \"city\": \"Katowice\", \"zip\": \"40-389\", \"latitude\": 50.25569152832031, \"longitude\": 19.10357093811035, \"location\": {\"geoname_id\": 3096472, \"capital\": \"Warsaw\", \"languages\": [{\"code\": \"pl\", \"name\": \"Polish\", \"native\": \"Polski\"}], \"country_flag\": \"https://assets.ipstack.com/flags/pl.svg\", \"country_flag_emoji\": \"\\ud83c\\uddf5\\ud83c\\uddf1\", \"country_flag_emoji_unicode\": \"U+1F1F5 U+1F1F1\", \"calling_code\": \"48\", \"is_eu\": true}}"
    }

    trait :'195.245.224.53' do
      ip { '195.245.224.53'}
      data  {
      "{\"ip\": \"195.245.224.53\", \"type\": \"ipv4\", \"continent_code\": \"EU\", \"continent_name\": \"Europe\", \"country_code\": \"PL\", \"country_name\": \"Poland\", \"region_code\": \"SL\", \"region_name\": \"Silesia\", \"city\": \"Katowice\", \"zip\": \"40-389\", \"latitude\": 50.25569152832031, \"longitude\": 19.10357093811035, \"location\": {\"geoname_id\": 3096472, \"capital\": \"Warsaw\", \"languages\": [{\"code\": \"pl\", \"name\": \"Polish\", \"native\": \"Polski\"}], \"country_flag\": \"https://assets.ipstack.com/flags/pl.svg\", \"country_flag_emoji\": \"\\ud83c\\uddf5\\ud83c\\uddf1\", \"country_flag_emoji_unicode\": \"U+1F1F5 U+1F1F1\", \"calling_code\": \"48\", \"is_eu\": true}}"
    }
    end

    trait :'151.101.1.69' do
      ip { '151.101.1.69'}
      data  {
      "{\"ip\": \"151.101.1.69\", \"type\": \"ipv4\", \"continent_code\": \"EU\", \"continent_name\": \"Europe\", \"country_code\": \"PL\", \"country_name\": \"Poland\", \"region_code\": \"SL\", \"region_name\": \"Silesia\", \"city\": \"Katowice\", \"zip\": \"40-389\", \"latitude\": 50.25569152832031, \"longitude\": 19.10357093811035, \"location\": {\"geoname_id\": 3096472, \"capital\": \"Warsaw\", \"languages\": [{\"code\": \"pl\", \"name\": \"Polish\", \"native\": \"Polski\"}], \"country_flag\": \"https://assets.ipstack.com/flags/pl.svg\", \"country_flag_emoji\": \"\\ud83c\\uddf5\\ud83c\\uddf1\", \"country_flag_emoji_unicode\": \"U+1F1F5 U+1F1F1\", \"calling_code\": \"48\", \"is_eu\": true}}"
    }
    end
  end
end