module AttachmentsHelper
  def recipe_attachment_path(recipe, **kwargs)
    attachment_name = kwargs.delete(:attachment_name) || :image

    return recipe_image_path(recipe, **kwargs) if recipe.public_send(attachment_name).attached?

    return recipe_image_path(recipe.cocktail, **kwargs) if recipe.cocktail.public_send(attachment_name).attached?

    asset_path("placeholders/recipe.jpg")
  end

  def cocktail_attachment_path(cocktail, **kwargs)
    attachment_name = kwargs.delete(:attachment_name) || :image

    return cocktail_image_path(cocktail, **kwargs) if cocktail.public_send(attachment_name).attached?

    asset_path("placeholders/cocktail.jpg")
  end

  def ingredient_attachment_path(ingredient, **kwargs)
    attachment_name = kwargs.delete(:attachment_name) || :image

    return ingredient_image_path(ingredient, **kwargs) if ingredient.public_send(attachment_name).attached?

    asset_path("placeholders/ingredient.jpg")
  end

  def utensil_attachment_path(utensil, **kwargs)
    attachment_name = kwargs.delete(:attachment_name) || :image

    return utensil_image_path(utensil, **kwargs) if utensil.public_send(attachment_name).attached?

    asset_path("placeholders/utensil.jpg")
  end
end
