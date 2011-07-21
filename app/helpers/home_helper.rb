module HomeHelper

  def ajax_notifications_users_from_hash
    return @users_from_hash if @users_from_hash
    @users_from_hash = {}
    #users_from =  User.select([:id, :username, :first_name, :last_name, :user_photo_id])
    #                   .where(:id=>@pun_list.map(&:user_id_from))
    #                   .includes(:user_photo)
    
    users_from = User.kv_find(@pun_list.map(&:user_id_from).uniq)
    
    users_from.each do |user|
      @users_from_hash[user.id] = user
    end
    @users_from_hash
  end

end
