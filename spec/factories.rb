FactoryGirl.define do
  factory :user do
    name     "Karen Wood"
    email    "northernyoga@gmail.com"
    password "foobar"
    password_confirmation "foobar"
  end

  factory :eval_test do
    name "Evaluation Test"
    description "This is how you do it do it!!"
    user
  end
end