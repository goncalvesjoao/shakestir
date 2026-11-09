# Browsing cover assets

Generated with the built-in image generation tool. Five 1536 × 1024 JPEGs live in `app/assets/images/covers/`. These are static Propshaft assets, independent of Active Storage uploads.

Use `image_tag "covers/cocktails.jpg", alt: ""` for decorative imagery, or `asset_path("covers/cocktails.jpg")` in a view for a background URL. Available names: cocktails, ingredients, recipes, utensils, techniques. Keep headings as real HTML. Subjects sit toward the right with quiet space on the left. Use `object-fit: cover` and adjust cropping to the final layout; narrow mobile layouts may need text above the image.

These assets are ready for integration; no browsing views have been changed. Ingredients, utensils, and techniques currently expose JSON index endpoints rather than HTML browsing pages.

## Generation prompts

### cocktails

Use case: photorealistic-natural. Asset type: wide landscape background cover for ShakeStir cocktail browsing app. Create one premium editorial still-life photograph, landscape 3:2. Warm ivory limestone backdrop (#f7f5ee), muted olive accents (#4d5b2e), natural afternoon side light, soft authentic shadows, tactile linen and glass, restrained sophisticated styling. Objects grouped in right half with generous quiet ivory negative space across left half for dark page heading added by app. Camera slightly above tabletop. No text, letters, labels, logos, watermarks, borders, collage or UI. Subject: three finished classic cocktails: amber old fashioned in low rocks glass with one large ice cube and orange twist, pale martini in fine stemmed glass with olive, ruby negroni. An elegant small curated group, realistic distinct glassware.

### ingredients

Use case: photorealistic-natural. Asset type: wide landscape background cover for ShakeStir cocktail browsing app. Create one premium editorial still-life photograph, landscape 3:2. Warm ivory limestone backdrop (#f7f5ee), muted olive accents (#4d5b2e), natural afternoon side light, soft authentic shadows, tactile linen and glass, restrained sophisticated styling. Objects grouped in right half with generous quiet ivory negative space across left half for dark page heading added by app. Camera slightly above tabletop. No text, letters, labels, logos, watermarks, borders, collage or UI. Subject: fresh cocktail ingredients arranged naturally: whole and halved lemon and lime, orange with curling peel, mint sprigs, rosemary, small glass bowl of sugar, a small unlabeled amber bitters bottle. Fresh botanical detail.

### recipes

Use case: photorealistic-natural. Asset type: wide landscape background cover for ShakeStir cocktail browsing app. Create one premium editorial still-life photograph, landscape 3:2. Warm ivory limestone backdrop (#f7f5ee), muted olive accents (#4d5b2e), natural afternoon side light, soft authentic shadows, tactile linen and glass, restrained sophisticated styling. Objects grouped in right half with generous quiet ivory negative space across left half for dark page heading added by app. Camera slightly above tabletop. No text, letters, labels, logos, watermarks, borders, collage or UI. Subject: a cocktail recipe in preparation as a tabletop still life: blank open cream notebook with absolutely no writing, a pencil, small clear jigger of amber liquid, cut lemon, a finished pale gold coupe cocktail. Emphasize the pleasure of discovering and making a recipe.

### utensils

Use case: photorealistic-natural. Asset type: wide landscape background cover for ShakeStir cocktail browsing app. Create one premium editorial still-life photograph, landscape 3:2. Warm ivory limestone backdrop (#f7f5ee), muted olive accents (#4d5b2e), natural afternoon side light, soft authentic shadows, tactile linen and glass, restrained sophisticated styling. Objects grouped in right half with generous quiet ivory negative space across left half for dark page heading added by app. Camera slightly above tabletop. No text, letters, labels, logos, watermarks, borders, collage or UI. Subject: curated essential bar utensils: polished stainless steel Boston shaker tins, double sided jigger, Hawthorne strainer with realistic coil, twisted long bar spoon and small wooden muddler. Tools resting naturally on folded olive linen, no drinks.

### techniques

Use case: photorealistic-natural. Asset type: wide landscape background cover for ShakeStir cocktail browsing app. Create one premium editorial still-life photograph, landscape 3:2. Warm ivory limestone backdrop (#f7f5ee), muted olive accents (#4d5b2e), natural afternoon side light, soft authentic shadows, tactile linen and glass, restrained sophisticated styling. Objects grouped in right half with generous quiet ivory negative space across left half for dark page heading added by app. Camera slightly above tabletop. No text, letters, labels, logos, watermarks, borders, collage or UI. Subject: close detail of the stirring technique, a long twisted bar spoon tilted inside a realistic clear cut-glass mixing vessel filled with large ice cubes and amber cocktail, a fine mesh strainer and peeled orange alongside. No hands or people; the composition conveys craft and movement through a slight swirl in the liquid.

