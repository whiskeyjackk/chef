# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "kfox"
client_key               "#{current_dir}/kfox.pem"
validation_client_name   "skynet-validator"
validation_key           "#{current_dir}/skynet-validator.pem"
chef_server_url          "https://chefserver.chefgoruby.com/organizations/skynet"
cookbook_path            ["#{current_dir}/../cookbooks"]
knife[:digital_ocean_access_token]  = File.open("#{current_dir}/access_token", "rb").read
