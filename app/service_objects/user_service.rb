class UserService < ApiService
  include Api::DoorkeeperHelper

  def user_by_identifier(id)
    id.eql?('me') ? current_api_user : User.find_by(id: id)
  end

  def block_user(user)
    #remove any friend requests
    current_api_user.friend_requests.where(friend: user).destroy_all
    current_api_user.pending_friend_requests.where(user: user).destroy_all

    #remove friend
    current_api_user.remove_friend(user)
  end
end
