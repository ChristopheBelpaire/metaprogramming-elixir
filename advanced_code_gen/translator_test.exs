ExUnit.start
Code.require_file("translator.exs", __DIR__)

defmodule TranslatorTest do
  use ExUnit.Case

  defmodule I18n do
    use Translator
    locale "en", [
      foo: "bar",
      flash: [
        notice: [
          alert: "Alert!",
          hello: "Hello %{first} %{last}!"
        ]
      ],
      users: [
        title: "Users",
        profile: [
          title: "Profiles"
        ]
      ]
    ]
    locale "fr", [
      flash: [
        notice: [
          hello: "Salut %{first} %{last}!"
        ]
      ]]
  end

  test "it recursively walks translations tree" do
    assert I18n.t("en", "users.title") == "Users"
    assert I18n.t("en", "users.profile.title") == "Profiles"
  end

  test "it handles translations at root level" do
    assert I18n.t("en", "foo") == "bar"
  end

  test "it allos multiple locales to be registred" do
    assert I18n.t("fr", "flash.notice.hello", first: "Jaclyn", last: "M") == "Salut Jaclyn M!"
  end

  test "it interpolates bindings" do
    assert I18n.t("en", "flash.notice.hello", first: "Jason", last: "S") == "Hello Jason S!"
  end

  test "t/3 raises KeyError when bindings not provided" do
    assert_raise KeyError, fn -> I18n.t("en", "flash.notice.hello") end
  end

  test "t/3 returns {:error, :no_translations} when translation is missing" do
    assert I18n.t("en", "flash.not_exists") == {:error, :no_translations}
  end

  test "convertd interpolations to string" do
    assert I18n.t("en", "flash.notice.hello", first: 123, last: 456) == "Hello 123 456!"
  end
end
