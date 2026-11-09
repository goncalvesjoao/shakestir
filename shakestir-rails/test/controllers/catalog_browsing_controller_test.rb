require "test_helper"

class CatalogBrowsingControllerTest < ActionDispatch::IntegrationTest
  test "public catalogs search by name and link to details" do
    [ ingredients(:one), utensils(:jigger), techniques(:shake) ].each do |resource|
      catalog = resource.model_name.route_key
      get "/#{catalog}", params: { q: resource.name.upcase }
      assert_response :success
      assert_select "a[href=?]", polymorphic_path(resource), text: resource.name
      assert_select ".primary-navigation a[aria-current='page']", text: { "ingredients" => "Ingredients", "utensils" => "Tools", "techniques" => "Methods" }.fetch(catalog)
      get polymorphic_path(resource)
      assert_response :success
      assert_select "h1", text: resource.name
      get "/#{catalog}", params: { q: "no matching resource" }
      assert_select ".empty-state h3", text: "No #{catalog} found."
    end
  end

  test "pagination preserves search and loads remaining results in matching frames" do
    25.times do |i|
      Technique.create!(name: "Pagination #{i.to_s.rjust(2, '0')}", slug: "pagination-#{i}", description: "Description", instructions: "Instructions")
    end
    get techniques_url, params: { q: "Pagination" }
    assert_response :success
    assert_select ".recipe-grid article", count: 24
    next_url = css_select("turbo-frame#techniques_page_2[loading='lazy']").sole["src"]
    assert_includes next_url, "q=Pagination"
    get next_url, headers: { "Turbo-Frame" => "techniques_page_2" }
    assert_response :success
    assert_select "turbo-frame#techniques_page_2 .recipe-grid article", count: 1
    assert_select "turbo-frame[loading='lazy']", count: 0
  end

  test "unusable catalog details return not found" do
    [ ingredients(:one), utensils(:jigger) ].each do |resource|
      resource.image.detach
      get polymorphic_path(resource)
      assert_response :not_found
    end
  end

  test "search treats wildcards literally" do
    get techniques_url, params: { q: "%" }
    assert_select ".recipe-grid article", count: 0
  end

  test "catalog search normalizes Unicode and repeated whitespace like cocktail search" do
    [ ingredients(:one), utensils(:jigger), techniques(:shake) ].each do |resource|
      resource.update!(name: "Ｃａｆé   Bar")
      get "/#{resource.model_name.route_key}", params: { q: "  CAFÉ    BAR  " }
      assert_response :success
      assert_select ".recipe-grid article", count: 1
      assert_select ".card-copy a[href=?]", polymorphic_path(resource)
      get "/#{resource.model_name.route_key}", params: { q: "   " }
      assert_response :success
      assert_select ".card-copy a[href=?]", polymorphic_path(resource)
    end
  end

  test "catalog cards expose detail panels with normal URL fallbacks" do
    [ ingredients(:one), utensils(:jigger), techniques(:shake) ].each do |resource|
      get "/#{resource.model_name.route_key}"
      assert_select "dialog#cocktail-panel iframe[data-cocktail-panel-target=frame]", count: 1
      assert_select ".card-copy a[href=?][data-action='cocktail-panel#open'][aria-haspopup=dialog]", polymorphic_path(resource)
      get polymorphic_path(resource, panel: "1")
      assert_response :success
      assert_select "body.cocktail-panel-content"
      assert_select "h1", text: resource.display_name
    end
  end

  test "ingredient details list only public published recipes using that ingredient once" do
    ingredient = ingredients(:one)
    recipe = recipes(:one)
    recipe.recipe_ingredients.create!(ingredient: ingredient, submitted_text: ingredient.name)
    get ingredient_url(ingredient)
    assert_response :success
    assert_select "#matching-recipes .compact-recipe-grid #recipe_#{recipe.id}", count: 1
    assert_select "#matching-recipes #recipe_#{recipes(:two).id}", count: 0
    assert_select "details#matching-recipes:not([open]) > summary", text: "Recipes (1)"
    recipe.update!(visibility: "private")
    sign_in_as(recipe.user)
    get ingredient_url(ingredient)
    assert_select "#matching-recipes article", count: 0
    recipe.update!(visibility: "public", publication_state: "draft")
    get ingredient_url(ingredient)
    assert_select "#matching-recipes article", count: 0
    assert_select "#matching-recipes p", text: "No recipes yet."
  end
end
