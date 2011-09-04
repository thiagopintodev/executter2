aws_access = 'AKIAIWSMKSF6O5TY7XXA'
aws_secret = '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'

ActionMailer::Base.add_delivery_method  :ses,
                                        AWS::SES::Base,
                                        :access_key_id     => aws_access,
                                        :secret_access_key => aws_secret
