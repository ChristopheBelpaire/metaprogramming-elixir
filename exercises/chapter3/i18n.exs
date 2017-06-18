defmodule I18n do
  use Translator

  locale "en",
    users: [
      title: {"User", "Users"}
    ]

  locale "fr",
    users: [
      title: {"Utilisateur", "Utilisateurs"}
    ]
end
