import { afterEach, expect, test, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { MemoryRouter } from "react-router";
import App from "./App";

function mountIngredients(rows: unknown[], status = 200) {
  const fetcher = vi.fn(async (input: RequestInfo | URL) => {
    if (String(input) !== "/api/ingredients")
      return new Response(JSON.stringify({ detail: "Not Found" }), { status: 404 });
    return new Response(JSON.stringify({ data: rows, metadata: { total_count: rows.length } }), { status });
  });
  vi.stubGlobal("fetch", fetcher);
  render(
    <QueryClientProvider client={new QueryClient({ defaultOptions: { queries: { retry: false } } })}>
      <MemoryRouter initialEntries={["/ingredients"]}><App /></MemoryRouter>
    </QueryClientProvider>,
  );
  return fetcher;
}
afterEach(() => vi.unstubAllGlobals());

test("loads Python ingredients and proxied images despite unavailable sessions, then filters locally", async () => {
  const fetcher = mountIngredients([
    { id: 1, name: "Gin", description: "Juniper spirit", image_url: "http://127.0.0.1:8000/ingredients/1/image" },
    { id: 2, name: "Pineapple Juice", description: null, image_url: null },
  ]);
  expect(await screen.findByRole("heading", { name: "Gin" })).toBeInTheDocument();
  expect(screen.getByRole("img", { name: "Gin" })).toHaveAttribute("src", "/api/ingredients/1/image");
  expect(screen.getByRole("heading", { name: "Pineapple Juice" })).toBeInTheDocument();
  await userEvent.setup().type(screen.getByRole("searchbox", { name: "Search ingredients" }), "GIN");
  expect(screen.queryByRole("heading", { name: "Pineapple Juice" })).not.toBeInTheDocument();
  expect(fetcher.mock.calls.filter(([url]) => String(url).startsWith("/api/ingredients"))).toHaveLength(1);
});

test("shows an empty ingredient catalog", async () => {
  mountIngredients([]);
  expect(await screen.findByText("No entries found.")).toBeInTheDocument();
});

test("reports ingredient API failures with a retry action", async () => {
  mountIngredients([], 500);
  expect(await screen.findByRole("button", { name: "Try again" })).toBeInTheDocument();
});
