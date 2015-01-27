class LikesController < ApplicationController
  def create
    positive = request.original_url.match('/like/') ? true : false
    like_or_dislike = current_user.likes_or_dislikes.where(target_type: params[:target_type], target_id: params[:target_id]).first
    
    if like_or_dislike
      like_or_dislike.update_attribute(:positive, positive)
    else
      current_user.likes_or_dislikes.create!(positive: positive, target_type: params[:target_type], target_id: params[:target_id])
    end
    
    render nothing: true
  end
  
  def destroy
    like_or_dislike = current_user.likes_or_dislikes.where(target_type: params[:target_type], target_id: params[:target_id]).first
    
    raise ActiveRecord::RecordNotFound unless like_or_dislike
    
    like_or_dislike.destroy!
    render nothing: true
  end
end