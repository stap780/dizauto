require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "create_export" do
    mail = UserMailer.create_export
    assert_equal "Create export", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
