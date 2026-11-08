import { expect, test } from "@playwright/test";

test("seeded FastAPI ingredients load, images render, and names filter", async ({ page }) => {
  await page.goto("/ingredients");
  await expect(page.getByRole("heading", { name: "Gin", exact: true })).toBeVisible();
  await expect(page.getByRole("heading", { name: "Pineapple Juice", exact: true })).toBeVisible();
  const photo = page.getByRole("img", { name: "Gin", exact: true });
  await photo.scrollIntoViewIfNeeded();
  await expect.poll(() => photo.evaluate((image: HTMLImageElement) => image.naturalWidth)).toBeGreaterThan(0);
  await page.getByRole("searchbox", { name: "Search ingredients" }).fill("GIN");
  await expect(page.getByRole("heading", { name: "Gin", exact: true })).toBeVisible();
  await expect(page.getByRole("heading", { name: "Pineapple Juice", exact: true })).toHaveCount(0);
});
