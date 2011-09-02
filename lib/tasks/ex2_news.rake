namespace :ex2 do
namespace :news do

  desc 'mails once users with unread notifications'
  task :email => :environment do
=begin
    pun_grouping_post       = cu.post_user_news
                                .where('post_id IS NOT NULL')
                                .where(:is_read=>false, :is_mailed=>false)
                                .select('post_id, reason_why, reason_trigger, max(user_id_from) as user_id_from, max(created_at) as created_at, count(*)')
                                .group('post_id, reason_why, reason_trigger')
                                .order('created_at DESC')
                                .limit(6)
=end
    pun_grouping_following = PUN.where('post_id IS NULL')
                                .where(:is_read=>false, :is_mailed=>false)
                                .select('user_id, user_id_from, reason_why, reason_trigger, count(*)')
                                .group( 'user_id, user_id_from, reason_trigger, reason_why')
    puts "sending #{pun_grouping_following.length} notifications about following"
    pun_grouping_following.each do |pun|
      I18n.locale = pun.user.locale
      MyM.notification(pun).deliver
      PUN.update_all({:is_mailed=>true}, { :user_id => pun.user_id, :user_id_from => pun.user_id_from, :reason_why => pun.reason_why})
    end  
    #@users_from = User.where(:id=>@pun_grouping.map(&:user_id_from))

    #PUN.update_all({:is_mailed=>true}, {:user_id=>cu.id, :user_id_from=>@pun_grouping.map(&:user_id_from)})
    puts "done"
  end
  
end
end
