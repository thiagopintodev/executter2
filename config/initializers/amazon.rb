if My.production?
  ActionMailer::Base.add_delivery_method  :ses,
                                          AWS::SES::Base,
                                          MyConfig.get_aws_credentials
end
