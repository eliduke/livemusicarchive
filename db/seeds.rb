10.times.to_a.each do
  Band.create!(
    name: Faker::Games::Pokemon.unique.name + rand(99).to_s,
    location: "#{Faker::Games::Pokemon.unique.location}, #{Faker::Address.state_abbr}",
    bio: Faker::TvShows::NewGirl.unique.quote,
    website: Faker::Internet.unique.url,
    bandcamp: [nil, "https://bandcamp.com/#{Faker::Internet.user_name}"].sample,
    facebook: [nil, "https://facebook.com/#{Faker::Internet.user_name}"].sample,
    soundcloud: [nil, "https://soundcloud.com/#{Faker::Internet.user_name}"].sample,
    instagram: [nil, "https://instagram.com/#{Faker::Internet.user_name}"].sample,
    twitter: [nil, "https://twitter.com/#{Faker::Internet.user_name}"].sample
  )
end

10.times.to_a.each do
  Venue.create!(
    name: Faker::TvShows::RickAndMorty.unique.location + rand(99).to_s,
    location: "#{Faker::Games::Pokemon.unique.location}, #{Faker::Address.state_abbr}",
    info: Faker::TvShows::NewGirl.unique.quote,
    website: Faker::Internet.unique.url,
    facebook: [nil, "https://facebook.com/#{Faker::Internet.user_name}"].sample,
    instagram: [nil, "https://instagram.com/#{Faker::Internet.user_name}"].sample,
    twitter: [nil, "https://twitter.com/#{Faker::Internet.user_name}"].sample
  )
end

15.times.to_a.each do |index|
  show = Show.new(
    name: index.even? ? nil : "#{Faker::Books::Lovecraft.deity} #{Faker::Books::Lovecraft.deity} #{Date.today.year - (1..10).to_a.sample}",
    date: Date.today - (1..50).to_a.sample.days,
    venue: Venue.all.to_a.sample
  )

  show.bands << Band.all.shuffle.first((2..4).to_a.sample)

  show.save!

  video_urls = [
    "https://www.youtube.com/watch?v=jLlrCmPFfDs",
    "https://www.youtube.com/watch?v=Utwf-ZJ1etw",
    "https://www.youtube.com/watch?v=WhiSpkbZ2IE",
    "https://www.youtube.com/watch?v=Z3_Ov15uYPM",
    "https://www.youtube.com/watch?v=Z3_Ov15uYPM",
    "https://www.youtube.com/watch?v=fML3ck0wHxU",
    "https://www.youtube.com/watch?v=GGiIVu_z1jQ",
    "https://www.youtube.com/watch?v=T0Ovybb6RgQ",
    "https://www.youtube.com/watch?v=UshoIynPUUc",
    "https://www.youtube.com/watch?v=FPIISeTu6AA",
    "https://www.youtube.com/watch?v=pwGhM3QEAdA"
  ]

  show.bands.each do |band|
    rand(5).times.each do
      band.videos.create!(
        show: show,
        url: video_urls.sample,
        name: Faker::Games::Zelda.unique.character
      )
    end
  end
end

[1,2,3,4].each do |index|
  Feature.create(name: "video-#{index}", target_id: index)
end

User.create(
  username: 'eli', email: 'eli@test.com',
  password: 'poop', password_confirmation: 'poop', admin: true
)

15.times do
  Supporter.create(name: Faker::TvShows::RickAndMorty.unique.character)
end
