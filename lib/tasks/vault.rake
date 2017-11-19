namespace :vault do
  desc 'Encrypt config/secrets.raw.yml -> config/secrets.yml'
  task encrypt: :environment do
    sh "bundle exec yaml_vault encrypt config/secrets.raw.yml -o config/secrets.yml --cryptor #{Settings.yaml_vault.cryptor} --aws-kms-key-id #{Settings.yaml_vault.aws_kms_key_id}"
  end

  desc 'Decrypt config/secrets.yml -> config/secrets.raw.yml'
  task decrypt: :environment do
    sh "bundle exec yaml_vault decrypt config/secrets.yml -o config/secrets.raw.yml --cryptor #{Settings.yaml_vault.cryptor} --aws-kms-key-id #{Settings.yaml_vault.aws_kms_key_id}"
  end

  desc 'Show decrypted secret values'
  task show: :environment do
    pp Rails.application.secrets
  end
end
