require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "every footer destination is readable without an account" do
    get new_session_url
    assert_response :success
    paths = css_select("footer nav a").map { |link| link["href"] }
    assert_equal [ terms_path, privacy_path, cookies_path, community_guidelines_path, responsible_drinking_path, help_path ], paths

    paths.each do |path|
      get path
      assert_response :success
      assert_select "main h1", count: 1
      assert_select "footer nav[aria-label='Policies and help']", count: 1
      assert_select "a[href=?]", root_path
    end
  end

  test "legal pages clearly disclose their draft status" do
    [ terms_path, privacy_path, cookies_path ].each do |path|
      get path
      assert_select ".policy-notice", text: /Draft for review/
    end
  end

  test "policy pages remain available with an authenticated session" do
    sign_in_as(users(:one))
    get privacy_url
    assert_response :success
    assert_select "a[href=?]", my_account_path
  end

  test "configured operator details and contacts appear across policy pages" do
    values = {
      "SHAKESTIR_OPERATOR_NAME" => "Alex Example",
      "SHAKESTIR_OPERATOR_COUNTRY" => "Example Country",
      "SHAKESTIR_SUPPORT_EMAIL" => "hello@shakestir.example"
    }
    previous = ENV.to_h.slice(*values.keys)
    begin
      ENV.update(values)
      [ terms_path, privacy_path, cookies_path, help_path ].each do |path|
        get path
        assert_response :success
        assert_select "section p", text: /operated by Alex Example, based in Example Country/
        assert_select "a[href='mailto:hello@shakestir.example']"
      end
      [ community_guidelines_path, responsible_drinking_path ].each do |path|
        get path
        assert_response :success
        assert_select "a[href='mailto:hello@shakestir.example']"
      end
    ensure
      values.each_key { |key| ENV.delete(key) }
      ENV.update(previous)
    end
  end
end
