if @comment.persisted?
    json.form render(partial: "comments/form", formats: :html, locals: {restaurant: @restaurant, comment: Comment.new})
    json.inserted_item render(partial: "comments/comment", formats: :html, locals: {comment: @comment})
  else
    json.form render(partial: "comment/form", formats: :html, locals: {restaurant: @restaurant, comment: @comment})
  end