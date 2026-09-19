{
  # Argon2-Hash fuer die Admin-Seite von Vaultwarden (Compose im docker-Repo),
  # erzeugt mit `vaultwarden hash`. Der Container bindet die Datei ein.
  # uid wie `user:` des Containers, sonst kann Vaultwarden die Datei nicht lesen.
  sops.secrets.vaultwarden-admin-token.uid = 10002;
}
