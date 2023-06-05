FactoryBot.define do
  factory :user do
    sequence(:firebase_uid) { |n| "firebaseUid#{n}" }
    name { "John Doe" }
  end
end
