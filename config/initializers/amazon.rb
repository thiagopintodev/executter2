if My.aws
  aws = YAML.load_file(My.aws)
  ActionMailer::Base.add_delivery_method  :ses,
                                          AWS::SES::Base,
                                          :access_key_id     => aws["access_key_id"],
                                          :secret_access_key => aws["secret_access_key_id"]
end
