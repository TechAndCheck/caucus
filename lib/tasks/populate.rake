namespace :populate do
  desc "Assign an avatar to anyone that doesn't have one."
  task avatar: :environment do
    User.all.each do |user|
      # `assign_avatar` is a private method, so we just send it instead.
      user.send :assign_avatar unless user.avatar.attached?
      user.save!
    end
  end
end
