class Settings < Settingslogic
  source "#{Rails.root}/config/jah.yml"
  namespace Rails.env
end
